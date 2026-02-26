import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';

// --- DATA STRUCTURE FOR PARTICLES ---
class Particle {
  double x;
  double y;
  double size;
  double speed;
  double angle;
  double spinSpeed;
  double opacity;
  bool isCube;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.spinSpeed,
    required this.opacity,
    required this.isCube,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLogin = true;
  bool _isLoading = false;
  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  // --- THEME COLORS ---
  // --- THEME COLORS ---
  final Color _primaryColor = const Color(0xFFEC407A);
  final Color _accentColor = const Color(0xFFF48FB1);
  final Color _lightBackgroundColorStart = const Color(0xFFF8BBD0);
  final Color _lightBackgroundColorEnd = const Color(0xFFAD1457);

  final Color _darkBackgroundColorStart = const Color(0xFF2C1E22);
  final Color _darkBackgroundColorEnd = const Color(0xFF000000);

  // --- ANIMATION CONTROLLERS ---
  late AnimationController _mainController;
  final List<Particle> _particles = [];
  final int _particleCount = 30; // "WAY MORE" items

  @override
  void initState() {
    super.initState();

    // 1. Setup Main Animation Loop
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // 2. Generate Random Particles
    final rng = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          x: rng.nextDouble(), // 0.0 to 1.0 (screen width percentage)
          y: rng.nextDouble(), // 0.0 to 1.0 (screen height percentage)
          size: rng.nextDouble() * 40 + 10, // Size 10 to 50
          speed: rng.nextDouble() * 0.2 + 0.05, // Random upward speed
          angle: rng.nextDouble() * math.pi * 2, // Initial rotation
          spinSpeed:
              (rng.nextDouble() - 0.5) * 4, // Random spin direction/speed
          opacity: rng.nextDouble() * 0.3 + 0.1, // Random opacity
          isCube: rng.nextBool(), // 50% chance of cube vs circle
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() => _profileImageBytes = bytes);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (_isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // AuthWrapper handles navigation
        } else {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

          String? profileImageUrl;

          // Upload image to Firebase Storage if available
          if (_profileImageBytes != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('profile_images')
                .child('${userCredential.user!.uid}.jpg');

            UploadTask uploadTask = storageRef.putData(_profileImageBytes!);
            TaskSnapshot snapshot = await uploadTask;
            profileImageUrl = await snapshot.ref.getDownloadURL();
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'profileImageUrl': profileImageUrl,
                'createdAt': FieldValue.serverTimestamp(),
              });
          if (mounted) _showSnackBar('Account created!', Colors.green);
        }
      } catch (e) {
        if (mounted) _showSnackBar(e.toString(), Colors.redAccent);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Check if we're on Web - signInWithPopup ONLY works on Web!
      if (!kIsWeb) {
        throw 'Google Sign-In with popup is only supported on Web (Chrome). Please run this app in Chrome or use email/password login on Windows.';
      }

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Using signInWithPopup as requested by the user logic
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithPopup(googleProvider);

      // Check if user exists in Firestore, if not create
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'name': userCredential.user!.displayName ?? 'Google User',
              'email': userCredential.user!.email,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      if (mounted) {
        // AuthWrapper will handle the redirect
      }
    } catch (e) {
      if (mounted) _showSnackBar(e.toString(), Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for particle math
    final Size screenSize = MediaQuery.of(context).size;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents background squishing
      body: Stack(
        children: [
          // 1. Deep Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [_darkBackgroundColorStart, _darkBackgroundColorEnd]
                    : [_lightBackgroundColorStart, _lightBackgroundColorEnd],
              ),
            ),
          ),

          // 2. THE PARTICLE SYSTEM (The "Way More")
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return Stack(
                children: [
                  // A. The Giant Gyroscope Rings (Background)
                  _buildGyroscopeRing(screenSize, 300, 1.0),
                  _buildGyroscopeRing(screenSize, 450, -0.7),
                  _buildGyroscopeRing(screenSize, 600, 0.5),

                  // B. The Floating Particles
                  ..._particles.map((particle) {
                    // Calculate dynamic position based on time
                    double time = _mainController.value;

                    // Vertical Movement (Looping)
                    // We move Y upwards. (1.0 - time) makes it go up.
                    // We add particle.speed to randomize rate.
                    double newY = (particle.y - (time * particle.speed)) % 1.0;
                    if (newY < 0) newY += 1.0;

                    // Horizontal Wobble (Sine Wave)
                    double newX =
                        particle.x +
                        (math.sin((time * 5) + particle.angle) * 0.05);

                    return Positioned(
                      top: newY * screenSize.height,
                      left: newX * screenSize.width,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective
                          ..rotateX(
                            (time * particle.spinSpeed) + particle.angle,
                          )
                          ..rotateY(
                            (time * particle.spinSpeed) + particle.angle,
                          ),
                        child: Container(
                          width: particle.size,
                          height: particle.size,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: particle.opacity,
                            ),
                            // If it's a cube, borderRadius is small. If sphere, it's 50%.
                            borderRadius: BorderRadius.circular(
                              particle.isCube ? 8 : particle.size / 2,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: particle.opacity * 1.5,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withValues(alpha: 0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          // 3. Glassmorphism Blur Layer (Optional: Makes text readable)
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ), // Subtle blur on particles
            child: Container(color: Colors.transparent),
          ),

          // 4. Main Foreground UI
          SafeArea(
            child: Stack(
              children: [
                // Back Button
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // --- PROFILE IMAGE ---
                        GestureDetector(
                          onTap: _isLogin ? null : _pickImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Rotating Glow Ring around profile
                              RotationTransition(
                                turns: _mainController,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _profileImageBytes != null
                                      ? MemoryImage(_profileImageBytes!)
                                      : null,
                                  child: _profileImageBytes == null
                                      ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color: _primaryColor,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- GLASS CARD ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color:
                                    (isDarkMode ? Colors.black : Colors.white)
                                        .withValues(
                                          alpha: 0.85,
                                        ), // Glass opacity
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      (isDarkMode
                                              ? Colors.grey[800]!
                                              : Colors.white)
                                          .withValues(alpha: 0.6),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      _isLogin
                                          ? 'Hello There!'
                                          : 'Start Journey',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.grey[800],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),

                                    if (!_isLogin) ...[
                                      _buildTextField(
                                        _nameController,
                                        'Full Name',
                                        Icons.person_outline,
                                        isDarkMode,
                                      ),
                                      const SizedBox(height: 16),
                                    ],

                                    _buildTextField(
                                      _emailController,
                                      'Email',
                                      Icons.email_outlined,
                                      isDarkMode,
                                    ),
                                    const SizedBox(height: 16),

                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'password'.tr(),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: _accentColor,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: _accentColor,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: isDarkMode
                                            ? Colors.grey[900]
                                            : Colors.pink[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 8,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              _isLogin ? 'LOGIN' : 'SIGN UP',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 16),

                                    // OR Divider
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            'OR',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Google Sign In Button
                                    OutlinedButton.icon(
                                      onPressed: _signInWithGoogle,
                                      icon: Image.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                                        height: 20,
                                      ),
                                      label: Text(
                                        'sign_in_with_google'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Toggle Button
                        GestureDetector(
                          onTap: () => setState(() => _isLogin = !_isLogin),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _isLogin ? "Create an Account" : "Back to Login",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the giant background rings
  Widget _buildGyroscopeRing(Size screenSize, double size, double speedMult) {
    return Positioned(
      top: (screenSize.height - size) / 2,
      left: (screenSize.width - size) / 2,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_mainController.value * 2 * math.pi * speedMult)
          ..rotateY(_mainController.value * 2 * math.pi * (speedMult * 0.5)),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05), // Very faint
              width: 20, // Thick faint lines
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isDarkMode,
  ) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        ),
        prefixIcon: Icon(icon, color: _accentColor),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.pink[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

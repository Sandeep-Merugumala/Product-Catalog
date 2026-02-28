import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

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

  // Star animation
  late AnimationController _starController;
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    // Stars scroll continuously – 40 s for a full loop feels natural
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _starController.dispose();
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? f = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (f != null) {
      final bytes = await f.readAsBytes();
      setState(() => _profileImageBytes = bytes);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        final uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        String? imgUrl;
        if (_profileImageBytes != null) {
          final ref = FirebaseStorage.instance.ref().child(
            'profile_images/${uc.user!.uid}.jpg',
          );
          imgUrl = await (await ref.putData(
            _profileImageBytes!,
          )).ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uc.user!.uid)
            .set({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'profileImageUrl': imgUrl,
              'createdAt': FieldValue.serverTimestamp(),
            });
        if (mounted) _snack('Account created!', Colors.green);
      }
    } catch (e) {
      if (mounted) _snack(e.toString(), Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      UserCredential uc;
      if (kIsWeb) {
        await FirebaseAuth.instance.signOut();
        uc = await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        final g = await GoogleSignIn().signIn();
        if (g == null) {
          setState(() => _isLoading = false);
          return;
        }
        final ga = await g.authentication;
        uc = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: ga.accessToken,
            idToken: ga.idToken,
          ),
        );
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uc.user!.uid)
          .get();
      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uc.user!.uid)
            .set({
              'name': uc.user!.displayName ?? 'Google User',
              'email': uc.user!.email,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) _snack(e.toString(), Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, Color color) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF111318),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Deep sky background ──
          Container(color: const Color(0xFF060B14)),

          // ── Animated starfield ──
          AnimatedBuilder(
            animation: _starController,
            builder: (_, __) => CustomPaint(
              painter: _StarfieldPainter(_starController.value),
              size: size,
            ),
          ),

          // ── Very subtle dark overlay so card stays readable ──
          Container(color: Colors.black.withValues(alpha: 0.10)),

          // ── Content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          // LoginPage is the root — go to HomeScreen and clear stack
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildCard(),
                        const SizedBox(height: 24),
                        _buildToggleRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _isLogin ? null : _pickImage,
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: _profileImageBytes != null
                      ? ClipOval(
                          child: Image.memory(
                            _profileImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                ),
                if (!_isLogin)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF667EEA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isLogin ? 'Sign in' : 'Create account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _isLogin ? 'Good to see you again' : 'Start your shopping journey',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ─── Card ─────────────────────────────────
  Widget _buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_isLogin) ...[
                  _inputField(
                    controller: _nameController,
                    label: 'Full name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 14),
                ],
                _inputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Valid email required'
                      : null,
                ),
                const SizedBox(height: 14),
                _inputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscurePassword,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 22),
                _primaryButton(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _googleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.4),
          size: 18,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667EEA), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 11),
      ),
    );
  }

  Widget _primaryButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _isLogin ? 'Sign in' : 'Create account',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _signInWithGoogle,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
              height: 18,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.g_mobiledata, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Toggle ───────────────────────────────
  Widget _buildToggleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? "Don't have an account? " : 'Already a member? ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() => _isLogin = !_isLogin);
            _fadeController.reset();
            _fadeController.forward();
          },
          child: const Text(
            'Click here',
            style: TextStyle(
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// PAINTER: Moving starfield
// Stars are seeded from a fixed Random so they never jump between frames.
// t goes 0.0 → 1.0 looping; each star drifts upward at its own speed.
// ─────────────────────────────────────────────────────────────────────────
class _StarfieldPainter extends CustomPainter {
  final double t; // 0.0 → 1.0

  static final _rng = math.Random(42); // fixed seed keeps positions stable
  static const int _count = 180;

  static final List<double> _sx = List.generate(
    _count,
    (_) => _rng.nextDouble(),
  ); // x fraction
  static final List<double> _sy = List.generate(
    _count,
    (_) => _rng.nextDouble(),
  ); // y fraction
  static final List<double> _sz = List.generate(
    _count,
    (_) => _rng.nextDouble() * 1.8 + 0.3,
  ); // radius
  static final List<double> _sp = List.generate(
    _count,
    (_) => _rng.nextDouble() * 0.28 + 0.08,
  ); // speed
  static final List<double> _op = List.generate(
    _count,
    (_) => _rng.nextDouble() * 0.55 + 0.35,
  );
  static final List<bool> _twinkle = List.generate(
    _count,
    (_) => _rng.nextBool(),
  );

  _StarfieldPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _count; i++) {
      double y = (_sy[i] - t * _sp[i]) % 1.0;
      if (y < 0) y += 1.0;
      final double x = _sx[i] * size.width;
      final double py = y * size.height;
      final double r = _sz[i];

      double opacity = _op[i];
      if (_twinkle[i]) {
        opacity *= 0.55 + 0.45 * math.sin(t * 2 * math.pi * 2.5 + i * 1.7);
      }

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..maskFilter = r > 1.2
            ? const MaskFilter.blur(BlurStyle.normal, 0.8)
            : null;

      canvas.drawCircle(Offset(x, py), r, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}

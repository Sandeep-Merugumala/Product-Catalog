import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:project_map/core/widgets/chatbot.dart';

// --- SCREEN IMPORTS ---
// Make sure these paths match your project structure shown in the screenshots
import 'package:project_map/features/product_catalog/presentation/screens/men_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/winter_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/women_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/kids_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/sports_catalog_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/electronics_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/fashion_catalog_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _santaController;
  late AnimationController _snowController;
  late AnimationController _shimmerController;
  late AnimationController _rotationController;
  late AnimationController _headerController;
  bool _isSantaFlying = false;
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _santaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
        _headerController.forward();
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
        _headerController.reverse();
      }
    });
  }

  void _playMagic() {
    setState(() => _isSantaFlying = true);
    _confettiController.play();
    _rotationController.forward(from: 0);
    _santaController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isSantaFlying = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _santaController.dispose();
    _snowController.dispose();
    _shimmerController.dispose();
    _rotationController.dispose();
    _headerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                floating: true,
                pinned: true,
                elevation: _showElevation ? 8 : 0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.blue.shade50.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.shopping_bag, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "ShopLuxe",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Text(
                                      "Premium Shopping",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                _buildIconButton(Icons.favorite_border, Colors.red.shade400, 2),
                                const SizedBox(width: 8),
                                _buildIconButton(Icons.shopping_cart_outlined, Colors.blue.shade400, 3),
                                const SizedBox(width: 8),
                                _buildIconButton(Icons.notifications_outlined, Colors.orange.shade400, 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const ModernSearchBar(),
                    const SizedBox(height: 20),
                    // UPDATED: Quick Categories (Removed Electronics)
                    const QuickCategories(),
                    const SizedBox(height: 16),
                    const EnhancedFullScreenSlider(),
                    const SizedBox(height: 24),
                    const FlashDealsSection(),
                    const SizedBox(height: 24),
                    const SectionHeader(
                        title: "Winter Specials",
                        icon: Icons.ac_unit,
                        gradient: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                    AnimatedWinterBanner(snowController: _snowController),
                    const SizedBox(height: 24),
                    const SectionHeader(
                        title: "Holiday Magic",
                        icon: Icons.celebration,
                        gradient: [Color(0xFFD32F2F), Color(0xFFFF5252)]),
                    EnhancedChristmasMagicCard(
                      onTap: _playMagic,
                      shimmerController: _shimmerController,
                      rotationController: _rotationController,
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(
                        title: "Shop by Category",
                        icon: Icons.grid_view,
                        gradient: [Color(0xFF7B1FA2), Color(0xFFBA68C8)]),
                    // UPDATED: Category Grid (Linked Electronics & Fashion)
                    const EnhancedCategoryGrid(),
                    const SizedBox(height: 24),
                    const SectionHeader(
                        title: "Trending Now",
                        icon: Icons.local_fire_department,
                        gradient: [Color(0xFFFF6F00), Color(0xFFFFAB40)]),
                    const TrendingProductsGrid(),
                    const SizedBox(height: 24),
                    const SectionHeader(
                        title: "Brand Spotlight",
                        icon: Icons.stars,
                        gradient: [Color(0xFF00897B), Color(0xFF4DB6AC)]),
                    const BrandShowcase(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          if (_isSantaFlying) _buildSantaAnimation(),
          if (_isSantaFlying) _buildConfettiEffects(),
          const Chatbot(),
        ],
      ),
      bottomNavigationBar: _buildModernBottomNav(),
      floatingActionButton: _buildFloatingCart(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIconButton(IconData icon, Color color, int badgeCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        if (badgeCount > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSantaAnimation() {
    return AnimatedBuilder(
      animation: _santaController,
      builder: (context, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        final progress = _santaController.value;
        final curve = Curves.easeInOutCubic.transform(progress);
        final x = -150 + (screenWidth + 300) * curve;
        final y = screenHeight * 0.15 + math.sin(curve * math.pi) * 80;
        return Positioned(
          left: x,
          top: y,
          child: Transform.scale(
            scale: 1.0 + math.sin(progress * math.pi * 6) * 0.08,
            child: Transform.rotate(
              angle: math.sin(progress * math.pi * 4) * 0.15,
              child: const Row(
                children: [
                  Text("🎁", style: TextStyle(fontSize: 35)),
                  SizedBox(width: 5),
                  Text("🎅", style: TextStyle(fontSize: 85)),
                  Text("🛷", style: TextStyle(fontSize: 70)),
                  Text("💨", style: TextStyle(fontSize: 60)),
                  SizedBox(width: 5),
                  Text("🔔", style: TextStyle(fontSize: 35)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfettiEffects() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 4,
            blastDirectionality: BlastDirectionality.directional,
            colors: const [Colors.red, Colors.green, Colors.amber, Colors.white, Colors.blue, Colors.pink],
            numberOfParticles: 25,
            maxBlastForce: 25,
            minBlastForce: 15,
            emissionFrequency: 0.03,
            gravity: 0.3,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3 * math.pi / 4,
            blastDirectionality: BlastDirectionality.directional,
            colors: const [Colors.red, Colors.green, Colors.amber, Colors.white, Colors.blue, Colors.pink],
            numberOfParticles: 25,
            maxBlastForce: 25,
            minBlastForce: 15,
            emissionFrequency: 0.03,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.blue.shade600,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCart() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade600,
        elevation: 8,
        child: const Icon(Icons.shopping_bag, size: 28),
      ),
    );
  }
}

// --- WIDGETS ---

class ModernSearchBar extends StatelessWidget {
  const ModernSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for products, brands...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.qr_code_scanner, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.mic_none, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}

// --- QUICK CATEGORIES (Removes Electronics, Keeps Men/Women/Kids) ---
class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Men',
        'img': 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=400',
        'color': Colors.blue,
        'screen': const MenScreen(),
      },
      {
        'name': 'Women',
        'img': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400',
        'color': Colors.pink,
        'screen': const WomenScreen(),
      },
      {
        'name': 'Kids',
        'img': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?q=80&w=400',
        'color': Colors.green,
        'screen': const KidsScreen(),
      },
    ];

    return Center(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categories.map((cat) {
              return AnimatedCategoryItem(
                name: cat['name'] as String,
                imageUrl: cat['img'] as String,
                color: cat['color'] as Color,
                screen: cat['screen'] as Widget,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class AnimatedCategoryItem extends StatefulWidget {
  final String name;
  final String imageUrl;
  final Color color;
  final Widget screen;

  const AnimatedCategoryItem({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.color,
    required this.screen,
  });

  @override
  State<AnimatedCategoryItem> createState() => _AnimatedCategoryItemState();
}

class _AnimatedCategoryItemState extends State<AnimatedCategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 10.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => widget.screen,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(_isHovered ? 0.5 : 0.3),
                            blurRadius: _elevationAnimation.value,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: _isHovered ? widget.color : Colors.white,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Stack(
                          children: [
                            Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: _isHovered
                                    ? LinearGradient(
                                        colors: [
                                          widget.color.withOpacity(0.3),
                                          widget.color.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                        fontSize: _isHovered ? 15 : 14,
                        color: _isHovered ? widget.color : Colors.black87,
                      ),
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- ENHANCED CATEGORY GRID (Links Electronics & Fashion) ---
class EnhancedCategoryGrid extends StatelessWidget {
  const EnhancedCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = [
      {
        'n': 'Electronics',
        'img': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=600',
        'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        'screen': const ElectronicsScreen(),
      },
      {
        'n': 'Fashion',
        'img': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=600',
        'gradient': [const Color(0xFFf093fb), const Color(0xFff5576c)],
        'screen': const FashionCatalogScreen(),
      },
      {
        'n': 'Beauty',
        'img': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600',
        'gradient': [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
        'screen': null, 
      },
      {
        'n': 'Sports',
        'img': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=600',
        'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'screen': const SportsCatalogScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, i) {
          return AnimatedCategoryCard(
            name: cats[i]['n']! as String,
            imageUrl: cats[i]['img']! as String,
            gradient: cats[i]['gradient']! as List<Color>,
            screen: cats[i]['screen'] as Widget?,
          );
        },
      ),
    );
  }
}

class AnimatedCategoryCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final List<Color> gradient;
  final Widget? screen;

  const AnimatedCategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.gradient,
    this.screen,
  });

  @override
  State<AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.screen != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.screen != null) {
          setState(() => _isHovered = true);
          _controller.forward();
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.screen != null
            ? () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => widget.screen!,
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: SlideTransition(position: offsetAnimation, child: child),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              }
            : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: widget.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.gradient[0].withOpacity(_isHovered ? 0.6 : 0.4),
                        blurRadius: _isHovered ? 24 : 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _isHovered ? 0.4 : 0.3,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: _isHovered ? 24 : 22,
                                ),
                                child: Text(widget.name),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(
                                  horizontal: _isHovered ? 16 : 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(_isHovered ? 0.4 : 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Explore",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(left: _isHovered ? 8 : 4),
                                      child: const Text(
                                        "→",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isHovered)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    widget.gradient[0].withOpacity(0.3),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EnhancedFullScreenSlider extends StatefulWidget {
  const EnhancedFullScreenSlider({super.key});

  @override
  State<EnhancedFullScreenSlider> createState() => _EnhancedFullScreenSliderState();
}

class _EnhancedFullScreenSliderState extends State<EnhancedFullScreenSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final banners = [
      {
        'img': "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=2070",
        'title': 'New Season',
        'subtitle': 'Up to 50% Off',
        'color': Colors.blue,
      },
      {
        'img': "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999",
        'title': 'Tech Deals',
        'subtitle': 'Latest Gadgets',
        'color': Colors.purple,
      },
      {
        'img': "https://images.unsplash.com/photo-1491553895911-0055eca6402d?q=80&w=1780",
        'title': 'Fashion Week',
        'subtitle': 'Exclusive Collection',
        'color': Colors.orange,
      },
    ];

    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
          items: banners.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (banner['color'] as Color).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.network(
                      banner['img'] as String,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            banner['subtitle'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == entry.key ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _current == entry.key
                      ? (entry.value['color'] as Color)
                      : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FlashDealsSection extends StatefulWidget {
  const FlashDealsSection({super.key});

  @override
  State<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends State<FlashDealsSection> {
  late Timer _timer;
  Duration _duration = const Duration(hours: 2, minutes: 45, seconds: 30);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _duration = _duration - const Duration(seconds: 1);
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "FLASH DEALS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatDuration(_duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),

            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 185,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400",
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "-60%",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "\$49",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "\$120",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SnowPainter extends CustomPainter {
  final double animationValue;
  final List<Snowflake> snowflakes = [];

  SnowPainter(this.animationValue) {
    for (int i = 0; i < 60; i++) {
      snowflakes.add(Snowflake(i));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (var flake in snowflakes) {
      final x = (flake.x * size.width + animationValue * flake.speed * 30) % size.width;
      final y = (flake.y * size.height + animationValue * flake.fallSpeed * 600) % size.height;
      canvas.drawCircle(Offset(x, y), flake.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double fallSpeed;

  Snowflake(int seed)
      : x = (seed * 0.123) % 1.0,
        y = (seed * 0.456) % 1.0,
        size = 2.0 + (seed % 3),
        speed = 0.3 + (seed % 5) * 0.1,
        fallSpeed = 1.0 + (seed % 4) * 0.3;
}

class AnimatedWinterBanner extends StatelessWidget {
  final AnimationController snowController;
  const AnimatedWinterBanner({super.key, required this.snowController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=1000",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: snowController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SnowPainter(snowController.value),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "❄️ WINTER COLLECTION",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Stay Warm\nStay Stylish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Up to 70% off on winter essentials",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    // UPDATED: Navigation logic added here
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WinterEssentialsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Shop Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingProductsGrid extends StatelessWidget {
  const TrendingProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Smart Watch Pro', 'price': '\$299', 'rating': '4.8', 'img': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'},
      {'name': 'Wireless Earbuds', 'price': '\$149', 'rating': '4.6', 'img': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400'},
      {'name': 'Designer Handbag', 'price': '\$199', 'rating': '4.9', 'img': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400'},
      {'name': 'Running Sneakers', 'price': '\$129', 'rating': '4.7', 'img': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        products[i]['img']!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              products[i]['rating']!,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[i]['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            products[i]['price']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade600, Colors.purple.shade600],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = [
      {
        'name': 'Nike',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/1200px-Logo_NIKE.svg.png'
      },
      {
        'name': 'Apple',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/800px-Apple_logo_black.svg.png'
      },
      {
        'name': 'Adidas',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/1200px-Adidas_Logo.svg.png'
      },
      {
        'name': 'Samsung',
        'logo': 'https://images.samsung.com/is/image/samsung/assets/global/about-us/brand/logo/samsung_logo_lettermark_en_blue.png'
      },
      {
        'name': 'Sony',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Sony_logo.svg/1200px-Sony_logo.svg.png'
      },
      {
        'name': 'Gucci',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/1960s_Gucci_Logo.svg/2560px-1960s_Gucci_Logo.svg.png'
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          return Container(
            width: 110, // Increased slightly for better logo fit
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(
                      brands[index]['logo']!,
                      fit: BoxFit.contain,
                      // Optional: Placeholder while loading
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey.shade300));
                      },
                      // Optional: Error icon if link fails
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    brands[index]['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  const SectionHeader({super.key, required this.title, required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class EnhancedChristmasMagicCard extends StatelessWidget {
  final VoidCallback onTap;
  final AnimationController shimmerController;
  final AnimationController rotationController;
  const EnhancedChristmasMagicCard({
    super.key,
    required this.onTap,
    required this.shimmerController,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFC62828), Color(0xFFB71C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: shimmerController,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment(
                          -1.5 + shimmerController.value * 3,
                          -0.5,
                        ),
                        end: Alignment(-0.5 + shimmerController.value * 3, 0.5),
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Column(
              children: [
                AnimatedBuilder(
                  animation: rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: rotationController.value * math.pi * 2,
                      child: child,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("🎄", style: TextStyle(fontSize: 40)),
                      SizedBox(width: 12),
                      Text("🎁", style: TextStyle(fontSize: 45)),
                      SizedBox(width: 12),
                      Text("🎄", style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Holiday Magic! 🎅",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tap to spread festive joy!",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Unwrap Magic",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("✨", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
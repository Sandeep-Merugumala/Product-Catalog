import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

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
  bool _isSantaFlying = false;
  int _currentIndex = 0;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Discover", style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.favorite_border, color: Colors.black),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AISearchBar(),
                
                // Categories centered in the middle
                const QuickCategories(),

                const FullScreenSlider(),
                
                const SizedBox(height: 20),
                
                const SectionHeader(title: "Winter Specials", icon: Icons.ac_unit),
                
                // Winter Banner with the "previous" image
                AnimatedWinterBanner(snowController: _snowController),

                const SectionHeader(title: "Holiday Magic", icon: Icons.celebration),
                
                EnhancedChristmasMagicCard(
                  onTap: _playMagic,
                  shimmerController: _shimmerController,
                  rotationController: _rotationController,
                ),

                const SectionHeader(title: "Shop by Category", icon: Icons.grid_view),
                const EnhancedCategoryGrid(),
                
                const SectionHeader(title: "Trending Now", icon: Icons.whatshot),
                const TrendingProductsGrid(),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
          if (_isSantaFlying)
            AnimatedBuilder(
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
            ),
          if (_isSantaFlying) ...[
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
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [Colors.red, Colors.green, Colors.amber, Colors.white, Colors.blue, Colors.pink],
                numberOfParticles: 30,
                maxBlastForce: 30,
                minBlastForce: 20,
                emissionFrequency: 0.02,
                gravity: 0.25,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

// 1. Quick Categories - CENTERED
class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Men', 'img': 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=400'},
      {'name': 'Women', 'img': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400'},
      {'name': 'Kids', 'img': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?q=80&w=400'},
    ];

    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      // Changed from ListView to Row with MainAxisAlignment.center
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          return Container(
            width: 110,
            // Added margin to both sides for even spacing
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      children: [
                        Image.network(
                          cat['img']!,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
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

class FullScreenSlider extends StatefulWidget {
  const FullScreenSlider({super.key});

  @override
  State<FullScreenSlider> createState() => _FullScreenSliderState();
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final images = [
      "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=2070",
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999",
      "https://images.unsplash.com/photo-1491553895911-0055eca6402d?q=80&w=1780",
    ];

    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 280,
            autoPlay: true,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
          items: images.map((url) => Container(
            width: MediaQuery.of(context).size.width,
            child: Image.network(url, fit: BoxFit.cover),
          )).toList(),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == entry.key ? 28 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _current == entry.key ? Colors.black : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 2. Animated Winter Banner (Confirmed Previous Image)
class AnimatedWinterBanner extends StatelessWidget {
  final AnimationController snowController;
  const AnimatedWinterBanner({super.key, required this.snowController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned.fill(
              // The previous original image:
              child: Image.network(
                "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=1000",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  
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
              bottom: 30,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "NEW ARRIVALS",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Winter Collection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Exclusive 2024 Winter Collection",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: const Text("Explore Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFC62828), Color(0xFFB71C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment(-1.5 + shimmerController.value * 3, -0.5),
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
                      Text("🎄", style: TextStyle(fontSize: 45)),
                      SizedBox(width: 15),
                      Text("🎁", style: TextStyle(fontSize: 50)),
                      SizedBox(width: 15),
                      Text("🎄", style: TextStyle(fontSize: 45)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Merry Christmas!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tap to spread holiday cheer! ✨",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Unwrap Magic",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("🎅", style: TextStyle(fontSize: 22)),
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

class EnhancedCategoryGrid extends StatelessWidget {
  const EnhancedCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = [
      {'n': 'Electronics', 'img': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=600', 'color': Colors.blue},
      {'n': 'Footwear', 'img': 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=600', 'color': Colors.orange},
      {'n': 'Beauty', 'img': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600', 'color': Colors.pink},
      {'n': 'Accessories', 'img': 'https://images.unsplash.com/photo-1523206489230-c012c64b2b48?w=600', 'color': Colors.purple},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (cats[i]['color'] as Color).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(cats[i]['img']! as String, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cats[i]['n']! as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Explore →",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
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
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_border, size: 18, color: Colors.red),
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

class AISearchBar extends StatelessWidget {
  const AISearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "Search for products...",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const Icon(Icons.mic_none, color: Colors.grey),
          const SizedBox(width: 15),
          const Icon(Icons.camera_alt_outlined, color: Colors.grey),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 35, 16, 15),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text("See All", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
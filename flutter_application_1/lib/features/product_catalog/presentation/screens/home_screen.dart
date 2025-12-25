import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import 'dart:math' as math;

// --- SCREEN IMPORTS ---
// Make sure these paths match your project structure shown in the screenshots
import 'package:project_map/features/product_catalog/presentation/screens/men_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/winter_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/women_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/kids_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/sports_catalog_screen.dart';
import 'package:project_map/features/product_catalog/presentation/screens/electronics_screen.dart';
import 'package:project_map/features/product_catalog/presentation/widgets/skeleton_product_card.dart';
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

  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;

  bool _isLoading = true;
  late AnimationController _skeletonController;
  late Animation<double> _skeletonAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
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

    // Skeleton Animation
    _skeletonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    _skeletonAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: _skeletonController,
      curve: Curves.easeInOutSine,
    ));

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
      }
    });
  }

  void _playMagic() {
    _rotationController.forward(from: 0);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _santaController.dispose();
    _snowController.dispose();
    _shimmerController.dispose();
    _rotationController.dispose();

    _skeletonController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF0F5), // Light pinkish/white background
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              elevation: 0,
              backgroundColor: const Color(0xFFFFF0F5),
              toolbarHeight: 70,
              titleSpacing: 16,
              title: Row(
                children: [
                  // SEARCH BAR with Embedded Logo
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 6),
                          // LOGO inside search bar
                          Container(
                            height: 38,
                            width: 38,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.pinkAccent]),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                "M",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Search \"Jeans\"",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(Icons.search,
                                color: Colors.grey.shade600, size: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // ICONS ROW
                  Stack(
                    children: [
                      const Icon(Icons.notifications_outlined,
                          size: 28, color: Colors.black87),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: const Text('3',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.favorite_border,
                      size: 28, color: Colors.black87),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_outline,
                      size: 28, color: Colors.black87),
                ],
              ),
            ),
          ],
          body: Container(
            color: const Color(0xFFFFF0F5),
            child: Column(
              children: [
                // NAV BAR + Grid Icon
                const CategoryNavBar(),

                // Content area
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // Optional: Rounded top corners for the content sheet
                      // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: _isLoading
                          ? _buildSkeletonLoader()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: QuickCategories(),
                                ),
                                const SizedBox(height: 16),
                                const EnhancedFullScreenSlider(),
                                const SizedBox(height: 24),
                                const FlashDealsSection(),
                                const SizedBox(height: 24),
                                const SectionHeader(
                                    title: "Winter Specials",
                                    icon: Icons.ac_unit,
                                    gradient: [
                                      Color(0xFF1976D2),
                                      Color(0xFF42A5F5)
                                    ]),
                                AnimatedWinterBanner(
                                    snowController: _snowController),
                                const SizedBox(height: 24),
                                const SectionHeader(
                                    title: "Holiday Magic",
                                    icon: Icons.celebration,
                                    gradient: [
                                      Color(0xFFD32F2F),
                                      Color(0xFFFF5252)
                                    ]),
                                EnhancedChristmasMagicCard(
                                  onTap: _playMagic,
                                  shimmerController: _shimmerController,
                                  rotationController: _rotationController,
                                ),
                                const SizedBox(height: 24),
                                const SectionHeader(
                                    title: "Shop by Category",
                                    icon: Icons.grid_view,
                                    gradient: [
                                      Color(0xFF7B1FA2),
                                      Color(0xFFBA68C8)
                                    ]),
                                const EnhancedCategoryGrid(),
                                const SizedBox(height: 24),
                                const SectionHeader(
                                    title: "Trending Now",
                                    icon: Icons.local_fire_department,
                                    gradient: [
                                      Color(0xFFFF6F00),
                                      Color(0xFFFFAB40)
                                    ]),
                                const TrendingProductsGrid(),
                                const SizedBox(height: 24),
                                const SectionHeader(
                                    title: "Brand Spotlight",
                                    icon: Icons.stars,
                                    gradient: [
                                      Color(0xFF00897B),
                                      Color(0xFF4DB6AC)
                                    ]),
                                const BrandShowcase(),
                                const SizedBox(height: 100),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
      floatingActionButton: _buildFloatingCart(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          onTap: (index) {
            if (index != 2) {
              setState(() => _currentIndex = index);
            }
          },
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
              icon: SizedBox(height: 24), // Invisible placeholder for FAB
              label: "",
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
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade600,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.shopping_bag_outlined,
            color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Search Bar Skeleton
          ShimmerBox(
              height: 50, borderRadius: 16, animation: _skeletonAnimation),
          const SizedBox(height: 20),
          // Categories Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                4,
                (index) => Column(
                      children: [
                        ShimmerBox(
                            height: 70,
                            width: 70,
                            borderRadius: 35,
                            animation: _skeletonAnimation),
                        const SizedBox(height: 8),
                        ShimmerBox(
                            height: 10,
                            width: 50,
                            borderRadius: 4,
                            animation: _skeletonAnimation),
                      ],
                    )),
          ),
          const SizedBox(height: 20),
          // Banner Skeleton
          ShimmerBox(
              height: 200, borderRadius: 24, animation: _skeletonAnimation),
          const SizedBox(height: 24),
          // Section Title
          ShimmerBox(
              height: 20,
              width: 150,
              borderRadius: 4,
              animation: _skeletonAnimation),
          const SizedBox(height: 16),
          // Grid Skeleton
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) => ShimmerBox(
                height: 200, borderRadius: 20, animation: _skeletonAnimation),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS ---

class CategoryNavBar extends StatefulWidget {
  const CategoryNavBar({super.key});

  @override
  State<CategoryNavBar> createState() => _CategoryNavBarState();
}

class _CategoryNavBarState extends State<CategoryNavBar> {
  int _selectedIndex = 0;
  final List<String> _categories = ["All", "Men", "Women", "Kids"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      color: Colors.transparent, // Hit test behavior
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade400,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C), // Dark/Black color
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.grid_view_rounded,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

// ModernSearchBar is no longer used, so it's removed in this replacement which covers the area where it would be defined if I didn't remove it earlier.
// If it was present, this replacement will overwrite it cleaner.

// ModernSearchBar is no longer used, so it's removed in this replacement which covers the area where it would be defined if I didn't remove it earlier.
// If it was present, this replacement will overwrite it cleaner.

// --- QUICK CATEGORIES (Removes Electronics, Keeps Men/Women/Kids) ---
class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Fashion',
        'img':
            'https://images.unsplash.com/photo-1529139574466-a302c27e3844?w=400', // Models/Couple
        'color': const Color(0xFFFFE0E0), // Light coral bg
      },
      {
        'name': 'Beauty',
        'img':
            'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=400', // Cosmetics
        'color': const Color(0xFFFFF0F5), // Lavender blush
      },
      {
        'name': 'Home',
        'img':
            'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=400', // Interior decor
        'color': const Color(0xFFE0F7FA), // Light cyan
      },
      {
        'name': 'Footwear',
        'img':
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400', // Shoes
        'color': const Color(0xFFFFF8E1), // Light amber
      },
      {
        'name': 'Accessories',
        'img':
            'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400', // Handbag
        'color': const Color(0xFFF3E5F5), // Light purple
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _QuickCategoryItem(
            name: cat['name'] as String,
            imageUrl: cat['img'] as String,
            color: cat['color'] as Color,
          );
        },
      ),
    );
  }
}

class _QuickCategoryItem extends StatefulWidget {
  final String name;
  final String imageUrl;
  final Color color;

  const _QuickCategoryItem({
    required this.name,
    required this.imageUrl,
    required this.color,
  });

  @override
  State<_QuickCategoryItem> createState() => _QuickCategoryItemState();
}

class _QuickCategoryItemState extends State<_QuickCategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isHovered ? 0.3 : 0.0,
                    child: Container(color: Colors.black),
                  ),
                  if (_isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              widget.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  // Small overlay details if needed, but keeping it simple as per original visual intent
                  // The original code had specific text overlay which seemed disconnected from the small icon size of 75x75.
                  // 75x75 is too small for "Explore ->" and large text.
                  // I will trust the "pastel background + image" look and just add a subtle hover effect.
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class EnhancedFullScreenSlider extends StatefulWidget {
  const EnhancedFullScreenSlider({super.key});

  @override
  State<EnhancedFullScreenSlider> createState() =>
      _EnhancedFullScreenSliderState();
}

class _EnhancedFullScreenSliderState extends State<EnhancedFullScreenSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final banners = [
      {
        'img':
            "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=2070",
        'title': 'New Season',
        'subtitle': 'Up to 50% Off',
        'color': Colors.blue,
      },
      {
        'img':
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999",
        'title': 'Tech Deals',
        'subtitle': 'Latest Gadgets',
        'color': Colors.purple,
      },
      {
        'img':
            "https://images.unsplash.com/photo-1491553895911-0055eca6402d?q=80&w=1780",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
      final x = (flake.x * size.width + animationValue * flake.speed * 30) %
          size.width;
      final y =
          (flake.y * size.height + animationValue * flake.fallSpeed * 600) %
              size.height;
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
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
      {
        'name': 'Smart Watch Pro',
        'price': '\$299',
        'rating': '4.8',
        'img':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'
      },
      {
        'name': 'Wireless Earbuds',
        'price': '\$149',
        'rating': '4.6',
        'img':
            'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400'
      },
      {
        'name': 'Designer Handbag',
        'price': '\$199',
        'rating': '4.9',
        'img': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400'
      },
      {
        'name': 'Running Sneakers',
        'price': '\$129',
        'rating': '4.7',
        'img': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'
      },
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              products[i]['rating']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
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
                                colors: [
                                  Colors.blue.shade600,
                                  Colors.purple.shade600
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_shopping_cart,
                                size: 18, color: Colors.white),
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
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/1200px-Logo_NIKE.svg.png'
      },
      {
        'name': 'Apple',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/800px-Apple_logo_black.svg.png'
      },
      {
        'name': 'Adidas',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/1200px-Adidas_Logo.svg.png'
      },
      {
        'name': 'Samsung',
        'logo':
            'https://images.samsung.com/is/image/samsung/assets/global/about-us/brand/logo/samsung_logo_lettermark_en_blue.png'
      },
      {
        'name': 'Sony',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Sony_logo.svg/1200px-Sony_logo.svg.png'
      },
      {
        'name': 'Gucci',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/1960s_Gucci_Logo.svg/2560px-1960s_Gucci_Logo.svg.png'
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
                        return Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.grey.shade300));
                      },
                      // Optional: Error icon if link fails
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
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
  const SectionHeader(
      {super.key,
      required this.title,
      required this.icon,
      required this.gradient});

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

class EnhancedCategoryGrid extends StatelessWidget {
  const EnhancedCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Men',
        'icon': Icons.male,
        'color': Colors.blue,
        'screen': const MenScreen(),
      },
      {
        'name': 'Women',
        'icon': Icons.female,
        'color': Colors.pink,
        'screen': const WomenScreen(),
      },
      {
        'name': 'Kids',
        'icon': Icons.child_care,
        'color': Colors.orange,
        'screen': const KidsScreen(),
      },
      {
        'name': 'Sports',
        'icon': Icons.sports_soccer,
        'color': Colors.green,
        'screen': const SportsCatalogScreen(),
      },
      {
        'name': 'Electronics',
        'icon': Icons.electrical_services,
        'color': Colors.purple,
        'screen': const ElectronicsScreen(),
      },
      {
        'name': 'Fashion',
        'icon': Icons.checkroom,
        'color': Colors.teal,
        'screen': const FashionCatalogScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () {
              if (cat['screen'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => cat['screen'] as Widget),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: cat['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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

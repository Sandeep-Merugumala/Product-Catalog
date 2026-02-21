import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/firestore_service.dart';
import 'men_fashion_screen.dart';
import 'women_fashion_screen.dart';
import 'wishlist_page.dart';
import 'bag_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KidsSection extends StatefulWidget {
  const KidsSection({super.key});

  @override
  State<KidsSection> createState() => _KidsSectionState();
}

class _KidsSectionState extends State<KidsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            KidsFashionHeader(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  KidsAllProductsTab(),
                  KidsCategoryTab(category: 'Topwear'),
                  KidsCategoryTab(category: 'Bottomwear'),
                  KidsCategoryTab(category: 'Footwear'),
                  KidsCategoryTab(category: 'Accessories'),
                  KidsCategoryTab(category: 'Toys'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KidsFashionHeader extends StatefulWidget {
  final TabController tabController;

  const KidsFashionHeader({super.key, required this.tabController});

  @override
  State<KidsFashionHeader> createState() => _KidsFashionHeaderState();
}

class _KidsFashionHeaderState extends State<KidsFashionHeader> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF8E1),
            Theme.of(context).scaffoldBackgroundColor,
          ], // Amber 50
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Back, Logo, Search, Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFB300),
                        Color(0xFFF57C00),
                      ], // Amber to Dark Orange
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseAuth.instance.currentUser != null
                          ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots()
                          : null,
                      builder: (context, snapshot) {
                        String initial = 'M';
                        if (snapshot.hasData && snapshot.data!.data() != null) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          if (data.containsKey('name') &&
                              data['name'].toString().isNotEmpty) {
                            initial = data['name'].toString()[0].toUpperCase();
                          }
                        }
                        return Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Search Bar
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.grey[500], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Search \"Kids Fashion\"",
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildIconButton(Icons.notifications_outlined, () {}, 1),
                _buildIconButton(Icons.favorite_border, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistPage(),
                    ),
                  );
                }, 0),
                _buildIconButton(Icons.shopping_bag_outlined, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BagPage()),
                  );
                }, 0),
              ],
            ),
          ),

          // Row 2: Text Tabs (All, Men, Women, Kids)
          Container(
            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _buildTextTabItem("All", isSelected: false),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const MensSection(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: _buildTextTabItem("Men", isSelected: false),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const WomensSection(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: _buildTextTabItem("Women", isSelected: false),
                      ),
                      _buildTextTabItem("Kids", isSelected: true),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grid_view,
                    color: Colors.grey[800],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Image Tabs
          SizedBox(
            height: 128,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageTab(
                      0,
                      'All',
                      'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      1,
                      'Topwear',
                      'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      2,
                      'Bottomwear',
                      'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      3,
                      'Footwear',
                      'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      4,
                      'Accessories',
                      'https://images.unsplash.com/photo-1699796803856-d9017a3a022c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8a2lkcyUyMGFjY2Vzc29yaWVzJTIwbGlrZSUyMHdhdGNoZXN8ZW58MHx8MHx8fDA%3D',
                    ),
                    _buildImageTab(
                      5,
                      'Toys',
                      'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=500&auto=format&fit=crop',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextTabItem(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: isSelected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFB300), width: 3),
              ),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? const Color(0xFFFFB300)
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, int badgeCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color, size: 26),
            if (badgeCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB300),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTab(int index, String title, String imageUrl) {
    final bool isSelected = widget.tabController.index == index;
    return GestureDetector(
      onTap: () {
        widget.tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFB300)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFFFB300)
                    : Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KidsAllProductsTab extends StatelessWidget {
  const KidsAllProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: KidsFeaturedBanner()),
        const SliverToBoxAdapter(child: KidsCashbackOffer()),
        const SliverToBoxAdapter(child: KidsProductCategories()),
        const SliverToBoxAdapter(child: KidsBrandSection()),
        SliverToBoxAdapter(child: _buildSectionHeader(context, 'TRENDING NOW')),
        const KidsProductGrid(),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class KidsHorizontalCategories extends StatelessWidget {
  const KidsHorizontalCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Casual',
        'image':
            'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Party',
        'image':
            'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Sports',
        'image':
            'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=500&auto=format&fit=crop',
      },
      {
        'name': 'School',
        'image':
            'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Winter',
        'image':
            'https://images.unsplash.com/photo-1515488764276-beab7607c1e6?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Ethnic',
        'image':
            'https://images.unsplash.com/photo-1612902376581-0a3b8bb4d13d?w=500&auto=format&fit=crop',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: 95,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.network(
                        categories[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    categories[index]['name']!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class KidsFeaturedBanner extends StatefulWidget {
  const KidsFeaturedBanner({super.key});

  @override
  State<KidsFeaturedBanner> createState() => _KidsFeaturedBannerState();
}

class _KidsFeaturedBannerState extends State<KidsFeaturedBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'KIDS COLLECTION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800&auto=format&fit=crop',
                        'GAP KIDS',
                        'New Arrivals',
                        'Colorful Styles •',
                        '#FeaturedBrands',
                      ),
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=800&auto=format&fit=crop',
                        'MOTHERCARE',
                        'Party Collection',
                        'Special Occasions •',
                        '#Trending',
                      ),
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=800&auto=format&fit=crop',
                        'PUMA KIDS',
                        'Active Wear',
                        'Sports & Play •',
                        '#NewArrivals',
                      ),
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=800&auto=format&fit=crop',
                        'KIDS PLACE',
                        'School Ready',
                        'Back to School •',
                        '#Fashion',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.black87
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(
    String image,
    String brand,
    String title,
    String subtitle,
    String tag,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(image, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      brand,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class KidsCashbackOffer extends StatelessWidget {
  const KidsCashbackOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB300),
            Color(0xFFF57C00),
          ], // Amber to Dark Orange
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get 10%* Cashback On Myntra',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Use FOREVER CARD & PAY LATER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KidsProductCategories extends StatelessWidget {
  const KidsProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'T-Shirts',
        'image':
            'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Dresses',
        'image':
            'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Jeans',
        'image':
            'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Shoes',
        'image':
            'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500&auto=format&fit=crop',
      },
      {
        'name': 'Bags',
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&auto=format&fit=crop',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            categories[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        categories[index]['name']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KidsBrandSection extends StatelessWidget {
  const KidsBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = [
      {'name': 'GAP', 'subtitle': 'Under ₹799'},
      {'name': 'PUMA', 'subtitle': 'Sports'},
      {'name': 'UCB', 'subtitle': 'Trendy'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: brands.map((brand) {
          return Column(
            children: [
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: brand['name'] == 'GAP'
                              ? const Color(0xFFFFB300)
                              : Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          brand['name']![0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brand['name']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                brand['subtitle']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class KidsProductGrid extends StatelessWidget {
  final String? category;
  const KidsProductGrid({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final List<Map<String, dynamic>> allProducts = [
      // TOPWEAR
      {
        'image':
            'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500&auto=format&fit=crop',
        'brand': 'H&M Kids',
        'name': 'Boys Cotton T-Shirt',
        'price': 399,
        'originalPrice': 799,
        'discount': 50,
        'rating': 4.3,
        'reviews': 1260,
        'category': 'Topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=500&auto=format&fit=crop',
        'brand': 'GAP Kids',
        'name': 'Girls Graphic Sweatshirt',
        'price': 899,
        'originalPrice': 1999,
        'discount': 55,
        'rating': 4.2,
        'reviews': 890,
        'category': 'Topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500&auto=format&fit=crop',
        'brand': 'Mothercare',
        'name': 'Floral Print Dress',
        'price': 1499,
        'originalPrice': 2999,
        'discount': 50,
        'rating': 4.4,
        'reviews': 2200,
        'category': 'Topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1522771930-78848d9293e8?w=500&auto=format&fit=crop',
        'brand': 'UCB Kids',
        'name': 'Boys Striped Polo',
        'price': 799,
        'originalPrice': 1599,
        'discount': 50,
        'rating': 4.1,
        'reviews': 1100,
        'category': 'Topwear',
      },

      // BOTTOMWEAR
      {
        'image':
            'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=500&auto=format&fit=crop',
        'brand': 'Levis Kids',
        'name': 'Boys Slim Fit Jeans',
        'price': 1199,
        'originalPrice': 2199,
        'discount': 45,
        'rating': 4.3,
        'reviews': 1800,
        'category': 'Bottomwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=500&auto=format&fit=crop',
        'brand': 'Marks & Spencer',
        'name': 'Girls Cotton Shorts',
        'price': 599,
        'originalPrice': 999,
        'discount': 40,
        'rating': 4.0,
        'reviews': 750,
        'category': 'Bottomwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1643641437540-e72c6f3e01c4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8a2lkcyUyMGNhcmdvJTIwcGFudHN8ZW58MHx8MHx8fDA%3D',
        'brand': 'GAP Kids',
        'name': 'Boys Cargo Pants',
        'price': 1099,
        'originalPrice': 1999,
        'discount': 45,
        'rating': 4.2,
        'reviews': 950,
        'category': 'Bottomwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1503919005314-30d93d07d823?w=500&auto=format&fit=crop',
        'brand': 'Zara Kids',
        'name': 'Girls Denim Skirt',
        'price': 899,
        'originalPrice': 1499,
        'discount': 40,
        'rating': 4.4,
        'reviews': 1200,
        'category': 'Bottomwear',
      },

      // FOOTWEAR
      {
        'image':
            'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500&auto=format&fit=crop',
        'brand': 'Nike Kids',
        'name': 'Kids Sports Shoes',
        'price': 2495,
        'originalPrice': 4995,
        'discount': 50,
        'rating': 4.6,
        'reviews': 3100,
        'category': 'Footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1603808033192-082d6919d3e1?w=500&auto=format&fit=crop',
        'brand': 'Puma Kids',
        'name': 'Boys Running Shoes',
        'price': 1995,
        'originalPrice': 3995,
        'discount': 50,
        'rating': 4.5,
        'reviews': 2400,
        'category': 'Footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&auto=format&fit=crop',
        'brand': 'Crocs Kids',
        'name': 'Kids Clogs',
        'price': 1299,
        'originalPrice': 2499,
        'discount': 48,
        'rating': 4.2,
        'reviews': 1900,
        'category': 'Footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=500&auto=format&fit=crop',
        'brand': 'Bata Kids',
        'name': 'School Shoes',
        'price': 899,
        'originalPrice': 1499,
        'discount': 40,
        'rating': 4.0,
        'reviews': 2200,
        'category': 'Footwear',
      },

      // ACCESSORIES
      {
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&auto=format&fit=crop',
        'brand': 'Skybags',
        'name': 'Kids School Bag',
        'price': 1299,
        'originalPrice': 2499,
        'discount': 48,
        'rating': 4.4,
        'reviews': 2800,
        'category': 'Accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500&auto=format&fit=crop',
        'brand': 'Wildcraft',
        'name': 'Kids Bottle Pack',
        'price': 699,
        'originalPrice': 999,
        'discount': 30,
        'rating': 4.3,
        'reviews': 1500,
        'category': 'Accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1604482858862-1db908a653e4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8a2lkcyUyMHdpdGglMjBjYXBzfGVufDB8fDB8fHww',
        'brand': 'FabSeasons',
        'name': 'Kids Sun Cap',
        'price': 299,
        'originalPrice': 599,
        'discount': 50,
        'rating': 4.1,
        'reviews': 980,
        'category': 'Accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=500&auto=format&fit=crop',
        'brand': 'Titan Kids',
        'name': 'Kids Digital Watch',
        'price': 1599,
        'originalPrice': 2599,
        'discount': 38,
        'rating': 4.5,
        'reviews': 1800,
        'category': 'Accessories',
      },

      // TOYS
      {
        'image':
            'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=500&auto=format&fit=crop',
        'brand': 'LEGO',
        'name': 'City Building Blocks',
        'price': 2499,
        'originalPrice': 3999,
        'discount': 37,
        'rating': 4.8,
        'reviews': 5600,
        'category': 'Toys',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500&auto=format&fit=crop',
        'brand': 'Mattel',
        'name': 'Barbie Doll Set',
        'price': 1299,
        'originalPrice': 1999,
        'discount': 35,
        'rating': 4.6,
        'reviews': 4200,
        'category': 'Toys',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=500&auto=format&fit=crop',
        'brand': 'Hot Wheels',
        'name': 'Car Track Set',
        'price': 899,
        'originalPrice': 1499,
        'discount': 40,
        'rating': 4.4,
        'reviews': 3100,
        'category': 'Toys',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1530325553241-4f6e7690cf36?w=500&auto=format&fit=crop',
        'brand': 'Funskool',
        'name': 'Puzzle Game Set',
        'price': 499,
        'originalPrice': 799,
        'discount': 37,
        'rating': 4.2,
        'reviews': 1900,
        'category': 'Toys',
      },
    ];

    final products = category == null || category == 'All'
        ? allProducts
        : allProducts.where((p) => p['category'] == category).toList();

    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'No items found in $category',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.48,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index % products.length];
          return _buildProductCard(context, product, firestoreService);
        }, childCount: products.length),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> product,
    FirestoreService firestoreService,
  ) {
    // Determine the product title to use (some have 'name', some have 'title')
    final title = product['name'] ?? product['title'] ?? 'Product';
    final subtitle = product['brand'] ?? product['subtitle'] ?? '';
    // Ensure ID exists for Firestore operations
    if (!product.containsKey('id')) {
      product['id'] = '${subtitle}_$title'.hashCode.toString();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    product['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseAuth.instance.currentUser != null
                          ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('wishlist')
                                .doc(product['id'].toString())
                                .snapshots()
                          : null,
                      builder: (context, snapshot) {
                        bool isWishlisted = false;
                        if (snapshot.hasData && snapshot.data!.exists) {
                          isWishlisted = true;
                        }
                        return InkWell(
                          onTap: () async {
                            try {
                              if (isWishlisted) {
                                await firestoreService.removeFromWishlist(
                                  product['id'].toString(),
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Removed from Wishlist'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              } else {
                                await firestoreService.addToWishlist(product);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to Wishlist'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: isWishlisted
                                ? const Color(0xFFFF3F6C)
                                : Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['brand'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['name'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '₹${product['price']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${product['originalPrice']}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(${product['discount']}% OFF)',
                        style: const TextStyle(
                          color: Color(0xFFFF6F00),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // NEW ELEVATED BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            firestoreService
                                .addToCart(product)
                                .then((_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '✅ Added to Bag Successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                })
                                .catchError((e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('❌ Error: $e'),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFB300,
                            ), // Amber for Kids
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KidsCategoryTab extends StatelessWidget {
  final String category;
  const KidsCategoryTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFAFAFA),
            child: Row(
              children: [
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        KidsProductGrid(category: category),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}

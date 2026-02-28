import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_app/firestore_service.dart';
import 'women_fashion_screen.dart';
import 'kid_fashion_screen.dart';
import 'wishlist_page.dart';
import 'bag_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/widgets/sort_filter_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/widgets/product_search_bar.dart';

class MensSection extends StatefulWidget {
  final int? initialIndex;

  const MensSection({super.key, this.initialIndex});

  @override
  State<MensSection> createState() => _MensSectionState();
}

class _MensSectionState extends State<MensSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: widget.initialIndex ?? 0,
    );
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
            MensFashionHeader(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MensAllProductsTab(
                    onTabSelected: (index) {
                      _tabController.animateTo(index);
                    },
                  ),
                  const MensCategoryTab(category: 'topwear'),
                  const MensCategoryTab(category: 'Bottomwear'),
                  const MensCategoryTab(category: 'Footwear'),
                  const MensCategoryTab(category: 'Accessories'),
                  const MensCategoryTab(category: 'Grooming'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MensFashionHeader extends StatefulWidget {
  final TabController tabController;

  const MensFashionHeader({super.key, required this.tabController});

  @override
  State<MensFashionHeader> createState() => _MensFashionHeaderState();
}

class _MensFashionHeaderState extends State<MensFashionHeader> {
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
            const Color(0xFFE3F2FD),
            Theme.of(context).scaffoldBackgroundColor,
          ], // Blue 50
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
                      colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
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
                const Expanded(child: ProductSearchBar()),
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
                        child: _buildTextTabItem("all".tr(), isSelected: false),
                      ),
                      _buildTextTabItem("men".tr(), isSelected: true),
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
                        child: _buildTextTabItem(
                          "women".tr(),
                          isSelected: false,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const KidsSection(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: _buildTextTabItem(
                          "kids".tr(),
                          isSelected: false,
                        ),
                      ),
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
                      'all',
                      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      1,
                      'topwear',
                      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      2,
                      'bottomwear',
                      'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      3,
                      'footwear',
                      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      4,
                      'accessories',
                      'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=500&auto=format&fit=crop',
                    ),
                    _buildImageTab(
                      5,
                      'grooming',
                      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500&auto=format&fit=crop',
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
                bottom: BorderSide(color: Color(0xFF1E88E5), width: 3),
              ),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? const Color(0xFF1E88E5)
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
                    color: Color(0xFF1E88E5),
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
                      ? const Color(0xFF1E88E5)
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
              title.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1E88E5)
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MensAllProductsTab extends StatelessWidget {
  final Function(int)? onTabSelected;
  const MensAllProductsTab({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: MensFeaturedBanner(onTabSelected: onTabSelected),
        ),
        const SliverToBoxAdapter(child: MensCashbackOffer()),
        const SliverToBoxAdapter(child: MensProductCategories()),
        const SliverToBoxAdapter(child: MensBrandSection()),
        SliverToBoxAdapter(
          child: _buildSectionHeader(context, 'trending_now'.tr()),
        ),
        const MensProductGrid(),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title.tr(),
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

class MensHorizontalCategories extends StatelessWidget {
  const MensHorizontalCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATE CATEGORY IMAGES HERE
    // Modify the 'image' URL for each category below.
    final categories = [
      {
        'name': 'casual',
        'image':
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&auto=format&fit=crop',
      },
      {
        'name': 'ethnic',
        'image':
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500&auto=format&fit=crop',
      },
      {
        'name': 'footwear',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop',
      },
      {
        'name': 'sports',
        'image':
            'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500&auto=format&fit=crop',
      },
      {
        'name': 'essentials',
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&auto=format&fit=crop',
      },
      {
        'name': 'active',
        'image':
            'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500&auto=format&fit=crop',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Theme.of(context).cardColor,
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
                    categories[index]['name']!.tr(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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

class MensFeaturedBanner extends StatefulWidget {
  final Function(int)? onTabSelected;
  const MensFeaturedBanner({super.key, this.onTabSelected});

  @override
  State<MensFeaturedBanner> createState() => _MensFeaturedBannerState();
}

class _MensFeaturedBannerState extends State<MensFeaturedBanner> {
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
              'the_denim_edit'.tr(),
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
                      // UPDATE BANNER IMAGES HERE
                      // To change the images, replace the URLs in the strings below.
                      // Format: _buildBannerItem(imageUrl, brandName, mainTitle, subTitle, tag)
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop',
                        'rare_rabbit',
                        'denim_all_over',
                        'denim_wear',
                        'featured_brands',
                        onTap: () =>
                            widget.onTabSelected?.call(2), // Bottomwear
                      ),
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&auto=format&fit=crop',
                        'levis',
                        'classic_denim',
                        'premium_jeans',
                        'trending_hashtag',
                        onTap: () =>
                            widget.onTabSelected?.call(2), // Bottomwear
                      ),
                      _buildBannerItem(
                        'https://media.istockphoto.com/id/692909922/photo/hes-off-on-an-adventure.webp?a=1&b=1&s=612x612&w=0&k=20&c=d-bqdMaEQakXXATRVAAy9EhXDm0zSsiAKevpLlkuKBE=',
                        'jack_and_jones',
                        'urban_style',
                        'streetwear',
                        'new_arrivals',
                        onTap: () => widget.onTabSelected?.call(1), // Topwear
                      ),
                      _buildBannerItem(
                        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop',
                        'wrogn',
                        'stay_wrogn',
                        'casuals',
                        'youthfashion',
                        onTap: () =>
                            widget.onTabSelected?.call(4), // Accessories
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
    String tag, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                        brand.tr(),
                        style: const TextStyle(
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
                  title.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tag.tr(),
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
      ),
    );
  }
}

class MensCashbackOffer extends StatelessWidget {
  const MensCashbackOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
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
                      'Get 7.5%* Cashback On Myntra',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Use FOREVER CARD & PAY LATER & Flipkart Credit Card',
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

class MensProductCategories extends StatelessWidget {
  const MensProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'jeans',
        'image':
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500&auto=format&fit=crop',
      },
      {
        'name': 'sweaters',
        'image':
            'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500&auto=format&fit=crop',
      },
      {
        'name': 'jackets',
        'image':
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500&auto=format&fit=crop',
      },
      {
        'name': 'blazers',
        'image':
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500&auto=format&fit=crop',
      },
      {
        'name': 'hoodies',
        'image':
            'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500&auto=format&fit=crop',
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
                        categories[index]['name']!.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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

class MensBrandSection extends StatelessWidget {
  const MensBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = [
      {'name': 'fwd', 'subtitle': 'under_999'},
      {'name': 'luxe', 'subtitle': 'luxury'},
      {'name': 'bag', 'subtitle': 'accessories'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: const Color(0xFFFAFAFA),
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
                          color: brand['name'] == 'FWD'
                              ? const Color(0xFFFF3F6C)
                              : Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          brand['name']![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brand['name']!.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                brand['subtitle']!.tr(),
                style: TextStyle(fontSize: 11, color: Colors.grey[700]),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class MensProductGrid extends StatefulWidget {
  final String? category;
  const MensProductGrid({super.key, this.category});

  @override
  State<MensProductGrid> createState() => _MensProductGridState();
}

class _MensProductGridState extends State<MensProductGrid> {
  SortOption _currentSort = SortOption.relevance;
  int _currentDiscountFilter = 0;

  void _openSortFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: SortFilterBottomSheet(
          initialSort: _currentSort,
          initialDiscountFilter: _currentDiscountFilter,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _currentSort = result['sort'];
        _currentDiscountFilter = result['discount'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    // UPDATE PRODUCT DATA HERE
    // Add or modify products in this list. Ensure 'category' matches the tabs (e.g., Topwear, Footwear).
    final List<Map<String, dynamic>> allProducts = [
      {
        'image':
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&auto=format&fit=crop',
        'brand': 'roadster',
        'name': 'men_typography_printed_t_shirt',
        'price': 499,
        'originalPrice': 1499,
        'discount': 67,
        'rating': 4.3,
        'reviews': 2100,
        'category': 'topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&auto=format&fit=crop',
        'brand': 'highlander',
        'name': 'men_slim_fit_casual_shirt',
        'price': 699,
        'originalPrice': 1999,
        'discount': 65,
        'rating': 4.1,
        'reviews': 1800,
        'category': 'topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500&auto=format&fit=crop',
        'brand': 'levis',
        'name': 'n_511_slim_fit_jeans',
        'price': 1799,
        'originalPrice': 3999,
        'discount': 55,
        'rating': 4.5,
        'reviews': 3200,
        'category': 'bottomwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500&auto=format&fit=crop',
        'brand': 'wrogn',
        'name': 'men_solid_bomber_jacket',
        'price': 1299,
        'originalPrice': 3999,
        'discount': 68,
        'rating': 4.2,
        'reviews': 980,
        'category': 'topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop',
        'brand': 'nike',
        'name': 'air_max_270_running_shoes',
        'price': 8995,
        'originalPrice': 12995,
        'discount': 31,
        'rating': 4.6,
        'reviews': 4500,
        'category': 'footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500&auto=format&fit=crop',
        'brand': 'hrx',
        'name': 'rapid_dry_training_t_shirt',
        'price': 599,
        'originalPrice': 1299,
        'discount': 54,
        'rating': 4.4,
        'reviews': 2800,
        'category': 'topwear',
      },
      {
        'image':
            'https://media.istockphoto.com/id/692909922/photo/hes-off-on-an-adventure.webp?a=1&b=1&s=612x612&w=0&k=20&c=d-bqdMaEQakXXATRVAAy9EhXDm0zSsiAKevpLlkuKBE=',
        'brand': 'jack_and_jones',
        'name': 'men_slim_fit_chinos',
        'price': 1499,
        'originalPrice': 2999,
        'discount': 50,
        'rating': 4.3,
        'reviews': 1560,
        'category': 'bottomwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1554568218-ffd1e72a2151?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHN3ZWF0c2hpcnR8ZW58MHx8MHx8fDA%3D',
        'brand': 'puma',
        'name': 'essential_logo_crew_sweatshirt',
        'price': 1199,
        'originalPrice': 2999,
        'discount': 60,
        'rating': 4.2,
        'reviews': 890,
        'category': 'topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=500&auto=format&fit=crop',
        'brand': 'fossil',
        'name': 'men_leather_watch',
        'price': 5995,
        'originalPrice': 8995,
        'discount': 33,
        'rating': 4.5,
        'reviews': 1200,
        'category': 'accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500&auto=format&fit=crop',
        'brand': 'beardo',
        'name': 'beard_growth_oil',
        'price': 499,
        'originalPrice': 750,
        'discount': 33,
        'rating': 4.1,
        'reviews': 3500,
        'category': 'grooming',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500&auto=format&fit=crop',
        'brand': 'adidas',
        'name': 'ultraboost_21',
        'price': 14999,
        'originalPrice': 17999,
        'discount': 17,
        'rating': 4.8,
        'reviews': 3200,
        'category': 'footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&auto=format&fit=crop',
        'brand': 'puma',
        'name': 'rs_x_reinvention',
        'price': 8999,
        'originalPrice': 9999,
        'discount': 10,
        'rating': 4.5,
        'reviews': 1500,
        'category': 'footwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1627094522148-ac0c843a1383?w=500&auto=format&fit=crop',
        'brand': 'titan',
        'name': 'neo_men_leather_watch',
        'price': 4595,
        'originalPrice': 6595,
        'discount': 30,
        'rating': 4.4,
        'reviews': 2100,
        'category': 'accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop',
        'brand': 'ray_ban',
        'name': 'aviator_sunglasses',
        'price': 8590,
        'originalPrice': 10590,
        'discount': 19,
        'rating': 4.7,
        'reviews': 4100,
        'category': 'accessories',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500&auto=format&fit=crop',
        'brand': 'u_s_polo_assn',
        'name': 'men_cotton_sweater',
        'price': 1899,
        'originalPrice': 3299,
        'discount': 42,
        'rating': 4.3,
        'reviews': 1800,
        'category': 'topwear',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1727835523545-70ee992b5763?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bWVucyUyMGt1cnRhfGVufDB8fDB8fHww',
        'brand': 'manyavar',
        'name': 'men_kurta_set',
        'price': 3999,
        'originalPrice': 5999,
        'discount': 33,
        'rating': 4.6,
        'reviews': 2400,
        'category':
            'ethnic', // Added for potential future use or if category logic is updated
      },
      {
        'image':
            'https://images.unsplash.com/photo-1559563458-527698bf5295?w=500&auto=format&fit=crop',
        'brand': 'the_man_company',
        'name': 'charcoal_face_wash',
        'price': 299,
        'originalPrice': 349,
        'discount': 14,
        'rating': 4.2,
        'reviews': 5600,
        'category': 'grooming',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1621607512214-68297480165e?w=500&auto=format&fit=crop',
        'brand': 'bombay_shaving_co',
        'name': 'shaving_kit',
        'price': 1299,
        'originalPrice': 1999,
        'discount': 35,
        'rating': 4.4,
        'reviews': 1200,
        'category': 'grooming',
      },
    ];

    List<Map<String, dynamic>> products =
        widget.category == null || widget.category == 'All'
        ? List.from(allProducts)
        : allProducts
              .where(
                (p) =>
                    p['category'].toString().toLowerCase() ==
                    widget.category!.toLowerCase(),
              )
              .toList();

    // 1. Apply Discount Filter
    if (_currentDiscountFilter > 0) {
      products = products
          .where((p) => (p['discount'] as num) >= _currentDiscountFilter)
          .toList();
    }

    // 2. Apply Sort
    switch (_currentSort) {
      case SortOption.priceLowToHigh:
        products.sort(
          (a, b) => (a['price'] as num).compareTo(b['price'] as num),
        );
        break;
      case SortOption.priceHighToLow:
        products.sort(
          (a, b) => (b['price'] as num).compareTo(a['price'] as num),
        );
        break;
      case SortOption.rating:
        products.sort(
          (a, b) => (b['rating'] as num).compareTo(a['rating'] as num),
        );
        break;
      case SortOption.relevance:
        // Do nothing, leaves it in original order
        break;
    }

    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'No items found in ${widget.category}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openSortFilterSheet,
                    icon: const Icon(Icons.tune, size: 18),
                    label: Text(
                      _currentSort != SortOption.relevance ||
                              _currentDiscountFilter > 0
                          ? 'SORT & FILTER (Active)'
                          : 'SORT & FILTER',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.48, // Adjusted height for Add to Cart button
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index % products.length];
              return _buildProductCard(context, product, firestoreService);
            }, childCount: products.length),
          ),
        ),
      ],
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
      // Generate a stable ID based on name/brand if missing, or use a random one (for demo)
      // For this existing list, we might want to add IDs or just generate hash
      product['id'] = '${subtitle}_$title'.hashCode.toString();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                                    SnackBar(
                                      content: Text(
                                        'removed_from_wishlist'.tr(),
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              } else {
                                await firestoreService.addToWishlist(product);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('added_to_wishlist'.tr()),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'error_msg'.tr(args: [e.toString()]),
                                    ),
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
                        product['brand'].toString().tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['name'].toString().tr(),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
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
                      // NEW ELEVATED BUTTON WITH DIALOG LOGIC
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
                                        content: Text(
                                          'error_with_icon'.tr(
                                            args: [e.toString()],
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF1E88E5,
                            ), // Keep Blue for Men? Or Pink? Let's use Pink for consistency or Blue if per design. Steps used Pink in Home. Men's section uses Blue usually? Code had Blue. I'll stick to Blue for Men but use ElevatedButton style.
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

class MensCategoryTab extends StatelessWidget {
  final String category;

  const MensCategoryTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF3F6C).withValues(alpha: 0.1),
                  const Color(0xFFFF3F6C).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.toUpperCase().tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF3F6C),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore ${category.toLowerCase()} collection',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        MensProductGrid(category: category),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}

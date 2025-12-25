import 'package:flutter/material.dart';
import 'dart:math' as math;

class WinterEssentialsScreen extends StatefulWidget {
  const WinterEssentialsScreen({super.key});

  @override
  State<WinterEssentialsScreen> createState() => _WinterEssentialsScreenState();
}

class _WinterEssentialsScreenState extends State<WinterEssentialsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _snowController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  String _selectedCategory = 'All';
  final Set<int> _favorites = {};

  final List<String> _categories = [
    'All',
    'Jackets',
    'Sweaters',
    'Boots',
    'Accessories',
    'Thermals'
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Arctic Down Parka',
      'category': 'Jackets',
      'price': 249.99,
      'originalPrice': 349.99,
      'rating': 4.9,
      'reviews': 3842,
      'image': 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800',
      'discount': 29,
      'tags': ['Waterproof', 'Bestseller'],
      'temperature': '-20°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Thermal Insulated Jacket',
      'category': 'Jackets',
      'price': 189.99,
      'originalPrice': 259.99,
      'rating': 4.8,
      'reviews': 2156,
      'image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
      'discount': 27,
      'tags': ['Windproof', 'Lightweight'],
      'temperature': '-15°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Cashmere Blend Sweater',
      'category': 'Sweaters',
      'price': 129.99,
      'originalPrice': 179.99,
      'rating': 4.7,
      'reviews': 1876,
      'image': 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800',
      'discount': 28,
      'tags': ['Premium', 'Soft'],
      'temperature': '-5°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Merino Wool Turtleneck',
      'category': 'Sweaters',
      'price': 89.99,
      'originalPrice': 129.99,
      'rating': 4.8,
      'reviews': 2341,
      'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800',
      'discount': 31,
      'tags': ['Breathable', 'Natural'],
      'temperature': '-10°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Insulated Snow Boots',
      'category': 'Boots',
      'price': 159.99,
      'originalPrice': 219.99,
      'rating': 4.9,
      'reviews': 4521,
      'image': 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800',
      'discount': 27,
      'tags': ['Waterproof', 'Non-slip'],
      'temperature': '-30°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Leather Winter Boots',
      'category': 'Boots',
      'price': 199.99,
      'originalPrice': 279.99,
      'rating': 4.8,
      'reviews': 3187,
      'image': 'https://images.unsplash.com/photo-1605812860427-4024433a70fd?w=800',
      'discount': 29,
      'tags': ['Premium', 'Durable'],
      'temperature': '-20°C',
      'stock': 'Limited Stock',
    },
    {
      'name': 'Wool Scarf Set',
      'category': 'Accessories',
      'price': 49.99,
      'originalPrice': 74.99,
      'rating': 4.7,
      'reviews': 1654,
      'image': 'https://images.unsplash.com/photo-1520903920243-00d872a2d1c9?w=800',
      'discount': 33,
      'tags': ['Gift Set', 'Soft'],
      'temperature': '-10°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Touchscreen Winter Gloves',
      'category': 'Accessories',
      'price': 39.99,
      'originalPrice': 59.99,
      'rating': 4.6,
      'reviews': 2891,
      'image': 'https://images.unsplash.com/photo-1592058712975-ead9c0e42c5c?w=800',
      'discount': 33,
      'tags': ['Tech-friendly', 'Warm'],
      'temperature': '-15°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Thermal Base Layer Set',
      'category': 'Thermals',
      'price': 79.99,
      'originalPrice': 119.99,
      'rating': 4.8,
      'reviews': 3456,
      'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800',
      'discount': 33,
      'tags': ['Moisture-wicking', 'Comfortable'],
      'temperature': '-20°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Fleece-Lined Leggings',
      'category': 'Thermals',
      'price': 44.99,
      'originalPrice': 64.99,
      'rating': 4.7,
      'reviews': 2187,
      'image': 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800',
      'discount': 31,
      'tags': ['Comfortable', 'Stretchy'],
      'temperature': '-10°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Beanie & Scarf Combo',
      'category': 'Accessories',
      'price': 59.99,
      'originalPrice': 89.99,
      'rating': 4.9,
      'reviews': 1987,
      'image': 'https://images.unsplash.com/photo-1517583010307-3f789911b89c?w=800',
      'discount': 33,
      'tags': ['Gift Set', 'Stylish'],
      'temperature': '-15°C',
      'stock': 'In Stock',
    },
    {
      'name': 'Heated Vest',
      'category': 'Jackets',
      'price': 149.99,
      'originalPrice': 199.99,
      'rating': 4.8,
      'reviews': 1432,
      'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800',
      'discount': 25,
      'tags': ['Tech', 'Innovative'],
      'temperature': '-25°C',
      'stock': 'Limited Stock',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _snowController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products
        .where((product) => product['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE3F2FD),
              const Color(0xFFF5F9FF),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildWinterBanner()),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFBBDEFB).withOpacity(0.4),
                const Color(0xFFE1F5FE).withOpacity(0.3),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _buildBackButton(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade600,
                                        Colors.cyan.shade500,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade300.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.ac_unit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Winter Essentials',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.8,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 14,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Up to 35% off ends soon',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildHeaderIcon(Icons.search, Colors.blue.shade600),
                      const SizedBox(width: 10),
                      _buildHeaderIcon(Icons.favorite_border, Colors.red.shade600),
                      const SizedBox(width: 10),
                      _buildHeaderIconWithBadge(
                        Icons.shopping_bag_outlined,
                        Colors.purple.shade600,
                        '3',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconWithBadge(IconData icon, Color color, String count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildHeaderIcon(icon, color),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade500, Colors.orange.shade600],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Center(
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWinterBanner() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          constraints: const BoxConstraints(minHeight: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1565C0),
                const Color(0xFF0277BD),
                const Color(0xFF00838F),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade400.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.cyan.shade300.withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 20),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Stack(
            children: [
              ...List.generate(8, (index) {
                return AnimatedBuilder(
                  animation: _snowController,
                  builder: (context, child) {
                    final progress = (_snowController.value + index * 0.125) % 1.0;
                    return Positioned(
                      left: 30.0 + index * 40,
                      top: -20 + (progress * 220),
                      child: Opacity(
                        opacity: (1 - progress) * 0.6,
                        child: Icon(
                          Icons.ac_unit,
                          size: 16 + (index % 3) * 8,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    );
                  },
                );
              }),
              Positioned(
                right: -30,
                top: -30,
                child: Transform.rotate(
                  angle: math.pi / 8,
                  child: Icon(
                    Icons.ac_unit,
                    size: 180,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Transform.rotate(
                  angle: -math.pi / 6,
                  child: Icon(
                    Icons.ac_unit,
                    size: 120,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '❄️ WINTER SALE 2024',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Up to 35% Off',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: -1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Premium Winter Collection',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.grey.shade800,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 54,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = category),
                borderRadius: BorderRadius.circular(28),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.cyan.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.shade400.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                              spreadRadius: 0,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProductCard(products[index], index),
        childCount: products.length,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final isFavorite = _favorites.contains(index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.grey.shade100,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
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
                        top: Radius.circular(24),
                      ),
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.9),
                            ],
                            stops: const [0.7, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.network(
                          product['image'],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade600,
                              Colors.orange.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade400.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${product['discount']}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFavorite) {
                              _favorites.remove(index);
                            } else {
                              _favorites.add(index);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? Colors.red.shade50
                                : Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFavorite
                                  ? Colors.red.shade200
                                  : Colors.grey.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isFavorite
                                    ? Colors.red.shade200.withOpacity(0.4)
                                    : Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.thermostat,
                              color: Colors.cyan.shade300,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product['temperature'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product['rating']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Colors.grey.shade900,
                            letterSpacing: -0.2,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: product['stock'] == 'Limited Stock'
                                ? LinearGradient(
                                    colors: [
                                      Colors.orange.shade50,
                                      Colors.orange.shade100,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.green.shade50,
                                      Colors.green.shade100,
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: product['stock'] == 'Limited Stock'
                                  ? Colors.orange.shade300
                                  : Colors.green.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: product['stock'] == 'Limited Stock'
                                      ? Colors.orange.shade600
                                      : Colors.green.shade600,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                product['stock'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: product['stock'] == 'Limited Stock'
                                      ? Colors.orange.shade900
                                      : Colors.green.shade900,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${product['price']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue.shade800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (product['originalPrice'] != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '\$${product['originalPrice']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (product['tags'] != null)
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: (product['tags'] as List)
                                .take(2)
                                .map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade50,
                                            Colors.cyan.shade50,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.blue.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
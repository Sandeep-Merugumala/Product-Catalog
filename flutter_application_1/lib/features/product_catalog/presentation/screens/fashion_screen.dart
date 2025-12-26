import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math' as math;

class FashionCatalogScreen extends StatefulWidget {
  const FashionCatalogScreen({super.key});

  @override
  State<FashionCatalogScreen> createState() => _FashionCatalogScreenState();
}

class _FashionCatalogScreenState extends State<FashionCatalogScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productSectionKey = GlobalKey();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  bool _showElevation = false;
  int _selectedCategoryIndex = 0;
  int _currentBannerIndex = 0;

  // Filter State
  String _sortOption = 'default';
  final List<String> _selectedBrands = [];

  // Categories - These names MUST match the product 'category' field exactly
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.grid_view,
      'gradient': [const Color(0xFFda22ff), const Color(0xFF9733ee)],
    },
    {
      'name': 'Women',
      'icon': Icons.woman,
      'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    },
    {
      'name': 'Men',
      'icon': Icons.man,
      'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
    },
    {
      'name': 'Shoes',
      'icon': Icons.wc,
      'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)],
    },
    {
      'name': 'Accessories',
      'icon': Icons.watch,
      'gradient': [const Color(0xFF30cfd0), const Color(0xFF330867)],
    },
    {
      'name': 'Bags',
      'icon': Icons.shopping_bag,
      'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
    },
  ];

  final List<Map<String, String>> _banners = [
    {
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1200',
      'title': 'New Season',
      'subtitle': 'Spring Collection 2025',
      'badge': 'JUST ARRIVED',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=1200',
      'title': 'Style Edit',
      'subtitle': 'Curated Looks for You',
      'badge': 'TRENDING',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1200',
      'title': 'Big Sale',
      'subtitle': 'Up to 60% Off',
      'badge': 'LIMITED TIME',
    },
  ];

  late List<Map<String, dynamic>> _allProducts;

  @override
  void initState() {
    super.initState();
    _initializeProducts();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
      }
    });
  }

  void _initializeProducts() {
    // 1. Specific Products
    List<Map<String, dynamic>> baseProducts = [
      {
        'name': 'Floral Summer Dress',
        'category': 'Women',
        'price': 89.99,
        'originalPrice': 129.99,
        'rating': 4.8,
        'reviews': 1845,
        'image':
            'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500',
        'discount': 31,
        'brand': 'Zara',
        'tag': 'Bestseller',
      },
      {
        'name': 'Classic White Shirt',
        'category': 'Women',
        'price': 49.99,
        'originalPrice': 79.99,
        'rating': 4.9,
        'reviews': 2341,
        'image':
            'https://images.unsplash.com/photo-1624206112918-f140f087f9b5?w=500',
        'discount': 38,
        'brand': 'H&M',
        'tag': 'New',
      },
      {
        'name': 'Leather Jacket',
        'category': 'Men',
        'price': 249.99,
        'originalPrice': 349.99,
        'rating': 4.7,
        'reviews': 987,
        'image':
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
        'discount': 29,
        'brand': 'Levi\'s',
        'tag': 'Hot',
      },
      {
        'name': 'Slim Fit Jeans',
        'category': 'Men',
        'price': 79.99,
        'originalPrice': 99.99,
        'rating': 4.6,
        'reviews': 1543,
        'image':
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500',
        'discount': 20,
        'brand': 'Levi\'s',
        'tag': null,
      },
      {
        'name': 'Canvas Sneakers',
        'category': 'Shoes',
        'price': 69.99,
        'originalPrice': 89.99,
        'rating': 4.8,
        'reviews': 2187,
        'image':
            'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500',
        'discount': 22,
        'brand': 'Converse',
        'tag': 'Deal',
      },
      {
        'name': 'High Heel Pumps',
        'category': 'Shoes',
        'price': 119.99,
        'originalPrice': 159.99,
        'rating': 4.7,
        'reviews': 1234,
        'image':
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500',
        'discount': 25,
        'brand': 'Aldo',
        'tag': 'Elegant',
      },
      {
        'name': 'Designer Sunglasses',
        'category': 'Accessories',
        'price': 149.99,
        'originalPrice': 199.99,
        'rating': 4.9,
        'reviews': 876,
        'image':
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
        'discount': 25,
        'brand': 'Ray-Ban',
        'tag': 'Luxury',
      },
      {
        'name': 'Gold Watch',
        'category': 'Accessories',
        'price': 299.99,
        'originalPrice': 399.99,
        'rating': 4.8,
        'reviews': 654,
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        'discount': 25,
        'brand': 'Fossil',
        'tag': 'Premium',
      },
      {
        'name': 'Leather Tote Bag',
        'category': 'Bags',
        'price': 179.99,
        'originalPrice': 249.99,
        'rating': 4.9,
        'reviews': 1432,
        'image':
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500',
        'discount': 28,
        'brand': 'Michael Kors',
        'tag': 'Bestseller',
      },
      {
        'name': 'Crossbody Bag',
        'category': 'Bags',
        'price': 89.99,
        'originalPrice': 129.99,
        'rating': 4.7,
        'reviews': 987,
        'image':
            'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=500',
        'discount': 31,
        'brand': 'Coach',
        'tag': 'Trendy',
      },
    ];

    // 2. Generate 50 more products dynamically
    _allProducts = [...baseProducts, ..._generateMoreProducts()];
  }

  List<Map<String, dynamic>> _generateMoreProducts() {
    List<Map<String, dynamic>> generated = [];
    final brands = [
      'Zara',
      'H&M',
      'Gucci',
      'Prada',
      'Levi\'s',
      'Tommy Hilfiger',
      'Calvin Klein',
      'Ralph Lauren',
      'Versace',
    ];

    // Category specific images to prevent mismatched photos
    final Map<String, List<String>> categoryImages = {
      'Women': [
        'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=500',
        'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=500',
        'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=500',
      ],
      'Men': [
        'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=500',
        'https://images.unsplash.com/photo-1594938291221-94f18cbb5660?w=500',
        'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500',
      ],
      'Shoes': [
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
        'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=500',
        'https://images.unsplash.com/photo-1605348532760-6753d2c43329?w=500',
      ],
      'Accessories': [
        'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=500',
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=500',
      ],
      'Bags': [
        'https://images.unsplash.com/photo-1564422170194-896b89110ef8?w=500',
        'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=500',
      ],
    };

    final categoryKeys = categoryImages.keys.toList();

    for (int i = 0; i < 50; i++) {
      // Pick a category
      var category = categoryKeys[i % categoryKeys.length];
      var brand = brands[i % brands.length];
      var price = (math.Random().nextInt(250) + 30).toDouble();

      // Pick a random image from that category
      var images = categoryImages[category]!;
      var image = images[i % images.length];

      generated.add({
        'name': '$brand $category Style ${i + 100}',
        'category': category,
        'brand': brand,
        'price': price,
        'originalPrice':
            i % 3 == 0 ? price + (math.Random().nextInt(80) + 20) : null,
        'rating': 3.8 + (math.Random().nextDouble() * 1.2),
        'reviews': math.Random().nextInt(1200),
        'image': image,
        'tag': i % 6 == 0 ? 'Sale' : (i % 8 == 0 ? 'New' : null),
        'discount': i % 3 == 0 ? math.Random().nextInt(35) + 15 : null,
      });
    }
    return generated;
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- FILTER & SORT LOGIC ---

  List<String> get _availableBrands =>
      _allProducts.map((e) => e['brand'] as String).toSet().toList();

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> list = List.from(_allProducts);

    // 1. Filter by Category
    if (_selectedCategoryIndex != 0) {
      String selectedCategoryName = _categories[_selectedCategoryIndex]['name'];
      list = list.where((p) => p['category'] == selectedCategoryName).toList();
    }

    // 2. Filter by Brand
    if (_selectedBrands.isNotEmpty) {
      list = list.where((p) => _selectedBrands.contains(p['brand'])).toList();
    }

    // 3. Sort Logic
    if (_sortOption == 'price_asc') {
      list.sort(
        (a, b) => (a['price'] as double).compareTo(b['price'] as double),
      );
    } else if (_sortOption == 'price_desc') {
      list.sort(
        (a, b) => (b['price'] as double).compareTo(a['price'] as double),
      );
    } else if (_sortOption == 'rating') {
      list.sort(
        (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
      );
    } else if (_sortOption == 'reviews') {
      list.sort((a, b) => (b['reviews'] as int).compareTo(a['reviews'] as int));
    }

    return list;
  }

  void _scrollToProducts() {
    Scrollable.ensureVisible(
      _productSectionKey.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter & Sort",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _sortOption = 'default';
                          _selectedBrands.clear();
                        });
                        setStateModal(() {});
                      },
                      child: const Text(
                        "Reset All",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sort by Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildChoiceChip(
                              "Low to High",
                              _sortOption == 'price_asc',
                              (selected) => setStateModal(
                                () => _sortOption =
                                    selected ? 'price_asc' : 'default',
                              ),
                            ),
                            _buildChoiceChip(
                              "High to Low",
                              _sortOption == 'price_desc',
                              (selected) => setStateModal(
                                () => _sortOption =
                                    selected ? 'price_desc' : 'default',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Popularity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildChoiceChip(
                              "Top Rated",
                              _sortOption == 'rating',
                              (selected) => setStateModal(
                                () => _sortOption =
                                    selected ? 'rating' : 'default',
                              ),
                            ),
                            _buildChoiceChip(
                              "Most Reviewed",
                              _sortOption == 'reviews',
                              (selected) => setStateModal(
                                () => _sortOption =
                                    selected ? 'reviews' : 'default',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Brands",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableBrands.map((brand) {
                            final isSelected = _selectedBrands.contains(brand);
                            return FilterChip(
                              label: Text(brand),
                              selected: isSelected,
                              onSelected: (bool selected) => setStateModal(
                                () => selected
                                    ? _selectedBrands.add(brand)
                                    : _selectedBrands.remove(brand),
                              ),
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: Colors.purple.shade100,
                              checkmarkColor: Colors.purple.shade700,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Show ${_filteredProducts.length} Results",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChoiceChip(
    String label,
    bool isSelected,
    Function(bool) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Colors.purple.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.purple.shade900 : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildCarouselBanner()),
          SliverToBoxAdapter(child: _buildCategorySelector()),
          SliverToBoxAdapter(
            key: _productSectionKey,
            child: _buildSectionTitle(),
          ),
          _buildProductGrid(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 70,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: _showElevation ? 8 : 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFda22ff), Color(0xFF9733ee)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.checkroom, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fashion Store",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Trending Styles",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.filter_list, color: Colors.black, size: 20),
          ),
          onPressed: _showFilterModal,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFda22ff), Color(0xFF9733ee)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search fashion items...",
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.mic_none, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCarouselBanner() {
    return Column(
      children: [
        const SizedBox(height: 16),
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) =>
                setState(() => _currentBannerIndex = index),
          ),
          items: _banners.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Image.network(
                      banner['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 20,
                      bottom: 20,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              banner['badge']!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _scrollToProducts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop Now',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward, size: 16),
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
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentBannerIndex == entry.key ? 32 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: _currentBannerIndex == entry.key
                    ? const LinearGradient(
                        colors: [Color(0xFFda22ff), Color(0xFF9733ee)],
                      )
                    : null,
                color: _currentBannerIndex == entry.key
                    ? null
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              final category = _categories[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: category['gradient'] as List<Color>,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: (category['gradient'] as List<Color>)[0]
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      else
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 18,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle() {
    String title = _selectedCategoryIndex == 0
        ? "Trending Fashion"
        : "${_categories[_selectedCategoryIndex]['name']}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: _showFilterModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    "Sort/Filter",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.tune, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(child: Text("No products match your filters.")),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          product['image'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (product['tag'] != null || product['discount'] != null)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: product['tag'] == 'Sale' ||
                                      product['discount'] != null
                                  ? Colors.red
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product['discount'] != null
                                  ? "-${product['discount']}%"
                                  : product['tag'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product['brand'].toString().toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  "\$${product['price'].toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                if (product['originalPrice'] != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    "\$${product['originalPrice'].toStringAsFixed(0)}",
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey.shade400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        // Highlighted Add to Cart Button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFda22ff), Color(0xFF9733ee)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // Updated shadow to match the new start color (da22ff)
                                color: const Color(0xFFda22ff).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }, childCount: products.length),
      ),
    );
  }
}

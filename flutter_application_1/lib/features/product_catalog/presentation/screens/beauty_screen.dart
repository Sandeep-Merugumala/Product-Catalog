import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math' as math;

class BeautyCatalogScreen extends StatefulWidget {
  const BeautyCatalogScreen({super.key});

  @override
  State<BeautyCatalogScreen> createState() => _BeautyCatalogScreenState();
}

class _BeautyCatalogScreenState extends State<BeautyCatalogScreen>
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
      'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    },
    {
      'name': 'Skincare',
      'icon': Icons.spa,
      'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
    },
    {
      'name': 'Makeup',
      'icon': Icons.brush,
      'gradient': [const Color(0xFFff9a9e), const Color(0xFFfecfef)],
    },
    {
      'name': 'Haircare',
      'icon': Icons.content_cut,
      'gradient': [const Color(0xFFfbc2eb), const Color(0xFFa6c1ee)],
    },
    {
      'name': 'Fragrance',
      'icon': Icons.local_florist,
      'gradient': [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
    },
    {
      'name': 'Tools',
      'icon': Icons.construction,
      'gradient': [const Color(0xFFfccb90), const Color(0xFFd57eeb)],
    },
  ];

  final List<Map<String, String>> _banners = [
    {
      'image':
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=1200',
      'title': 'Glow Up',
      'subtitle': 'New Skincare Collection',
      'badge': 'JUST LAUNCHED',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=1200',
      'title': 'Beauty Edit',
      'subtitle': 'Curated Makeup Essentials',
      'badge': 'BESTSELLERS',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=1200',
      'title': 'Self Care',
      'subtitle': 'Up to 50% Off Bundles',
      'badge': 'LIMITED OFFER',
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
    List<Map<String, dynamic>> baseProducts = [
      {
        'name': 'Hydrating Face Serum',
        'category': 'Skincare',
        'price': 45.99,
        'originalPrice': 65.99,
        'rating': 4.9,
        'reviews': 3245,
        'image':
            'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500',
        'discount': 30,
        'brand': 'The Ordinary',
        'tag': 'Bestseller',
      },
      {
        'name': 'Vitamin C Brightening Cream',
        'category': 'Skincare',
        'price': 38.99,
        'originalPrice': 52.99,
        'rating': 4.8,
        'reviews': 2876,
        'image':
            'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
        'discount': 26,
        'brand': 'CeraVe',
        'tag': 'New',
      },
      {
        'name': 'Matte Liquid Lipstick Set',
        'category': 'Makeup',
        'price': 32.99,
        'originalPrice': 49.99,
        'rating': 4.7,
        'reviews': 1987,
        'image':
            'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=500',
        'discount': 34,
        'brand': 'MAC',
        'tag': 'Hot',
      },
      {
        'name': 'Professional Eyeshadow Palette',
        'category': 'Makeup',
        'price': 54.99,
        'originalPrice': 79.99,
        'rating': 4.9,
        'reviews': 4321,
        'image':
            'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=500',
        'discount': 31,
        'brand': 'Urban Decay',
        'tag': 'Premium',
      },
      {
        'name': 'Argan Oil Hair Mask',
        'category': 'Haircare',
        'price': 29.99,
        'originalPrice': 42.99,
        'rating': 4.8,
        'reviews': 2134,
        'image':
            'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500',
        'discount': 30,
        'brand': 'Moroccanoil',
        'tag': 'Deal',
      },
      {
        'name': 'Keratin Repair Shampoo',
        'category': 'Haircare',
        'price': 24.99,
        'originalPrice': 34.99,
        'rating': 4.6,
        'reviews': 1654,
        'image':
            'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=500',
        'discount': 29,
        'brand': 'Olaplex',
        'tag': null,
      },
      {
        'name': 'Luxury Eau de Parfum',
        'category': 'Fragrance',
        'price': 89.99,
        'originalPrice': 125.99,
        'rating': 4.9,
        'reviews': 2876,
        'image':
            'https://images.unsplash.com/photo-1541643600914-78b084683601?w=500',
        'discount': 29,
        'brand': 'Chanel',
        'tag': 'Luxury',
      },
      {
        'name': 'Floral Body Mist',
        'category': 'Fragrance',
        'price': 34.99,
        'originalPrice': 49.99,
        'rating': 4.7,
        'reviews': 1543,
        'image':
            'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=500',
        'discount': 30,
        'brand': 'Victoria\'s Secret',
        'tag': 'Fresh',
      },
      {
        'name': 'Makeup Brush Set Professional',
        'category': 'Tools',
        'price': 64.99,
        'originalPrice': 89.99,
        'rating': 4.8,
        'reviews': 3245,
        'image':
            'https://images.unsplash.com/photo-1596704017254-9b121068fb31?w=500',
        'discount': 28,
        'brand': 'Morphe',
        'tag': 'Bestseller',
      },
      {
        'name': 'LED Facial Cleansing Device',
        'category': 'Tools',
        'price': 129.99,
        'originalPrice': 179.99,
        'rating': 4.9,
        'reviews': 2098,
        'image':
            'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=500',
        'discount': 28,
        'brand': 'Foreo',
        'tag': 'Tech',
      },
    ];

    _allProducts = [...baseProducts, ..._generateMoreProducts()];
  }

  List<Map<String, dynamic>> _generateMoreProducts() {
    List<Map<String, dynamic>> generated = [];
    final brands = [
      'The Ordinary',
      'CeraVe',
      'MAC',
      'Urban Decay',
      'Fenty Beauty',
      'Morphe',
      'Olaplex',
      'Chanel',
      'Dior',
    ];

    final Map<String, List<String>> categoryImages = {
      'Skincare': [
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500',
        'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
        'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?w=500',
      ],
      'Makeup': [
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500',
        'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=500',
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500',
      ],
      'Haircare': [
        'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500',
        'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=500',
        'https://images.unsplash.com/photo-1526045478516-99145907023c?w=500',
      ],
      'Fragrance': [
        'https://images.unsplash.com/photo-1541643600914-78b084683601?w=500',
        'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=500',
      ],
      'Tools': [
        'https://images.unsplash.com/photo-1596704017254-9b121068fb31?w=500',
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=500',
      ],
    };

    final categoryKeys = categoryImages.keys.toList();

    for (int i = 0; i < 50; i++) {
      var category = categoryKeys[i % categoryKeys.length];
      var brand = brands[i % brands.length];
      var price = (math.Random().nextInt(180) + 20).toDouble();
      var images = categoryImages[category]!;
      var image = images[i % images.length];

      generated.add({
        'name':
            '$brand ${category.substring(0, 3).toUpperCase()} Pro ${i + 100}',
        'category': category,
        'brand': brand,
        'price': price,
        'originalPrice':
            i % 3 == 0 ? price + (math.Random().nextInt(60) + 15) : null,
        'rating': 3.8 + (math.Random().nextDouble() * 1.2),
        'reviews': math.Random().nextInt(2000),
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

  List<String> get _availableBrands =>
      _allProducts.map((e) => e['brand'] as String).toSet().toList();

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> list = List.from(_allProducts);

    if (_selectedCategoryIndex != 0) {
      String selectedCategoryName = _categories[_selectedCategoryIndex]['name'];
      list = list.where((p) => p['category'] == selectedCategoryName).toList();
    }

    if (_selectedBrands.isNotEmpty) {
      list = list.where((p) => _selectedBrands.contains(p['brand'])).toList();
    }

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
                              selectedColor: Colors.pink.shade100,
                              checkmarkColor: Colors.pink.shade700,
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
      selectedColor: Colors.pink.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.pink.shade900 : Colors.black,
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
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Beauty Store",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Glow & Shine",
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
            color: Colors.pink.withOpacity(0.08),
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
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search beauty products...",
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
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
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
                        colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
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
        ? "Trending Beauty"
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
          childAspectRatio: 0.68,
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
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                              ),
                            );
                          },
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "\$${product['price'].toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (product['originalPrice'] != null) ...[
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "\$${product['originalPrice'].toStringAsFixed(0)}",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFf093fb).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
          );
        }, childCount: products.length),
      ),
    );
  }
}



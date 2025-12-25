import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_map/features/product_catalog/presentation/widgets/skeleton_product_card.dart';
import 'dart:math' as math;

class SportsCatalogScreen extends StatefulWidget {
  const SportsCatalogScreen({super.key});

  @override
  State<SportsCatalogScreen> createState() => _SportsCatalogScreenState();
}

class _SportsCatalogScreenState extends State<SportsCatalogScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productSectionKey = GlobalKey();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  bool _showElevation = false;
  bool _isLoading = true;
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
      'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)]
    },
    {
      'name': 'Footwear',
      'icon': Icons.directions_run,
      'gradient': [const Color(0xFF2193b0), const Color(0xFF6dd5ed)]
    },
    {
      'name': 'Clothing',
      'icon': Icons.accessibility_new,
      'gradient': [const Color(0xFFF2994A), const Color(0xFFF2C94C)]
    },
    {
      'name': 'Equipment',
      'icon': Icons.fitness_center,
      'gradient': [const Color(0xFF4568DC), const Color(0xFFB06AB3)]
    },
    {
      'name': 'Accessories',
      'icon': Icons.watch,
      'gradient': [const Color(0xFFee9ca7), const Color(0xFFffdde1)]
    },
    {
      'name': 'Team Sports',
      'icon': Icons.sports_soccer,
      'gradient': [const Color(0xFF56ab2f), const Color(0xFFa8e063)]
    },
  ];

  final List<Map<String, String>> _banners = [
    {
      'image':
          'https://images.unsplash.com/photo-1517649763965-4d3770d430f3?w=1200',
      'title': 'Train Harder',
      'subtitle': 'New Pro Series Gear',
      'badge': 'JUST DROPPED'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=1200',
      'title': 'Run Further',
      'subtitle': 'Marathon Ready Shoes',
      'badge': 'BESTSELLERS'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=1200',
      'title': 'Home Gym',
      'subtitle': 'Essentials up to 40% Off',
      'badge': 'SALE'
    },
  ];

  late List<Map<String, dynamic>> _allProducts;

  @override
  void initState() {
    super.initState();
    _initializeProducts();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });

    _shimmerController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);

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
        'name': 'Nike Air Zoom Pegasus',
        'category': 'Footwear',
        'price': 129.99,
        'originalPrice': 179.99,
        'rating': 4.8,
        'reviews': 2453,
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        'discount': 28,
        'brand': 'Nike',
        'tag': 'Bestseller'
      },
      {
        'name': 'Adidas Ultraboost 22',
        'category': 'Footwear',
        'price': 189.99,
        'originalPrice': 220.00,
        'rating': 4.9,
        'reviews': 3124,
        'image':
            'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500',
        'discount': 14,
        'brand': 'Adidas',
        'tag': 'New'
      },
      {
        'name': 'Performance Dri-FIT Tee',
        'category': 'Clothing',
        'price': 34.99,
        'originalPrice': 49.99,
        'rating': 4.6,
        'reviews': 1876,
        'image':
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
        'discount': 30,
        'brand': 'Nike',
        'tag': 'Deal'
      },
      {
        'name': 'Pro Compression Shorts',
        'category': 'Clothing',
        'price': 44.99,
        'originalPrice': 64.99,
        'rating': 4.7,
        'reviews': 982,
        'image':
            'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500',
        'discount': 31,
        'brand': 'Under Armour',
        'tag': 'Hot'
      },
      {
        'name': 'Basketball Pro Series',
        'category': 'Equipment',
        'price': 79.99,
        'originalPrice': 99.99,
        'rating': 4.8,
        'reviews': 1543,
        'image':
            'https://images.unsplash.com/photo-1546483875-ad9014c88eba?w=500',
        'discount': 20,
        'brand': 'Nike',
        'tag': null
      },
      {
        'name': 'Yoga Mat Premium',
        'category': 'Equipment',
        'price': 54.99,
        'originalPrice': 74.99,
        'rating': 4.9,
        'reviews': 2187,
        'image':
            'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
        'discount': 27,
        'brand': 'Puma',
        'tag': 'Eco'
      },
      {
        'name': 'Sports Duffle Bag',
        'category': 'Accessories',
        'price': 64.99,
        'originalPrice': 89.99,
        'rating': 4.7,
        'reviews': 1245,
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
        'discount': 28,
        'brand': 'Adidas',
        'tag': null
      },
      {
        'name': 'Wireless Earbuds Sport',
        'category': 'Accessories',
        'price': 89.99,
        'originalPrice': 129.99,
        'rating': 4.8,
        'reviews': 3421,
        'image':
            'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500',
        'discount': 31,
        'brand': 'Reebok',
        'tag': 'Tech'
      },
    ];

    // 2. Generate 50 more products dynamically
    _allProducts = [...baseProducts, ..._generateMoreProducts()];
  }

  List<Map<String, dynamic>> _generateMoreProducts() {
    List<Map<String, dynamic>> generated = [];
    final brands = [
      'Nike',
      'Adidas',
      'Puma',
      'Under Armour',
      'Reebok',
      'Asics',
      'New Balance'
    ];

    // Category specific images to prevent mismatched photos
    final Map<String, List<String>> categoryImages = {
      'Footwear': [
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500', // Green Nike
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500', // Vans
        'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=500', // Running Shoes
      ],
      'Clothing': [
        'https://images.unsplash.com/photo-1518459031867-a89b944bffe4?w=500', // Workout Top
        'https://images.unsplash.com/photo-1483721310020-03333e577078?w=500', // Leggings
        'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=500', // White Tee
      ],
      'Equipment': [
        'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=500', // Dumbbells
        'https://images.unsplash.com/photo-1623874514711-0f321325f318?w=500', // Basketball
        'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=500', // Weights
      ],
      'Accessories': [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500', // Watch
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500', // Bag
      ],
      'Team Sports': [
        'https://images.unsplash.com/photo-1614632537197-38a17061c2bd?w=500', // Soccer Ball
        'https://images.unsplash.com/photo-1546483875-ad9014c88eba?w=500', // Basketball
      ]
    };

    final categoryKeys = categoryImages.keys.toList();

    for (int i = 0; i < 50; i++) {
      // Pick a category
      var category = categoryKeys[i % categoryKeys.length];
      var brand = brands[i % brands.length];
      var price = (math.Random().nextInt(200) + 15).toDouble();

      // Pick a random image from that category
      var images = categoryImages[category]!;
      var image = images[i % images.length];

      generated.add({
        'name':
            '$brand ${category.substring(0, 3).toUpperCase()} Pro ${i + 100}',
        'category': category, // Ensure this matches _categories names EXACTLY
        'brand': brand,
        'price': price,
        'originalPrice':
            i % 3 == 0 ? price + (math.Random().nextInt(50) + 10) : null,
        'rating': 3.8 + (math.Random().nextDouble() * 1.2),
        'reviews': math.Random().nextInt(800),
        'image': image,
        'tag': i % 6 == 0 ? 'Sale' : (i % 8 == 0 ? 'New' : null),
        'discount': i % 3 == 0 ? math.Random().nextInt(30) + 10 : null,
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
      // Get the name from the UI list (e.g., "Footwear")
      String selectedCategoryName = _categories[_selectedCategoryIndex]['name'];

      // Filter list to keep only items where 'category' matches exactly
      list = list.where((p) => p['category'] == selectedCategoryName).toList();
    }

    // 2. Filter by Brand
    if (_selectedBrands.isNotEmpty) {
      list = list.where((p) => _selectedBrands.contains(p['brand'])).toList();
    }

    // 3. Sort Logic
    if (_sortOption == 'price_asc') {
      list.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_sortOption == 'price_desc') {
      list.sort(
          (a, b) => (b['price'] as double).compareTo(a['price'] as double));
    } else if (_sortOption == 'rating') {
      list.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
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
                            borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Filter & Sort",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _sortOption = 'default';
                          _selectedBrands.clear();
                        });
                        setStateModal(() {});
                      },
                      child: const Text("Reset All",
                          style: TextStyle(color: Colors.red)),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sort by Price",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildChoiceChip(
                                "Low to High",
                                _sortOption == 'price_asc',
                                (selected) => setStateModal(() => _sortOption =
                                    selected ? 'price_asc' : 'default')),
                            _buildChoiceChip(
                                "High to Low",
                                _sortOption == 'price_desc',
                                (selected) => setStateModal(() => _sortOption =
                                    selected ? 'price_desc' : 'default')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Popularity",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildChoiceChip(
                                "Top Rated",
                                _sortOption == 'rating',
                                (selected) => setStateModal(() => _sortOption =
                                    selected ? 'rating' : 'default')),
                            _buildChoiceChip(
                                "Most Reviewed",
                                _sortOption == 'reviews',
                                (selected) => setStateModal(() => _sortOption =
                                    selected ? 'reviews' : 'default')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Brands",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableBrands.map((brand) {
                            final isSelected = _selectedBrands.contains(brand);
                            return FilterChip(
                              label: Text(brand),
                              selected: isSelected,
                              onSelected: (bool selected) => setStateModal(() =>
                                  selected
                                      ? _selectedBrands.add(brand)
                                      : _selectedBrands.remove(brand)),
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: Colors.teal.shade100,
                              checkmarkColor: Colors.teal.shade700,
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
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Show ${_filteredProducts.length} Results",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
      String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Colors.teal.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle:
          TextStyle(color: isSelected ? Colors.teal.shade900 : Colors.black),
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
              key: _productSectionKey, child: _buildSectionTitle()),
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
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 18)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.sports_basketball,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sports Store",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5)),
              Text("Premium Gear",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
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
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.filter_list,
                    color: Colors.black, size: 20)),
            onPressed: _showFilterModal),
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
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)]),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search for gear, brands...",
                      border: InputBorder.none))),
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
                        offset: const Offset(0, 10))
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Image.network(banner['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity),
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent
                    ]))),
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
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(banner['badge']!,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Text(banner['title']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1)),
                          ),
                          const SizedBox(height: 8),
                          Text(banner['subtitle']!,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _scrollToProducts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Shop Now',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward, size: 16)
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
                        colors: [Color(0xFF11998e), Color(0xFF38ef7d)])
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
          child: Text("Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: category['gradient'] as List<Color>)
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                            color: (category['gradient'] as List<Color>)[0]
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      else
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(category['icon'] as IconData,
                          size: 18,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(category['name'] as String,
                          style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
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
        ? "Trending Gear"
        : "${_categories[_selectedCategoryIndex]['name']}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: _showFilterModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(children: [
                Text("Sort/Filter",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.tune, size: 16)
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    // Show Skeleton Grid if loading
    if (_isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.58,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => const SkeletonProductCard(),
            childCount: 6, // Show 6 skeleton items
          ),
        ),
      );
    }

    final products = _filteredProducts;
    if (products.isEmpty) {
      return const SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: Text("No products match your filters."))));
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
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8))
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
                              top: Radius.circular(20)),
                          child: Image.network(product['image'],
                              width: double.infinity, fit: BoxFit.cover),
                        ),
                        if (product['tag'] != null ||
                            product['discount'] != null)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: product['tag'] == 'Sale' ||
                                          product['discount'] != null
                                      ? Colors.red
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                  product['discount'] != null
                                      ? "-${product['discount']}%"
                                      : product['tag'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.favorite_border,
                                size: 18, color: Colors.black),
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
                              Text(product['brand'].toString().toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text(product['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                      "\$${product['price'].toStringAsFixed(0)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  if (product['originalPrice'] != null) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                        "\$${product['originalPrice'].toStringAsFixed(0)}",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey.shade400,
                                            fontSize: 12)),
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
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
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
          },
          childCount: products.length,
        ),
      ),
    );
  }
}

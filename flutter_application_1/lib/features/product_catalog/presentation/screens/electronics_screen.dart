import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math' as math;

class ElectronicsScreen extends StatefulWidget {
  const ElectronicsScreen({super.key});

  @override
  State<ElectronicsScreen> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<ElectronicsScreen>
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
  List<String> _selectedBrands = [];

  // Data
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.grid_view,
      'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)]
    },
    {
      'name': 'Laptops',
      'icon': Icons.laptop,
      'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)]
    },
    {
      'name': 'Phones',
      'icon': Icons.smartphone,
      'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)]
    },
    {
      'name': 'Audio',
      'icon': Icons.headphones,
      'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)]
    },
    {
      'name': 'Cameras',
      'icon': Icons.camera_alt,
      'gradient': [const Color(0xFFf093fb), const Color(0xFFF5576c)]
    },
    {
      'name': 'Gaming',
      'icon': Icons.sports_esports,
      'gradient': [const Color(0xFF30cfd0), const Color(0xFF330867)]
    },
    {
      'name': 'Wearables',
      'icon': Icons.watch,
      'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)]
    },
  ];

  final List<Map<String, String>> _banners = [
    {
      'image':
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=1200',
      'title': 'Next Gen Tech',
      'subtitle': 'Future is Now',
      'badge': 'LATEST'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=1200',
      'title': 'Smart Home',
      'subtitle': 'Connected Living',
      'badge': 'TRENDING'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=1200',
      'title': 'Gaming Gear',
      'subtitle': 'Level Up Your Setup',
      'badge': 'EXCLUSIVE'
    },
  ];

  late List<Map<String, dynamic>> _allProducts;

  @override
  void initState() {
    super.initState();
    _initializeProducts(); // Generate the 50+ products

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
    // Base products
    List<Map<String, dynamic>> baseProducts = [
      {
        'name': 'MacBook Air M2',
        'brand': 'Apple',
        'price': 999.0,
        'oldPrice': 1199.0,
        'rating': 4.9,
        'reviews': 854,
        'image':
            'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=500',
        'tag': 'Best Seller',
        'category': 'Laptops'
      },
      {
        'name': 'Galaxy S24 Ultra',
        'brand': 'Samsung',
        'price': 1199.0,
        'oldPrice': 1299.0,
        'rating': 4.8,
        'reviews': 621,
        'image':
            'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500',
        'tag': 'New',
        'category': 'Phones'
      },
      {
        'name': 'Sony WH-1000XM5',
        'brand': 'Sony',
        'price': 348.0,
        'oldPrice': 399.0,
        'rating': 4.9,
        'reviews': 1245,
        'image':
            'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=500',
        'tag': 'Top Rated',
        'category': 'Audio'
      },
      {
        'name': 'Canon EOS R6',
        'brand': 'Canon',
        'price': 2499.0,
        'oldPrice': null,
        'rating': 4.9,
        'reviews': 210,
        'image':
            'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500',
        'tag': 'Pro Choice',
        'category': 'Cameras'
      },
      {
        'name': 'PlayStation 5',
        'brand': 'Sony',
        'price': 499.0,
        'oldPrice': null,
        'rating': 5.0,
        'reviews': 3402,
        'image':
            'https://images.unsplash.com/photo-1606144042614-b0417c0ed615?w=500',
        'tag': 'Best Seller',
        'category': 'Gaming'
      },
    ];

    // Generate 50 more products dynamically
    _allProducts = [...baseProducts, ..._generateMoreProducts()];
  }

  List<Map<String, dynamic>> _generateMoreProducts() {
    List<Map<String, dynamic>> generated = [];
    final brands = [
      'Apple',
      'Samsung',
      'Sony',
      'Dell',
      'HP',
      'Asus',
      'Razer',
      'Logitech',
      'Bose'
    ];
    final categories = [
      'Laptops',
      'Phones',
      'Audio',
      'Cameras',
      'Gaming',
      'Wearables'
    ];
    final images = [
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500', // Laptop
      'https://images.unsplash.com/photo-1598327105666-5b89351aff23?w=500', // Phone
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', // Audio
      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500', // Camera
      'https://images.unsplash.com/photo-1592840496011-88086d5998d3?w=500', // Gaming
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500', // Watch
    ];

    for (int i = 0; i < 50; i++) {
      var category = categories[i % categories.length];
      var brand = brands[i % brands.length];
      var price = (math.Random().nextInt(2000) + 50).toDouble();

      generated.add({
        'name': '$brand ${category} ${i + 200}',
        'brand': brand,
        'price': price,
        'oldPrice': i % 3 == 0 ? price + (price * 0.2) : null,
        'rating': 3.5 + (math.Random().nextDouble() * 1.5),
        'reviews': math.Random().nextInt(1000),
        'image': images[i % images.length],
        'tag': i % 5 == 0 ? 'New' : (i % 7 == 0 ? 'Sale' : null),
        'category': category,
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

    if (_selectedCategoryIndex != 0) {
      String selectedCategory = _categories[_selectedCategoryIndex]['name'];
      list = list.where((p) => p['category'] == selectedCategory).toList();
    }

    if (_selectedBrands.isNotEmpty) {
      list = list.where((p) => _selectedBrands.contains(p['brand'])).toList();
    }

    if (_sortOption == 'price_asc') {
      list.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_sortOption == 'price_desc') {
      list.sort(
          (a, b) => (b['price'] as double).compareTo(a['price'] as double));
    } else if (_sortOption == 'rating') {
      list.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
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
            height: MediaQuery.of(context).size.height * 0.75, // Taller modal
            padding: const EdgeInsets.fromLTRB(
                20, 20, 20, 0), // Remove bottom padding here
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
                              selectedColor: Colors.blue.shade100,
                              checkmarkColor: Colors.blue.shade700,
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
      selectedColor: Colors.blue.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle:
          TextStyle(color: isSelected ? Colors.blue.shade900 : Colors.black),
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
                gradient: LinearGradient(
                    colors: [Colors.cyan.shade600, Colors.blue.shade800]),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.bolt, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Electronics",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5)),
              Text("Tech & Gadgets",
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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.cyan.shade400, Colors.blue.shade600]),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search gadgets, laptops...",
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
                    ? LinearGradient(
                        colors: [Colors.cyan.shade600, Colors.blue.shade600])
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
        ? "Featured Tech"
        : "${_categories[_selectedCategoryIndex]['name']} Collection";
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
                        if (product['tag'] != null)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: product['tag'].contains('%')
                                      ? Colors.red
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(product['tag'],
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
                                  if (product['oldPrice'] != null) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                        "\$${product['oldPrice'].toStringAsFixed(0)}",
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
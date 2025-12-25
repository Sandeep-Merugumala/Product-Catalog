import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MenScreen extends StatefulWidget {
  const MenScreen({super.key});

  @override
  State<MenScreen> createState() => _MenScreenState();
}

class _MenScreenState extends State<MenScreen> with TickerProviderStateMixin {
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

  // Data
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.grid_view,
      'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)]
    },
    {
      'name': 'T-Shirts',
      'icon': Icons.checkroom,
      'gradient': [const Color(0xFFf093fb), const Color(0xFFF5576c)]
    },
    {
      'name': 'Shirts',
      'icon': Icons.business,
      'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)]
    },
    {
      'name': 'Jeans',
      'icon': Icons.dry_cleaning,
      'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)]
    },
    {
      'name': 'Shoes',
      'icon': Icons.hiking,
      'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)]
    },
    {
      'name': 'Watches',
      'icon': Icons.watch,
      'gradient': [const Color(0xFF30cfd0), const Color(0xFF330867)]
    },
    {
      'name': 'Active',
      'icon': Icons.fitness_center,
      'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)]
    },
  ];

  final List<Map<String, String>> _banners = [
    {
      'image':
          'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=1200',
      'title': 'New Season',
      'subtitle': 'Up to 50% Off',
      'badge': 'LIMITED TIME'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=1200',
      'title': 'Premium Denim',
      'subtitle': 'Exclusive Collection',
      'badge': 'NEW ARRIVAL'
    },
    {
      'image':
          'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=1200',
      'title': 'Formal Wear',
      'subtitle': 'Office Ready',
      'badge': 'TRENDING'
    },
  ];

  late List<Map<String, dynamic>> _allProducts;

  @override
  void initState() {
    super.initState();
    _initializeProducts();

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
    _allProducts = [
      // --- T-SHIRTS ---
      {
        'name': 'Classic V-Neck Tee',
        'brand': 'Nike',
        'price': 45.0,
        'oldPrice': 65.0,
        'rating': 4.8,
        'reviews': 234,
        'image':
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
        'tag': 'Best Seller',
        'category': 'T-Shirts'
      },
      {
        'name': 'Performance Polo',
        'brand': 'Adidas',
        'price': 55.0,
        'oldPrice': 75.0,
        'rating': 4.7,
        'reviews': 189,
        'image':
            'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=500',
        'tag': '-27%',
        'category': 'T-Shirts'
      },
      {
        'name': 'Graphic Print Tee',
        'brand': 'Puma',
        'price': 35.0,
        'rating': 4.6,
        'reviews': 156,
        'image':
            'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
        'tag': 'New',
        'category': 'T-Shirts'
      },
      {
        'name': 'Cotton Crew Neck',
        'brand': 'H&M',
        'price': 25.0,
        'oldPrice': 40.0,
        'rating': 4.5,
        'reviews': 287,
        'image':
            'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=500',
        'tag': '-37%',
        'category': 'T-Shirts'
      },
      {
        'name': 'Striped Summer Tee',
        'brand': 'Zara',
        'price': 29.0,
        'rating': 4.4,
        'reviews': 120,
        'image':
            'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500',
        'tag': null,
        'category': 'T-Shirts'
      },
      {
        'name': 'Oversized Street Tee',
        'brand': 'Urban',
        'price': 40.0,
        'rating': 4.8,
        'reviews': 310,
        'image':
            'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=500',
        'tag': 'Trending',
        'category': 'T-Shirts'
      },
      {
        'name': 'Vintage Logo Tee',
        'brand': 'Levis',
        'price': 35.0,
        'oldPrice': 50.0,
        'rating': 4.6,
        'reviews': 200,
        'image':
            'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500',
        'tag': 'Sale',
        'category': 'T-Shirts'
      },
      {
        'name': 'Henley Long Sleeve',
        'brand': 'Gap',
        'price': 45.0,
        'rating': 4.5,
        'reviews': 150,
        'image':
            'https://images.unsplash.com/photo-1618354691229-88d47f285158?w=500',
        'tag': null,
        'category': 'T-Shirts'
      },

      // --- SHIRTS ---
      {
        'name': 'Oxford Button Down',
        'brand': 'Ralph Lauren',
        'price': 89.0,
        'oldPrice': 120.0,
        'rating': 4.9,
        'reviews': 345,
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
        'tag': 'Premium',
        'category': 'Shirts'
      },
      {
        'name': 'Linen Summer Shirt',
        'brand': 'Tommy Hilfiger',
        'price': 79.0,
        'rating': 4.8,
        'reviews': 234,
        'image':
            'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500',
        'tag': 'New',
        'category': 'Shirts'
      },
      {
        'name': 'Checkered Flannel',
        'brand': 'H&M',
        'price': 49.0,
        'oldPrice': 60.0,
        'rating': 4.6,
        'reviews': 180,
        'image':
            'https://images.unsplash.com/photo-1589642380614-4a8c2147b857?w=500',
        'tag': 'Winter',
        'category': 'Shirts'
      },
      {
        'name': 'Denim Shirt',
        'brand': 'Levis',
        'price': 65.0,
        'rating': 4.7,
        'reviews': 220,
        'image':
            'https://images.unsplash.com/photo-1574634534894-89d7576c8259?w=500',
        'tag': 'Classic',
        'category': 'Shirts'
      },
      {
        'name': 'Formal White Shirt',
        'brand': 'Calvin Klein',
        'price': 85.0,
        'oldPrice': 110.0,
        'rating': 4.8,
        'reviews': 400,
        'image':
            'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?w=500',
        'tag': 'Office',
        'category': 'Shirts'
      },
      {
        'name': 'Slim Fit Print',
        'brand': 'Zara',
        'price': 55.0,
        'rating': 4.5,
        'reviews': 150,
        'image':
            'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=500',
        'tag': null,
        'category': 'Shirts'
      },
      {
        'name': 'Casual Chambray',
        'brand': 'Gap',
        'price': 50.0,
        'rating': 4.6,
        'reviews': 190,
        'image':
            'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=500',
        'tag': null,
        'category': 'Shirts'
      },

      // --- JEANS ---
      {
        'name': 'Slim Fit Jeans',
        'brand': "Levi's",
        'price': 89.0,
        'oldPrice': 120.0,
        'rating': 4.9,
        'reviews': 456,
        'image':
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500',
        'tag': 'Best Seller',
        'category': 'Jeans'
      },
      {
        'name': 'Straight Leg Denim',
        'brand': 'Wrangler',
        'price': 79.0,
        'rating': 4.7,
        'reviews': 289,
        'image':
            'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500',
        'tag': 'Classic',
        'category': 'Jeans'
      },
      {
        'name': 'Ripped Skinny Jeans',
        'brand': 'Diesel',
        'price': 110.0,
        'oldPrice': 150.0,
        'rating': 4.6,
        'reviews': 210,
        'image':
            'https://images.unsplash.com/photo-1582418702059-97ebafb35d09?w=500',
        'tag': 'Trending',
        'category': 'Jeans'
      },
      {
        'name': 'Black Tapered',
        'brand': 'H&M',
        'price': 40.0,
        'rating': 4.5,
        'reviews': 300,
        'image':
            'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=500',
        'tag': null,
        'category': 'Jeans'
      },
      {
        'name': 'Vintage Wash',
        'brand': 'Lee',
        'price': 75.0,
        'rating': 4.7,
        'reviews': 180,
        'image':
            'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=500',
        'tag': 'New',
        'category': 'Jeans'
      },
      {
        'name': 'Relaxed Fit',
        'brand': 'Gap',
        'price': 60.0,
        'oldPrice': 80.0,
        'rating': 4.6,
        'reviews': 150,
        'image':
            'https://images.unsplash.com/photo-1602293589946-8b245fa3a888?w=500',
        'tag': 'Comfort',
        'category': 'Jeans'
      },
      {
        'name': 'White Denim',
        'brand': 'Zara',
        'price': 50.0,
        'rating': 4.4,
        'reviews': 110,
        'image':
            'https://images.unsplash.com/photo-1584370848010-d7ccb2211603?w=500',
        'tag': 'Summer',
        'category': 'Jeans'
      },

      // --- SHOES ---
      {
        'name': 'Air Max Sneakers',
        'brand': 'Nike',
        'price': 149.0,
        'oldPrice': 200.0,
        'rating': 4.9,
        'reviews': 567,
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        'tag': 'Best Seller',
        'category': 'Shoes'
      },
      {
        'name': 'Stan Smith',
        'brand': 'Adidas',
        'price': 129.0,
        'rating': 4.8,
        'reviews': 423,
        'image':
            'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500',
        'tag': 'Classic',
        'category': 'Shoes'
      },
      {
        'name': 'Desert Boots',
        'brand': 'Clarks',
        'price': 119.0,
        'oldPrice': 160.0,
        'rating': 4.6,
        'reviews': 189,
        'image':
            'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=500',
        'tag': '-25%',
        'category': 'Shoes'
      },
      {
        'name': 'Old Skool',
        'brand': 'Vans',
        'price': 70.0,
        'rating': 4.8,
        'reviews': 600,
        'image':
            'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500',
        'tag': 'Hot',
        'category': 'Shoes'
      },
      {
        'name': 'Chelsea Boots',
        'brand': 'Timberland',
        'price': 160.0,
        'rating': 4.9,
        'reviews': 300,
        'image':
            'https://images.unsplash.com/photo-1638361073801-443b749553b4?w=500',
        'tag': 'Winter',
        'category': 'Shoes'
      },
      {
        'name': 'Leather Loafers',
        'brand': 'Gucci',
        'price': 450.0,
        'rating': 4.9,
        'reviews': 50,
        'image':
            'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=500',
        'tag': 'Luxury',
        'category': 'Shoes'
      },
      {
        'name': 'Running Shoes',
        'brand': 'New Balance',
        'price': 110.0,
        'rating': 4.7,
        'reviews': 250,
        'image':
            'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500',
        'tag': 'Sport',
        'category': 'Shoes'
      },
      {
        'name': 'High Tops',
        'brand': 'Converse',
        'price': 65.0,
        'rating': 4.7,
        'reviews': 500,
        'image':
            'https://images.unsplash.com/photo-1607522370275-f14bc3a5d288?w=500',
        'tag': null,
        'category': 'Shoes'
      },

      // --- WATCHES ---
      {
        'name': 'Chronograph Watch',
        'brand': 'Fossil',
        'price': 159.0,
        'oldPrice': 220.0,
        'rating': 4.8,
        'reviews': 289,
        'image':
            'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500',
        'tag': 'Best Seller',
        'category': 'Watches'
      },
      {
        'name': 'Smart Watch',
        'brand': 'Casio',
        'price': 199.0,
        'rating': 4.9,
        'reviews': 423,
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        'tag': 'Premium',
        'category': 'Watches'
      },
      {
        'name': 'Leather Strap',
        'brand': 'Daniel Wellington',
        'price': 130.0,
        'rating': 4.6,
        'reviews': 180,
        'image':
            'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=500',
        'tag': 'Classic',
        'category': 'Watches'
      },
      {
        'name': 'Digital Sport',
        'brand': 'G-Shock',
        'price': 110.0,
        'rating': 4.8,
        'reviews': 400,
        'image':
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500',
        'tag': 'Rugged',
        'category': 'Watches'
      },
      {
        'name': 'Automatic Diver',
        'brand': 'Seiko',
        'price': 350.0,
        'oldPrice': 450.0,
        'rating': 4.9,
        'reviews': 120,
        'image':
            'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?w=500',
        'tag': 'Luxury',
        'category': 'Watches'
      },
      {
        'name': 'Minimalist Gold',
        'brand': 'MVMT',
        'price': 140.0,
        'rating': 4.5,
        'reviews': 150,
        'image':
            'https://images.unsplash.com/photo-1539874753764-539943364451?w=500',
        'tag': null,
        'category': 'Watches'
      },

      // --- ACTIVE ---
      {
        'name': 'Compression Top',
        'brand': 'Under Armour',
        'price': 35.0,
        'rating': 4.7,
        'reviews': 300,
        'image':
            'https://images.unsplash.com/photo-1518459031867-a89b944bffe4?w=500',
        'tag': 'Gym',
        'category': 'Active'
      },
      {
        'name': 'Training Shorts',
        'brand': 'Nike',
        'price': 30.0,
        'oldPrice': 45.0,
        'rating': 4.6,
        'reviews': 250,
        'image':
            'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500',
        'tag': 'Sale',
        'category': 'Active'
      },
      {
        'name': 'Track Jacket',
        'brand': 'Adidas',
        'price': 70.0,
        'rating': 4.8,
        'reviews': 180,
        'image':
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500',
        'tag': 'New',
        'category': 'Active'
      },
      {
        'name': 'Gym Tank',
        'brand': 'Gymshark',
        'price': 25.0,
        'rating': 4.5,
        'reviews': 150,
        'image':
            'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=500',
        'tag': null,
        'category': 'Active'
      },
      {
        'name': 'Running Tights',
        'brand': 'Asics',
        'price': 45.0,
        'rating': 4.7,
        'reviews': 130,
        'image':
            'https://images.unsplash.com/photo-1483721310020-03333e577078?w=500',
        'tag': 'Pro',
        'category': 'Active'
      },
    ];
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
      backgroundColor: const Color(0xFFEBF5FF), // Subtle Premium Blue Tint
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
      backgroundColor:
          const Color(0xFFEBF5FF), // Matches Scaffold for seamless look
      elevation: _showElevation ? 8 : 0,
      leading: IconButton(
        icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12)), // White button for contrast
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
                    colors: [Colors.blue.shade600, Colors.purple.shade600]),
                borderRadius: BorderRadius.circular(10)),
            child: const Text('👔', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Men's Fashion",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5)),
              Text("Premium Collection",
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
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12)), // White button for contrast
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
                    colors: [Colors.blue.shade400, Colors.purple.shade400]),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search brands, products...",
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
                        colors: [Colors.blue.shade600, Colors.purple.shade600])
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
        ? "New Arrivals"
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.grey.shade200)), // White for contrast
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
                              gradient: LinearGradient(
                                  // ← NEW: Use gradient instead of solid color
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.purple.shade600
                                  ]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blue.withOpacity(
                                        0.3), // ← Optional: match shadow to gradient
                                    blurRadius: 8,
                                    offset: const Offset(0, 4))
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

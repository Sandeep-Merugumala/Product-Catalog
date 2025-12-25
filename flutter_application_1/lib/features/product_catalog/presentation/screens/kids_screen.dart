import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productSectionKey = GlobalKey();
  final CarouselSliderController _carouselController = CarouselSliderController();
  
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  bool _showElevation = false;
  int _selectedCategoryIndex = 0;
  int _currentBannerIndex = 0;

  String _sortOption = 'default';
  final List<String> _selectedBrands = [];
  
  // Category Data
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view, 'gradient': [const Color(0xFFFF9800), const Color(0xFFFFB74D)]},
    {'name': 'Toys', 'icon': Icons.toys, 'gradient': [const Color(0xFF4CAF50), const Color(0xFF81C784)]},
    {'name': 'School', 'icon': Icons.backpack, 'gradient': [const Color(0xFF2196F3), const Color(0xFF64B5F6)]},
    {'name': 'T-Shirts', 'icon': Icons.checkroom, 'gradient': [const Color(0xFFE91E63), const Color(0xFFF06292)]},
    {'name': 'Shorts', 'icon': Icons.short_text, 'gradient': [const Color(0xFFFFC107), const Color(0xFFFFD54F)]},
    {'name': 'Shoes', 'icon': Icons.directions_run, 'gradient': [const Color(0xFF9C27B0), const Color(0xFFBA68C8)]},
    {'name': 'Party', 'icon': Icons.cake, 'gradient': [const Color(0xFF00BCD4), const Color(0xFF4DD0E1)]},
  ];

  // Banner Data
  final List<Map<String, String>> _banners = [
    {
      'image': 'https://images.unsplash.com/photo-1503919545885-7f4941199e68?w=1200&auto=format&fit=crop',
      'title': 'Back to School',
      'subtitle': 'Everything they need',
      'badge': 'ESSENTIALS'
    },
    {
      'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=1200&auto=format&fit=crop',
      'title': 'Summer Fun',
      'subtitle': 'Swim & Play Gear',
      'badge': 'NEW ARRIVAL'
    },
    {
      'image': 'https://images.unsplash.com/photo-1596464716127-f9a8759fa229?w=1200&auto=format&fit=crop',
      'title': 'Toy Kingdom',
      'subtitle': 'Top Toys for Kids',
      'badge': 'FUN'
    },
  ];

  late List<Map<String, dynamic>> _allProducts;

  @override
  void initState() {
    super.initState();
    _initializeHardcodedProducts(); 
    
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
      }
    });
  }

  void _initializeHardcodedProducts() {
    _allProducts = [
      // --- TOYS (10 Items) ---
      {'name': 'Lego City Set', 'brand': 'Lego', 'price': 59.99, 'rating': 4.9, 'reviews': 1200, 'image': 'https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=500', 'tag': 'Bestseller', 'category': 'Toys'},
      {'name': 'Wooden Train', 'brand': 'Melissa & Doug', 'price': 24.99, 'rating': 4.7, 'reviews': 340, 'image': 'https://images.unsplash.com/photo-1596464716127-f9a8759fa229?w=500', 'tag': null, 'category': 'Toys'},
      {'name': 'Plush Teddy', 'brand': 'Gund', 'price': 19.99, 'rating': 4.8, 'reviews': 560, 'image': 'https://images.unsplash.com/photo-1559454403-b8fb87521bc7?w=500', 'tag': 'Gift', 'category': 'Toys'},
      {'name': 'Hot Wheels Car', 'brand': 'Mattel', 'price': 34.99, 'rating': 4.6, 'reviews': 210, 'image': 'https://images.unsplash.com/photo-1594787318286-3d835c1d207f?w=500', 'tag': 'New', 'category': 'Toys'},
      {'name': 'Doll House', 'brand': 'KidKraft', 'price': 149.99, 'oldPrice': 179.99, 'rating': 4.9, 'reviews': 890, 'image': 'https://images.unsplash.com/photo-1513884923967-4b182ef16715?w=500', 'tag': 'Sale', 'category': 'Toys'},
      {'name': 'Action Figure', 'brand': 'Hasbro', 'price': 12.99, 'rating': 4.5, 'reviews': 150, 'image': 'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=500', 'tag': null, 'category': 'Toys'},
      {'name': 'Puzzle (500pc)', 'brand': 'Ravensburger', 'price': 18.50, 'rating': 4.7, 'reviews': 230, 'image': 'https://images.unsplash.com/photo-1588058365815-c96ac30249c4?w=500', 'tag': null, 'category': 'Toys'},
      {'name': 'Play-Doh Set', 'brand': 'Play-Doh', 'price': 15.00, 'rating': 4.8, 'reviews': 400, 'image': 'https://images.unsplash.com/photo-1558679908-541bcf1249ff?w=500', 'tag': 'Creative', 'category': 'Toys'},
      {'name': 'Toy Robot', 'brand': 'TechKids', 'price': 99.99, 'rating': 4.9, 'reviews': 110, 'image': 'https://images.unsplash.com/photo-1535378437323-9555f3e7f5bb?w=500', 'tag': 'Tech', 'category': 'Toys'},
      {'name': 'Dino Figure', 'brand': 'Schleich', 'price': 22.99, 'rating': 4.6, 'reviews': 315, 'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500', 'tag': 'Dino', 'category': 'Toys'},

      // --- SCHOOL (8 Items) ---
      {'name': 'Blue Backpack', 'brand': 'JanSport', 'price': 45.00, 'rating': 4.8, 'reviews': 600, 'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500', 'tag': 'Popular', 'category': 'School'},
      {'name': 'Yellow Lunchbox', 'brand': 'Skip Hop', 'price': 18.00, 'rating': 4.7, 'reviews': 150, 'image': 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=500', 'tag': 'Cute', 'category': 'School'},
      {'name': 'Pencils (24)', 'brand': 'Crayola', 'price': 5.99, 'rating': 4.9, 'reviews': 900, 'image': 'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=500', 'tag': 'Essential', 'category': 'School'},
      {'name': 'Notebook Set', 'brand': 'Mead', 'price': 8.50, 'rating': 4.5, 'reviews': 200, 'image': 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=500', 'tag': null, 'category': 'School'},
      {'name': 'Water Bottle', 'brand': 'CamelBak', 'price': 14.00, 'rating': 4.8, 'reviews': 350, 'image': 'https://images.unsplash.com/photo-1602143407151-011141950038?w=500', 'tag': 'BPA Free', 'category': 'School'},
      {'name': 'Pencil Case', 'brand': 'Smiggle', 'price': 12.00, 'rating': 4.6, 'reviews': 120, 'image': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=500', 'tag': null, 'category': 'School'},
      {'name': 'Kids Scissors', 'brand': 'Fiskars', 'price': 4.50, 'rating': 4.7, 'reviews': 180, 'image': 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=500', 'tag': null, 'category': 'School'},
      {'name': 'Calculator', 'brand': 'Texas Instruments', 'price': 18.99, 'rating': 4.9, 'reviews': 500, 'image': 'https://images.unsplash.com/photo-1564473265889-1e7a5d97f374?w=500', 'tag': 'Tech', 'category': 'School'},

      // --- T-SHIRTS (8 Items) ---
      {'name': 'Graphic Tee', 'brand': 'Marvel', 'price': 14.99, 'rating': 4.7, 'reviews': 450, 'image': 'https://images.unsplash.com/photo-1519238263496-4143a9323b74?w=500', 'tag': 'Cool', 'category': 'T-Shirts'},
      {'name': 'White Tee 3pk', 'brand': 'Hanes', 'price': 12.00, 'rating': 4.5, 'reviews': 1000, 'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', 'tag': 'Basic', 'category': 'T-Shirts'},
      {'name': 'Striped Polo', 'brand': 'Ralph Lauren', 'price': 35.00, 'rating': 4.8, 'reviews': 150, 'image': 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=500', 'tag': 'Premium', 'category': 'T-Shirts'},
      {'name': 'Dino Tee', 'brand': 'Gap Kids', 'price': 16.50, 'oldPrice': 22.00, 'rating': 4.6, 'reviews': 230, 'image': 'https://images.unsplash.com/photo-1503919545885-7f4941199e68?w=500', 'tag': 'Sale', 'category': 'T-Shirts'},
      {'name': 'Floral Top', 'brand': 'Zara Kids', 'price': 18.00, 'rating': 4.7, 'reviews': 210, 'image': 'https://images.unsplash.com/photo-1621452773781-0f992fd0f5d0?w=500', 'tag': 'Summer', 'category': 'T-Shirts'},
      {'name': 'Sports Jersey', 'brand': 'Nike Kids', 'price': 25.00, 'rating': 4.9, 'reviews': 340, 'image': 'https://images.unsplash.com/photo-1628149455676-12df595303eb?w=500', 'tag': 'Sport', 'category': 'T-Shirts'},
      {'name': 'Character Tee', 'brand': 'Disney', 'price': 19.99, 'rating': 4.8, 'reviews': 560, 'image': 'https://images.unsplash.com/photo-1604467794349-0b74285de7e7?w=500', 'tag': null, 'category': 'T-Shirts'},
      {'name': 'Long Sleeve', 'brand': 'OshKosh', 'price': 20.00, 'rating': 4.5, 'reviews': 110, 'image': 'https://images.unsplash.com/photo-1618359057154-e21ae64350b6?w=500', 'tag': null, 'category': 'T-Shirts'},

      // --- SHORTS (8 Items) ---
      {'name': 'Denim Shorts', 'brand': 'Levis Kids', 'price': 24.00, 'rating': 4.6, 'reviews': 320, 'image': 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500', 'tag': null, 'category': 'Shorts'},
      {'name': 'Cargo Shorts', 'brand': 'Old Navy', 'price': 18.99, 'rating': 4.5, 'reviews': 210, 'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=500', 'tag': 'Rugged', 'category': 'Shorts'},
      {'name': 'Athletic Shorts', 'brand': 'Under Armour', 'price': 22.00, 'rating': 4.8, 'reviews': 450, 'image': 'https://images.unsplash.com/photo-1565548058867-b52b212f0c7e?w=500', 'tag': 'Sport', 'category': 'Shorts'},
      {'name': 'Chino Shorts', 'brand': 'H&M Kids', 'price': 12.99, 'rating': 4.4, 'reviews': 180, 'image': 'https://images.unsplash.com/photo-1596870230751-ebdfce98ec42?w=500', 'tag': null, 'category': 'Shorts'},
      {'name': 'Board Shorts', 'brand': 'Quiksilver', 'price': 29.50, 'oldPrice': 39.50, 'rating': 4.7, 'reviews': 200, 'image': 'https://images.unsplash.com/photo-1560243563-062bfc001d68?w=500', 'tag': 'Swim', 'category': 'Shorts'},
      {'name': 'Bike Shorts', 'brand': 'Athleta Girl', 'price': 19.00, 'rating': 4.8, 'reviews': 130, 'image': 'https://images.unsplash.com/photo-1560243563-062bfc001d68?w=500', 'tag': 'Comfy', 'category': 'Shorts'},
      {'name': 'Plaid Shorts', 'brand': 'Carter\'s', 'price': 14.00, 'rating': 4.5, 'reviews': 160, 'image': 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500', 'tag': null, 'category': 'Shorts'},
      {'name': 'Skirt-Shorts', 'brand': 'Gap Kids', 'price': 21.00, 'rating': 4.6, 'reviews': 140, 'image': 'https://images.unsplash.com/photo-1621452773781-0f992fd0f5d0?w=500', 'tag': 'Cute', 'category': 'Shorts'},

      // --- SHOES (8 Items) ---
      {'name': 'Air Max 90', 'brand': 'Nike Kids', 'price': 85.00, 'rating': 4.9, 'reviews': 800, 'image': 'https://images.unsplash.com/photo-1514989940723-e88727357428?w=500', 'tag': 'Trending', 'category': 'Shoes'},
      {'name': 'Classic Chucks', 'brand': 'Converse', 'price': 40.00, 'rating': 4.8, 'reviews': 1500, 'image': 'https://images.unsplash.com/photo-1616896228318-7a57a530f282?w=500', 'tag': 'Classic', 'category': 'Shoes'},
      {'name': 'Light-Up Sneaker', 'brand': 'Skechers', 'price': 45.00, 'rating': 4.7, 'reviews': 420, 'image': 'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=500', 'tag': 'Fun', 'category': 'Shoes'},
      {'name': 'Yellow Rain Boot', 'brand': 'Hunter', 'price': 55.00, 'rating': 4.8, 'reviews': 300, 'image': 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=500', 'tag': 'Waterproof', 'category': 'Shoes'}, 
      {'name': 'Hiking Boots', 'brand': 'Timberland', 'price': 70.00, 'rating': 4.9, 'reviews': 250, 'image': 'https://images.unsplash.com/photo-1520639069628-194d7938a9b7?w=500', 'tag': 'Durable', 'category': 'Shoes'}, 
      {'name': 'Summer Sandals', 'brand': 'Crocs', 'price': 30.00, 'rating': 4.6, 'reviews': 1100, 'image': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500', 'tag': 'Comfy', 'category': 'Shoes'},
      {'name': 'Ballet Flats', 'brand': 'Stride Rite', 'price': 35.00, 'rating': 4.5, 'reviews': 180, 'image': 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500', 'tag': 'Dressy', 'category': 'Shoes'},
      {'name': 'Slip-On Canvas', 'brand': 'Vans', 'price': 35.00, 'rating': 4.8, 'reviews': 600, 'image': 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500', 'tag': null, 'category': 'Shoes'}, 

      // --- PARTY (8 Items) ---
      {'name': 'Princess Dress', 'brand': 'Disney', 'price': 49.99, 'rating': 4.9, 'reviews': 350, 'image': 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500', 'tag': 'Dreamy', 'category': 'Party'}, 
      {'name': 'Boys Suit Set', 'brand': 'Calvin Klein', 'price': 89.99, 'rating': 4.8, 'reviews': 120, 'image': 'https://images.unsplash.com/photo-1503919545885-7f4941199e68?w=500', 'tag': 'Formal', 'category': 'Party'},
      {'name': 'Sparkle Tutu', 'brand': 'Cat & Jack', 'price': 22.00, 'rating': 4.7, 'reviews': 200, 'image': 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500', 'tag': 'Shiny', 'category': 'Party'},
      {'name': 'Bow Tie', 'brand': 'H&M', 'price': 15.00, 'rating': 4.6, 'reviews': 150, 'image': 'https://images.unsplash.com/photo-1565522732959-1e338bd7c7e5?w=500', 'tag': 'Accessories', 'category': 'Party'}, 
      {'name': 'Party Balloons', 'brand': 'Party City', 'price': 12.99, 'rating': 4.5, 'reviews': 500, 'image': 'https://images.unsplash.com/photo-1505236858274-097d75f79603?w=500', 'tag': 'Decor', 'category': 'Party'}, 
      {'name': 'Birthday Crown', 'brand': 'Etsy Handmade', 'price': 18.00, 'rating': 4.9, 'reviews': 80, 'image': 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=500', 'tag': 'Unique', 'category': 'Party'},
      {'name': 'Kids Tuxedo', 'brand': 'Nautica', 'price': 75.00, 'rating': 4.8, 'reviews': 90, 'image': 'https://images.unsplash.com/photo-1503919545885-7f4941199e68?w=500', 'tag': 'Elegant', 'category': 'Party'}, 
      {'name': 'Costume Wings', 'brand': 'Costume Supercenter', 'price': 14.50, 'rating': 4.6, 'reviews': 130, 'image': 'https://images.unsplash.com/photo-1615582387994-b7f569359e9a?w=500', 'tag': 'Fun', 'category': 'Party'}, 
    ];
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<String> get _availableBrands => _allProducts.map((e) => e['brand'] as String).toSet().toList();

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
      list.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_sortOption == 'price_desc') {
      list.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
    }
    return list;
  }

  void _scrollToProducts() {
    Scrollable.ensureVisible(_productSectionKey.currentContext!, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Filter & Sort", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), TextButton(onPressed: () { setState(() { _sortOption = 'default'; _selectedBrands.clear(); }); setStateModal(() {}); }, child: const Text("Reset All", style: TextStyle(color: Colors.orange)))]),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sort by Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(spacing: 10, children: [_buildChoiceChip("Low to High", _sortOption == 'price_asc', (selected) => setStateModal(() => _sortOption = selected ? 'price_asc' : 'default')), _buildChoiceChip("High to Low", _sortOption == 'price_desc', (selected) => setStateModal(() => _sortOption = selected ? 'price_desc' : 'default'))]),
                        const SizedBox(height: 20),
                        const Text("Brands", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(spacing: 8, runSpacing: 8, children: _availableBrands.map((brand) { final isSelected = _selectedBrands.contains(brand); return FilterChip(label: Text(brand), selected: isSelected, onSelected: (bool selected) => setStateModal(() => selected ? _selectedBrands.add(brand) : _selectedBrands.remove(brand)), backgroundColor: Colors.orange.shade50, selectedColor: Colors.orange.shade200, checkmarkColor: Colors.orange.shade900); }).toList()),
                      ],
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(bottom: 20, top: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() {}); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text("Show ${_filteredProducts.length} Results", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(label: Text(label), selected: isSelected, onSelected: onSelected, selectedColor: Colors.orange.shade100, backgroundColor: Colors.grey.shade100, labelStyle: TextStyle(color: isSelected ? Colors.orange.shade900 : Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7), // Light Yellow
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildCarouselBanner()),
          SliverToBoxAdapter(child: _buildCategorySelector()),
          SliverToBoxAdapter(key: _productSectionKey, child: _buildSectionTitle()),
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
      backgroundColor: const Color(0xFFFFFDE7),
      elevation: _showElevation ? 8 : 0,
      leading: IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18)), onPressed: () => Navigator.pop(context)),
      title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.yellow.shade600]), borderRadius: BorderRadius.circular(10)), child: const Text('🧸', style: TextStyle(fontSize: 20))), const SizedBox(width: 12), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Kids' Zone", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)), Text("Fun & Fashion", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500))])]),
      actions: [IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.filter_list, color: Colors.black, size: 20)), onPressed: _showFilterModal), const SizedBox(width: 8)],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: 56,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
      child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade300, Colors.yellow.shade400]), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.search, color: Colors.white, size: 20)), const SizedBox(width: 15), const Expanded(child: TextField(decoration: InputDecoration(hintText: "Search toys, clothes...", border: InputBorder.none))), const Icon(Icons.mic_none, color: Colors.grey)]),
    );
  }

  Widget _buildCarouselBanner() {
    return Column(children: [const SizedBox(height: 16), CarouselSlider(carouselController: _carouselController, options: CarouselOptions(height: 200, autoPlay: true, viewportFraction: 0.92, enlargeCenterPage: true, onPageChanged: (index, reason) => setState(() => _currentBannerIndex = index)), items: _banners.map((banner) { return Container(margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Stack(children: [Image.network(banner['image']!, fit: BoxFit.cover, width: double.infinity, height: double.infinity), Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent]))), Positioned(left: 24, top: 20, bottom: 20, right: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Text(banner['badge']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange))), const SizedBox(height: 12), Flexible(child: Text(banner['title']!, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1))), const SizedBox(height: 8), Text(banner['subtitle']!, style: const TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 16), ElevatedButton(onPressed: _scrollToProducts, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Shop Now', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 16)]))]))]))); }).toList()), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.center, children: _banners.asMap().entries.map((entry) { return AnimatedContainer(duration: const Duration(milliseconds: 300), width: _currentBannerIndex == entry.key ? 32 : 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), gradient: _currentBannerIndex == entry.key ? const LinearGradient(colors: [Colors.orange, Colors.yellow]) : null, color: _currentBannerIndex == entry.key ? null : Colors.grey.shade300)); }).toList())]);
  }

  Widget _buildCategorySelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 12), child: Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), SizedBox(height: 50, child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, itemCount: _categories.length, itemBuilder: (context, index) { final isSelected = _selectedCategoryIndex == index; final category = _categories[index]; return GestureDetector(onTap: () => setState(() => _selectedCategoryIndex = index), child: AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(gradient: isSelected ? LinearGradient(colors: category['gradient'] as List<Color>) : null, color: isSelected ? null : Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [if (isSelected) BoxShadow(color: (category['gradient'] as List<Color>)[0].withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)) else BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]), child: Row(children: [Icon(category['icon'] as IconData, size: 18, color: isSelected ? Colors.white : Colors.grey.shade600), const SizedBox(width: 8), Text(category['name'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 13))]))); }))]);
  }

  Widget _buildSectionTitle() {
    String title = _selectedCategoryIndex == 0 ? "New Arrivals" : "${_categories[_selectedCategoryIndex]['name']} Collection";
    return Padding(padding: const EdgeInsets.fromLTRB(16, 32, 16, 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), GestureDetector(onTap: _showFilterModal, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange.shade100)), child: const Row(children: [Text("Sort/Filter", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.tune, size: 16)])))]));
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(40.0), child: Center(child: Text("No products match your filters."))));
    return SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16), sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.58), delegate: SliverChildBuilderDelegate((context, index) { final product = products[index]; return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: Stack(children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(product['image'], width: double.infinity, fit: BoxFit.cover)), if (product['tag'] != null) Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)), child: Text(product['tag'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))), Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.favorite_border, size: 18, color: Colors.orange)))] )), Expanded(flex: 4, child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(product['brand'].toString().toUpperCase(), style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(product['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 6), Row(children: [Text("\$${product['price'].toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), if (product['oldPrice'] != null) ...[const SizedBox(width: 6), Text("\$${product['oldPrice'].toStringAsFixed(0)}", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade400, fontSize: 12))]])]), Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]), child: const Center(child: Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))))]))) ])); }, childCount: products.length)));
  }
}
// lib/features/product_catalog/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> products = [
    {'name': 'Sony Headphones', 'price': '29,999', 'tag': 'AI Pick', 'color': Colors.indigo, 'img': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400'},
    {'name': 'Smart Watch', 'price': '42,500', 'tag': 'Trending', 'color': Colors.pink, 'img': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'},
    {'name': 'Nike Runners', 'price': '14,999', 'tag': 'Smart Fit', 'color': Colors.green, 'img': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'},
    {'name': 'Smart Camera', 'price': '18,500', 'tag': 'Best Value', 'color': Colors.amber, 'img': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400'},
  ];

  @override
  Widget build(BuildContext context) {
    // Safety check for Extension
    final aiExt = Theme.of(context).extension<AIThemeExtension>() ?? 
                 const AIThemeExtension(glowColor: Colors.purple, glassGradient: LinearGradient(colors: [Colors.purple, Colors.blue]));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDark),
          _buildSearch(aiExt),
          _buildBanner(), // Fixed Overflow
          _buildCategories(),
          _buildGrid(aiExt),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      pinned: true,
      title: const Text('Smart Catalog', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        ),
        const CircleAvatar(backgroundColor: AppTheme.primaryPurple, radius: 15),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildSearch(AIThemeExtension aiExt) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: aiExt.glowColor ?? Colors.transparent, blurRadius: 20)]),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search "Budget headphones"...',
              prefixIcon: Icon(Icons.auto_awesome, color: AppTheme.primaryPurple),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 150, // Strict height to prevent overflow
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: [Color(0xFF673AB7), Color(0xFF9C27B0)]),
        ),
        child: Row(
          children: [
            Expanded( // Prevents text from pushing out
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('AI Recommendation', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 8),
                  Text('Find the perfect\nmatch for you', 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.1)),
                ],
              ),
            ),
            const Icon(Icons.auto_awesome, size: 80, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final cats = ['All', 'Electronics', 'Fashion', 'Home'];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: cats.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cats[i]),
              selected: _selectedCategory == cats[i],
              onSelected: (s) => setState(() => _selectedCategory = cats[i]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(AIThemeExtension aiExt) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) {
            final p = products[i % products.length];
            final Color pColor = p['color'] as Color? ?? Colors.purple; // Null safety fix

            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: pColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        image: DecorationImage(image: NetworkImage(p['img']), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['tag'], style: TextStyle(color: pColor, fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                        Text('₹${p['price']}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: AppTheme.primaryPurple,
      icon: const Icon(Icons.psychology, color: Colors.white),
      label: const Text('Ask AI', style: TextStyle(color: Colors.white)),
    );
  }
}
import 'package:flutter/material.dart';
import 'models.dart';

class WardrobeSelector extends StatefulWidget {
  final Function(ClothingItem) onItemSelected;
  final Map<FashionCategory, ClothingItem?> currentLook;

  const WardrobeSelector({
    super.key,
    required this.onItemSelected,
    required this.currentLook,
  });

  @override
  State<WardrobeSelector> createState() => _WardrobeSelectorState();
}

class _WardrobeSelectorState extends State<WardrobeSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: Colors.black87,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: '👚 Tops'),
              Tab(text: '👖 Bottoms'),
              Tab(text: '👠 Shoes'),
              Tab(text: '💎 Acc.'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildItemGrid(FashionCategory.tops),
              _buildItemGrid(FashionCategory.bottoms),
              _buildItemGrid(FashionCategory.shoes),
              _buildItemGrid(FashionCategory.accessories),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemGrid(FashionCategory category) {
    final items = kClothingItems
        .where((item) => item.category == category)
        .toList();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = widget.currentLook[category]?.id == item.id;
        return GestureDetector(
          onTap: () => widget.onItemSelected(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  item.primaryColor,
                  item.accentColor ?? item.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : Border.all(color: Colors.transparent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: item.primaryColor.withOpacity(isSelected ? 0.6 : 0.3),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: _getTextColor(item.primaryColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTextColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.4 ? Colors.black87 : Colors.white;
  }
}

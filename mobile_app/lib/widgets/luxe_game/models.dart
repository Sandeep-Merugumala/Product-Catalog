import 'package:flutter/material.dart';

enum FashionCategory { tops, bottoms, shoes, accessories }

class ClothingItem {
  final String id;
  final String name;
  final Color primaryColor;
  final Color? accentColor;
  final IconData icon;
  final FashionCategory category;
  final int rarityScore; // 1-10
  final String emoji;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.primaryColor,
    this.accentColor,
    required this.icon,
    required this.category,
    required this.rarityScore,
    required this.emoji,
  });
}

const List<ClothingItem> kClothingItems = [
  // Tops
  ClothingItem(
    id: 't1',
    name: 'Silk Blouse',
    primaryColor: Color(0xFFF8BBD0),
    accentColor: Color(0xFFF48FB1),
    icon: Icons.checkroom,
    category: FashionCategory.tops,
    rarityScore: 8,
    emoji: '👚',
  ),
  ClothingItem(
    id: 't2',
    name: 'Black Turtleneck',
    primaryColor: Color(0xFF212121),
    accentColor: Color(0xFF424242),
    icon: Icons.checkroom,
    category: FashionCategory.tops,
    rarityScore: 9,
    emoji: '🖤',
  ),
  ClothingItem(
    id: 't3',
    name: 'Floral Crop Top',
    primaryColor: Color(0xFF80DEEA),
    accentColor: Color(0xFFE91E63),
    icon: Icons.checkroom,
    category: FashionCategory.tops,
    rarityScore: 7,
    emoji: '🌸',
  ),
  ClothingItem(
    id: 't4',
    name: 'Gold Sequin Top',
    primaryColor: Color(0xFFFFD54F),
    accentColor: Color(0xFFFF8F00),
    icon: Icons.checkroom,
    category: FashionCategory.tops,
    rarityScore: 10,
    emoji: '✨',
  ),

  // Bottoms
  ClothingItem(
    id: 'b1',
    name: 'Wide Leg Trousers',
    primaryColor: Color(0xFF546E7A),
    accentColor: Color(0xFF37474F),
    icon: Icons.layers,
    category: FashionCategory.bottoms,
    rarityScore: 9,
    emoji: '👖',
  ),
  ClothingItem(
    id: 'b2',
    name: 'Mini Skirt',
    primaryColor: Color(0xFFCE93D8),
    accentColor: Color(0xFFAB47BC),
    icon: Icons.layers,
    category: FashionCategory.bottoms,
    rarityScore: 7,
    emoji: '💜',
  ),
  ClothingItem(
    id: 'b3',
    name: 'Leather Pants',
    primaryColor: Color(0xFF3E2723),
    accentColor: Color(0xFF4E342E),
    icon: Icons.layers,
    category: FashionCategory.bottoms,
    rarityScore: 10,
    emoji: '🖤',
  ),
  ClothingItem(
    id: 'b4',
    name: 'Flared Jeans',
    primaryColor: Color(0xFF1565C0),
    accentColor: Color(0xFF0D47A1),
    icon: Icons.layers,
    category: FashionCategory.bottoms,
    rarityScore: 6,
    emoji: '💙',
  ),

  // Shoes
  ClothingItem(
    id: 's1',
    name: 'Stiletto Heels',
    primaryColor: Color(0xFFE53935),
    accentColor: Color(0xFFB71C1C),
    icon: Icons.roller_skating,
    category: FashionCategory.shoes,
    rarityScore: 10,
    emoji: '👠',
  ),
  ClothingItem(
    id: 's2',
    name: 'White Sneakers',
    primaryColor: Color(0xFFF5F5F5),
    accentColor: Color(0xFFBDBDBD),
    icon: Icons.roller_skating,
    category: FashionCategory.shoes,
    rarityScore: 7,
    emoji: '👟',
  ),
  ClothingItem(
    id: 's3',
    name: 'Ankle Boots',
    primaryColor: Color(0xFF4E342E),
    accentColor: Color(0xFF3E2723),
    icon: Icons.roller_skating,
    category: FashionCategory.shoes,
    rarityScore: 8,
    emoji: '👢',
  ),

  // Accessories
  ClothingItem(
    id: 'a1',
    name: 'Gold Necklace',
    primaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFFFA000),
    icon: Icons.diamond,
    category: FashionCategory.accessories,
    rarityScore: 8,
    emoji: '📿',
  ),
  ClothingItem(
    id: 'a2',
    name: 'Designer Bag',
    primaryColor: Color(0xFF8D6E63),
    accentColor: Color(0xFF6D4C41),
    icon: Icons.shopping_bag,
    category: FashionCategory.accessories,
    rarityScore: 9,
    emoji: '👜',
  ),
  ClothingItem(
    id: 'a3',
    name: 'Sunglasses',
    primaryColor: Color(0xFF212121),
    accentColor: Color(0xFF616161),
    icon: Icons.wb_sunny,
    category: FashionCategory.accessories,
    rarityScore: 7,
    emoji: '🕶️',
  ),
];

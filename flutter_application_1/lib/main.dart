import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/product_catalog/presentation/screens/home_screen.dart';

void main() => runApp(const CatalogApp());

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Premium Product Catalog',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/product_catalog/presentation/screens/home_screen.dart';
// Import the new screen
import 'features/product_catalog/presentation/screens/sports_catalog_screen.dart'; 

void main() => runApp(const CatalogApp());

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Premium Product Catalog',
      theme: AppTheme.lightTheme,
      // You can either keep HomeScreen or test the new screen immediately by changing this:
      home: const HomeScreen(), 
      // Option: Register the route for easier navigation
      routes: {
        '/sports': (context) => const SportsCatalogScreen(),
      },
    );
  }
}
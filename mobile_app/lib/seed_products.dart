import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final productsCollection = firestore.collection('products');

  print('Seeding seasonal products...');

  final List<Map<String, dynamic>> products = [
    // Winter Wear
    {
      'name': 'Premium Wool Trench Coat',
      'brand': 'Zara',
      'price': 4999,
      'originalPrice': 8999,
      'category': 'winter_wear',
      'image':
          'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description':
          'Stay warm and stylish with this premium wool trench coat.',
    },
    {
      'name': 'Chunky Knit Sweater',
      'brand': 'H&M',
      'price': 1999,
      'originalPrice': 3499,
      'category': 'winter_wear',
      'image':
          'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description': 'Cozy chunky knit sweater perfect for cold evenings.',
    },
    {
      'name': 'Thermal Puffer Jacket',
      'brand': 'North Face',
      'price': 6999,
      'originalPrice': 10500,
      'category': 'winter_wear',
      'image':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description': 'Lightweight yet incredibly warm thermal puffer jacket.',
    },
    {
      'name': 'Fleece Lined Parka',
      'brand': 'Marks & Spencer',
      'price': 5499,
      'originalPrice': 8999,
      'category': 'winter_wear',
      'image':
          'https://images.unsplash.com/photo-1544642899-f0d6e5f6ed6f?auto=format&fit=crop&q=80&w=800',
      'description':
          'Heavy-duty parka with soft fleece lining for extreme cold.',
    },

    // Wedding Season (Ethnic)
    {
      'name': 'Embroidered Silk Sherwani',
      'brand': 'Manyavar',
      'price': 14999,
      'originalPrice': 24999,
      'category': 'ethnic',
      'image':
          'https://images.unsplash.com/photo-1727835523545-70ee992b5763?w=500&auto=format',
      'description': 'Exquisite silk sherwani with detailed hand embroidery.',
    },
    {
      'name': 'Designer Lehenga Choli',
      'brand': 'Biba',
      'price': 18500,
      'originalPrice': 28500,
      'category': 'ethnic',
      'image':
          'https://images.pexels.com/photos/2592537/pexels-photo-2592537.jpeg?auto=compress&cs=tinysrgb&w=500',
      'description':
          'Stunning designer lehenga choli for the perfect bridal look.',
    },
    {
      'name': 'Festive Kurta Set',
      'brand': 'FabIndia',
      'price': 3499,
      'originalPrice': 5999,
      'category': 'ethnic',
      'image':
          'https://images.pexels.com/photos/3317429/pexels-photo-3317429.jpeg?auto=compress&cs=tinysrgb&w=500',
      'description': 'Comfortable and elegant kurta set for festive occasions.',
    },
    {
      'name': 'Banarasi Silk Saree',
      'brand': 'Nalli',
      'price': 12000,
      'originalPrice': 18000,
      'category': 'ethnic',
      'image':
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=500&auto=format&fit=crop',
      'description': 'Authentic Banarasi silk saree with zari border.',
    },
  ];

  for (var product in products) {
    await productsCollection.add(product);
  }

  print('✅ Seasonal products seeded successfully!');
}

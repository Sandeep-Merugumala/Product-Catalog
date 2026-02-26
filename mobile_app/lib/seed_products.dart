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
          'https://images.unsplash.com/photo-1544923408-55416040854c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
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
          'https://images.unsplash.com/photo-1595152452543-e5fc28ebc2fc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description': 'Exquisite silk sherwani with detailed hand embroidery.',
    },
    {
      'name': 'Designer Lehenga Choli',
      'brand': 'Biba',
      'price': 18500,
      'originalPrice': 28500,
      'category': 'ethnic',
      'image':
          'https://images.unsplash.com/photo-1583391733958-650fac5eb369?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
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
          'https://plus.unsplash.com/premium_photo-1682098616149-c18086202422?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description': 'Comfortable and elegant kurta set for festive occasions.',
    },
    {
      'name': 'Banarasi Silk Saree',
      'brand': 'Nalli',
      'price': 12000,
      'originalPrice': 18000,
      'category': 'ethnic',
      'image':
          'https://images.unsplash.com/photo-1610189014605-e3b97b1ca7ec?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0',
      'description': 'Authentic Banarasi silk saree with zari border.',
    },
  ];

  for (var product in products) {
    await productsCollection.add(product);
  }

  print('✅ Seasonal products seeded successfully!');
}

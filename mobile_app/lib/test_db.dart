import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  print('--- Checking Products in Firestore ---');
  final productsSnap = await firestore.collection('products').get();
  print('Total products: ${productsSnap.docs.length}');

  Set<String> categories = {};
  Set<String> brands = {};

  for (var doc in productsSnap.docs) {
    categories.add(doc.data()['category']?.toString() ?? 'none');
    brands.add(doc.data()['brand']?.toString() ?? 'none');
  }

  print('Available Categories: $categories');
  print('Available Brands: $brands');
}

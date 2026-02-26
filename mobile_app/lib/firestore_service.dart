import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_data.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Future<void> addNote(String text) {
    return notes.add({'text': text, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getNotes() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deleteNote(String id) {
    return notes.doc(id).delete();
  }

  // --- PRODUCTS ---
  final CollectionReference _products = FirebaseFirestore.instance.collection(
    'products',
  );

  // Cache for client-side search (since dataset is small ~64 items)
  List<Map<String, dynamic>>? _allProductsCache;

  // Search Products (Client-Side for better UX)
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    try {
      // 1. Fetch all products if not cached
      if (_allProductsCache == null) {
        final snapshot = await _products.get();
        _allProductsCache = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      }

      // 2. Filter locally (Case-insensitive, Substring match)
      final lowerQuery = query.toLowerCase().trim();

      return _allProductsCache!.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final brand = (product['brand'] ?? '').toString().toLowerCase();
        final category = (product['category'] ?? '').toString().toLowerCase();
        final gender = (product['gender'] ?? '').toString().toLowerCase();

        return name.contains(lowerQuery) ||
            brand.contains(lowerQuery) ||
            category.contains(lowerQuery) ||
            gender.contains(lowerQuery);
      }).toList();
    } catch (e) {
      debugPrint('Error searching products: $e');
      return [];
    }
  }

  // Get All Products (for migration/testing)
  Stream<QuerySnapshot> getAllProducts() {
    return _products.snapshots();
  }

  // Add All App Products (Migration)
  Future<void> seedAllProducts() async {
    debugPrint('🌱 Seeding all products...');
    for (var product in allAppProducts) {
      // Check if product with same ID exists to avoid duplicates
      // We use the 'id' field from our data as the document ID for consistency
      final docRef = _products.doc(product['id']);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set(product);
        debugPrint('✅ Added ${product['name']}');
      } else {
        // Optional: Update existing product if data changed
        // await docRef.update(product);
        debugPrint('⚠️ Skipped ${product['name']} (Exists)');
      }
    }
    debugPrint('🎉 Seeding complete!');
  }

  CollectionReference? get _cart {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    debugPrint('🛒 addToCart called with product: ${product['id']}');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('❌ Error: User not authenticated');
      throw Exception('User must be logged in to add items to cart');
    }

    debugPrint('✅ User authenticated: ${user.uid}');

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(product['id'].toString());

      final doc = await cartRef.get();

      if (doc.exists) {
        // Increment quantity if exists
        final currentQty = doc.data()?['quantity'] ?? 1;
        final stock = product['quantity'] ?? 9999;

        if (currentQty + 1 > stock) {
          throw Exception('Stock limit reached! Only $stock available.');
        }

        await cartRef.update({'quantity': currentQty + 1});
      } else {
        // Add new item with quantity 1
        final stock = product['quantity'] ?? 9999;
        if (1 > stock) {
          throw Exception('Product is out of stock!');
        }

        await cartRef.set({
          ...product,
          'addedAt': Timestamp.now(),
          'quantity': 1,
        });
      }
      debugPrint('✅ Item added to cart successfully');
    } catch (e) {
      debugPrint('❌ Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to place an order');
    }

    if (quantity < 1) {
      // Remove item if quantity is less than 1
      await removeFromCart(productId);
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
    }
  }

  Future<void> removeFromCart(String productId) {
    return _cart!.doc(productId).delete();
  }

  Stream<QuerySnapshot> getCartStream() {
    final cart = _cart;
    if (cart == null) return const Stream.empty();
    return cart.orderBy('addedAt', descending: true).snapshots();
  }

  // --- WISHLIST ---
  CollectionReference? get _wishlist {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wishlist');
  }

  Future<void> addToWishlist(Map<String, dynamic> product) async {
    debugPrint('❤️ addToWishlist called with product: ${product['id']}');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('❌ Error: User not authenticated');
      throw Exception('User must be logged in to add items to wishlist');
    }

    debugPrint('✅ User authenticated: ${user.uid}');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product['id'].toString())
          .set({...product, 'addedAt': Timestamp.now()});
      debugPrint('✅ Item added to wishlist successfully');
    } catch (e) {
      debugPrint('❌ Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) {
    return _wishlist!.doc(productId).delete();
  }

  Stream<QuerySnapshot> getWishlistStream() {
    final wishlist = _wishlist;
    if (wishlist == null) return const Stream.empty();
    return wishlist.orderBy('addedAt', descending: true).snapshots();
  }

  Future<void> placeOrder(
    double totalAmount,
    String paymentMethod,
    String address,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to place an order');
    }

    final cartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    try {
      // Get all cart items
      final cartSnapshot = await cartCollection.get();

      if (cartSnapshot.docs.isEmpty) return; // Nothing to order

      // Clear Cart and Create Order using batch
      final batch = FirebaseFirestore.instance.batch();

      // Save order details
      final orderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc();

      batch.set(orderRef, {
        'id': orderRef.id,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'address': address,
        'status': 'Processing',
        'createdAt': Timestamp.now(),
        'items': cartSnapshot.docs.map((doc) => doc.data()).toList(),
      });

      // Clear the cart
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint('✅ Order placed and cart cleared successfully');
    } catch (e) {
      debugPrint('❌ Error placing order: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No products found for $category.');
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('❌ Error fetching products by category: $e');
      return [];
    }
  }

  // --- ORDERS ---
  Stream<QuerySnapshot> getOrdersStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}

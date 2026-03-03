import 'package:flutter/foundation.dart';
// ignore_for_file: avoid_print
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
      // Use the 'id' field from our data as the document ID for consistency
      final docRef = _products.doc(product['id']);

      // Always set (overwrite/update) to ensure data consistency
      await docRef.set(product, SetOptions(merge: true));
      debugPrint('✅ Synced ${product['name']}');
    }
    debugPrint('🎉 Seeding complete!');
  }

  /// Deletes all products in specific seasonal categories to avoid duplicates
  /// with inconsistent IDs from previous seeding attempts.
  Future<void> deleteAllSeasonalProducts() async {
    debugPrint('🧹 Cleaning up seasonal products...');
    final categories = ['winter_wear', 'ethnic'];
    for (var cat in categories) {
      final snapshot = await _products.where('category', isEqualTo: cat).get();
      for (var doc in snapshot.docs) {
        // Only delete if it's NOT using our new ID pattern (e.g., if it's an auto-ID)
        // Auto-IDs are usually 20 characters long, while our IDs are like 'winter_001'
        if (doc.id.length > 15) {
          await doc.reference.delete();
          debugPrint('🗑️ Deleted legacy doc: ${doc.id}');
        }
      }
    }
    debugPrint('✨ Cleanup complete!');
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

      // Create notification
      final notificationRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc();

      final now = DateTime.now();
      final dateString = "${now.day}/${now.month}/${now.year}";

      batch.set(notificationRef, {
        'id': notificationRef.id,
        'title': 'Order Placed Successfully!',
        'body':
            'Your order of ₹${totalAmount.toStringAsFixed(0)} has been placed on $dateString.',
        'type': 'order',
        'isRead': false,
        'createdAt': Timestamp.now(),
        'orderId': orderRef.id,
      });

      // Clear the cart
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint(
        '✅ Order placed, notification added, and cart cleared successfully',
      );
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

  Future<List<Map<String, dynamic>>> getProductsByBrand(String brand) async {
    try {
      // Typically, direct where clauses in firestore are case-sensitive exact match.
      // Easiest is to fetch where brand matched via exact casing OR fetch and filter.
      // Assuming brands are stored capitalized (like "Nike", "Puma").
      // We will pull the whole collection or do a basic case-insensitive match locally if needed,
      // but since 'brand' field exists, let's start with a direct query. Because "adidas" vs "Adidas"
      // might occur, it's safer to fetch and do exact case-insensitive filter, OR query directly if stable.
      // Let's query by the exact name since we populated via product_data with proper casing.

      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      // Filter locally for case-insensitive brand match due to Firestore limitations
      final allProducts = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      return allProducts.where((p) {
        final productBrand = (p['brand'] ?? '').toString().toLowerCase();
        return productBrand == brand.toLowerCase();
      }).toList();
    } catch (e) {
      print('❌ Error fetching products by brand: $e');
      return [];
    }
  }

  // --- NOTIFICATIONS ---
  Stream<QuerySnapshot> getNotificationsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUnreadNotificationsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
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

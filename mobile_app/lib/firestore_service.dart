import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // --- CART ---
  CollectionReference get _cart => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('cart');

  Future<void> addToCart(Map<String, dynamic> product) async {
    print('🛒 addToCart called with product: ${product['id']}');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ Error: User not authenticated');
      throw Exception('User must be logged in to add items to cart');
    }

    print('✅ User authenticated: ${user.uid}');

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
        await cartRef.update({'quantity': currentQty + 1});
      } else {
        // Add new item with quantity 1
        await cartRef.set({
          ...product,
          'addedAt': Timestamp.now(),
          'quantity': 1,
        });
      }
      print('✅ Item added to cart successfully');
    } catch (e) {
      print('❌ Error adding to cart: $e');
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
    return _cart.doc(productId).delete();
  }

  Stream<QuerySnapshot> getCartStream() {
    return _cart.orderBy('addedAt', descending: true).snapshots();
  }

  // --- WISHLIST ---
  CollectionReference get _wishlist => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('wishlist');

  Future<void> addToWishlist(Map<String, dynamic> product) async {
    print('❤️ addToWishlist called with product: ${product['id']}');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ Error: User not authenticated');
      throw Exception('User must be logged in to add items to wishlist');
    }

    print('✅ User authenticated: ${user.uid}');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product['id'].toString())
          .set({...product, 'addedAt': Timestamp.now()});
      print('✅ Item added to wishlist successfully');
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) {
    return _wishlist.doc(productId).delete();
  }

  Stream<QuerySnapshot> getWishlistStream() {
    return _wishlist.orderBy('addedAt', descending: true).snapshots();
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

    final batch = FirebaseFirestore.instance.batch();
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final cartCollection = userDoc.collection('cart');
    final orderDoc = userDoc.collection('orders').doc();

    try {
      // Get all cart items
      final cartSnapshot = await cartCollection.get();
      final List<Map<String, dynamic>> items = cartSnapshot.docs.map((doc) {
        final data = doc.data();
        data['productId'] = doc.id; // Keep track of product ID
        return data;
      }).toList();

      if (items.isEmpty) return; // Nothing to order

      // Create Order
      batch.set(orderDoc, {
        'items': items,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'address': address,
        'status': 'Placed',
        'createdAt': FieldValue.serverTimestamp(),
        'orderId': orderDoc.id,
      });

      // Clear Cart
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('✅ Order placed successfully');
    } catch (e) {
      print('❌ Error placing order: $e');
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
}

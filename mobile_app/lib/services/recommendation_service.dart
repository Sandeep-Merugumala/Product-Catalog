import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum RecommendationType { home, productDetail, category, brand, orderBased }

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRecommendations({
    required RecommendationType type,
    String? categoryId,
    String? brandId,
    String? productId,
    int limit = 10,
  }) async {
    if (type == RecommendationType.orderBased) {
      return getOrderBasedRecommendations(limit: limit);
    }

    try {
      Query query = _firestore.collection('products');

      switch (type) {
        case RecommendationType.home:
          query = query.orderBy('createdAt', descending: true);
          break;
        case RecommendationType.productDetail:
          query = query.limit(limit);
          break;
        case RecommendationType.category:
          if (categoryId != null && categoryId.isNotEmpty) {
            query = query.where('category', isEqualTo: categoryId);
          }
          break;
        case RecommendationType.brand:
          if (brandId != null && brandId.isNotEmpty) {
            query = query.where('brand', isEqualTo: brandId);
          }
          break;
        case RecommendationType.orderBased:
          break;
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      if (type == RecommendationType.productDetail && productId != null) {
        products.removeWhere((p) => p['id'] == productId);
      }

      return products;
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
      return [];
    }
  }

  /// Reads user's past orders, determines top categories/brands, and
  /// returns matching products from the products collection.
  Future<List<Map<String, dynamic>>> getOrderBasedRecommendations({
    int limit = 12,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      debugPrint('🤖 [AI-Recs] uid=$uid');
      if (uid == null) return [];

      // --- Step 1: Read orders ---
      final ordersSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      debugPrint('🤖 [AI-Recs] ${ordersSnap.docs.length} orders found');
      if (ordersSnap.docs.isEmpty) return [];

      // --- Step 2: Tally categories & brands from items ---
      final Map<String, int> categoryCounts = {};
      final Map<String, int> brandCounts = {};

      for (final orderDoc in ordersSnap.docs) {
        final data = orderDoc.data();
        final items = data['items'] as List<dynamic>? ?? [];
        debugPrint('🤖 [AI-Recs] order ${orderDoc.id}: ${items.length} items');

        for (final item in items) {
          // Items are cart documents containing all product fields
          final cat = (item['category'] ?? '').toString().trim();
          final brand = (item['brand'] ?? '').toString().trim();
          debugPrint('🤖 [AI-Recs]   -> cat="$cat" brand="$brand"');
          if (cat.isNotEmpty) {
            categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
          }
          if (brand.isNotEmpty) {
            brandCounts[brand] = (brandCounts[brand] ?? 0) + 1;
          }
        }
      }

      debugPrint('🤖 [AI-Recs] categoryCounts=$categoryCounts');
      debugPrint('🤖 [AI-Recs] brandCounts=$brandCounts');

      if (categoryCounts.isEmpty && brandCounts.isEmpty) {
        debugPrint(
          '🤖 [AI-Recs] No categories/brands found in items - returning []',
        );
        return [];
      }

      // --- Step 3: Pick top 2 categories and top 1 brand ---
      final topCategories =
          (categoryCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(2)
              .map((e) => e.key)
              .toList();

      final topBrand =
          (brandCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .map((e) => e.key)
              .firstOrNull;

      debugPrint(
        '🤖 [AI-Recs] topCategories=$topCategories topBrand=$topBrand',
      );

      // --- Step 4: Query matching products ---
      final Set<String> seenIds = {};
      final List<Map<String, dynamic>> recommendations = [];

      // Create case variations for Firestore querying since it's case-sensitive
      List<String> generateCaseVariations(String text) {
        if (text.isEmpty) return [];
        final lower = text.toLowerCase();
        final upper = text.toUpperCase();
        final title =
            '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
        return [lower, upper, title, text];
      }

      if (topCategories.isNotEmpty) {
        // Expand categories to include common cases
        List<String> expandedCategories = [];
        for (final cat in topCategories) {
          expandedCategories.addAll(generateCaseVariations(cat));
        }

        // Firestore whereIn supports up to 10 items.
        if (expandedCategories.length > 10) {
          expandedCategories = expandedCategories.take(10).toList();
        }

        final catSnap = await _firestore
            .collection('products')
            .where('category', whereIn: expandedCategories)
            .limit(limit)
            .get();

        debugPrint(
          '🤖 [AI-Recs] category query -> ${catSnap.docs.length} products',
        );
        for (final doc in catSnap.docs) {
          if (!seenIds.contains(doc.id)) {
            // Also verify loosely in Dart to be safe
            final docCat = (doc.data()['category']?.toString() ?? '')
                .toLowerCase();
            if (topCategories.any((tc) => tc.toLowerCase() == docCat)) {
              seenIds.add(doc.id);
              final d = doc.data();
              d['id'] = doc.id;
              d['_recommendReason'] =
                  'More ${topCategories.first} you\'ll love';
              recommendations.add(d);
            }
          }
        }
      }

      if (topBrand != null && recommendations.length < limit) {
        final expandedBrands = generateCaseVariations(topBrand);

        final brandSnap = await _firestore
            .collection('products')
            .where('brand', whereIn: expandedBrands.take(10).toList())
            .limit(limit)
            .get();

        debugPrint(
          '🤖 [AI-Recs] brand query -> ${brandSnap.docs.length} products',
        );
        for (final doc in brandSnap.docs) {
          if (!seenIds.contains(doc.id)) {
            final docBrand = (doc.data()['brand']?.toString() ?? '')
                .toLowerCase();
            if (docBrand == topBrand.toLowerCase()) {
              seenIds.add(doc.id);
              final d = doc.data();
              d['id'] = doc.id;
              d['_recommendReason'] = 'More from $topBrand';
              recommendations.add(d);
            }
          }
          if (recommendations.length >= limit) break;
        }
      }

      debugPrint('🤖 [AI-Recs] FINAL count: ${recommendations.length}');

      if (recommendations.isEmpty) {
        return [
          {
            'id': 'debug_info',
            'name': 'DEBUG INFO',
            'brand': 'DEBUG',
            'description':
                'Cats: $categoryCounts | Brands: $brandCounts | TopC: $topCategories | TopB: $topBrand',
            'price': 0,
            'originalPrice': 0,
            'discount': 0,
            'rating': 5.0,
            '_recommendReason': 'Debugging Info (Temporary)',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/e/e0/Placeholder_LC.png',
          },
        ];
      }

      return recommendations;
    } catch (e, stack) {
      debugPrint('❌ [AI-Recs] Error: $e\n$stack');
      return [];
    }
  }
}

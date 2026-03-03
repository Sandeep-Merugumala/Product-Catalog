import 'package:cloud_firestore/cloud_firestore.dart';

enum RecommendationType {
  home, // Personalized general recommendations
  productDetail, // Similar items to a specific product
  category, // Recommendations confined to a category
  brand, // Recommendations confined to a brand
}

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generalized method to get recommendations based on context
  Future<List<Map<String, dynamic>>> getRecommendations({
    required RecommendationType type,
    String? categoryId,
    String? brandId,
    String? productId,
    int limit = 10,
  }) async {
    try {
      Query query = _firestore.collection('products');

      // AI Logic Simulation using Firestore filters
      switch (type) {
        case RecommendationType.home:
          // For home, normally you'd use a personalized backend API.
          // Using random/recent items as a placeholder simulation
          query = query.orderBy('createdAt', descending: true);
          break;

        case RecommendationType.productDetail:
          // Simulate "Similar Products" by finding items with same category/tags
          // Wait, we don't know the exact category without a backend lookup,
          // let's fetch generic items or items matching a specific subset if we had metadata.
          // For now, sorting differently to fetch alternatives
          query = query.limit(limit);
          break;

        case RecommendationType.category:
          if (categoryId != null && categoryId.isNotEmpty) {
            query = query.where(
              'category',
              isEqualTo: categoryId.toLowerCase(),
            );
          }
          break;

        case RecommendationType.brand:
          if (brandId != null && brandId.isNotEmpty) {
            query = query.where('brand', isEqualTo: brandId);
          }
          break;
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Ensure we don't recommend the exact product itself in productDetail view
      if (type == RecommendationType.productDetail && productId != null) {
        products.removeWhere((p) => p['id'] == productId);
      }

      return products;
    } catch (e) {
      print('Error fetching recommendations: $e');
      return [];
    }
  }
}

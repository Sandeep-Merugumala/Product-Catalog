import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/ai_recommendation_carousel.dart';
import 'package:mobile_app/services/recommendation_service.dart';

class AiRecommendationsScreen extends StatelessWidget {
  const AiRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFFF3F6C)),
                  SizedBox(width: 8),
                  Text(
                    'Powered by AI Engine',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const AIRecommendationCarousel(
              type: RecommendationType.home,
              title: "Discover For You",
            ),
            const AIRecommendationCarousel(
              type: RecommendationType.category,
              categoryId: "fashion",
              title: "Trending in Fashion",
            ),
            const AIRecommendationCarousel(
              type: RecommendationType.brand,
              brandId: "HRX",
              title: "Top Picks from HRX",
            ),
          ],
        ),
      ),
    );
  }
}

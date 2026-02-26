import 'package:flutter/material.dart';
import 'models.dart';

class ScoreScreen extends StatelessWidget {
  final int totalScore; // Raw score (max 40)
  final Map<FashionCategory, ClothingItem?> currentLook;
  final VoidCallback onRetry;

  const ScoreScreen({
    super.key,
    required this.totalScore,
    required this.currentLook,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (totalScore / 40 * 100).clamp(0, 100).toInt();

    String ratingTitle;
    String ratingSubtitle;
    String ratingEmoji;
    Color ratingColor;
    List<Color> gradientColors;

    if (percentage >= 90) {
      ratingTitle = "Fashion Icon!";
      ratingSubtitle = "You're a style legend. The runway is yours!";
      ratingEmoji = "👑";
      ratingColor = const Color(0xFFFFD700);
      gradientColors = [const Color(0xFFFFD700), const Color(0xFFFF8F00)];
    } else if (percentage >= 75) {
      ratingTitle = "Trendsetter";
      ratingSubtitle = "You've got an eye for style!";
      ratingEmoji = "💅";
      ratingColor = const Color(0xFFE91E63);
      gradientColors = [const Color(0xFFE91E63), const Color(0xFF9C27B0)];
    } else if (percentage >= 50) {
      ratingTitle = "Style Savvy";
      ratingSubtitle = "Not bad! Keep experimenting.";
      ratingEmoji = "✨";
      ratingColor = const Color(0xFF2196F3);
      gradientColors = [const Color(0xFF2196F3), const Color(0xFF00BCD4)];
    } else {
      ratingTitle = "Aspiring Stylist";
      ratingSubtitle = "Everyone starts somewhere. Try again!";
      ratingEmoji = "🌱";
      ratingColor = const Color(0xFF4CAF50);
      gradientColors = [const Color(0xFF4CAF50), const Color(0xFF8BC34A)];
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: ratingColor.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Text(ratingEmoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 6),
                    Text(
                      ratingTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ratingSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Score display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$percentage',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: ratingColor,
                          ),
                        ),
                        const Text(
                          '/100',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ],
                    ),

                    // Star rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final filled = i < (percentage / 20).round();
                        return Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: ratingColor,
                          size: 28,
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Selected items summary
                    ...FashionCategory.values.map((cat) {
                      final item = currentLook[cat];
                      if (item == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              item.emoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                item.rarityScore,
                                (i) => const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            Text(
                              ' ${item.rarityScore}/10',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onRetry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ratingColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          '🔄 Style Again',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

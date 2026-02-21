import 'package:flutter/material.dart';
import 'models.dart';
import 'model_display.dart';
import 'wardrobe_selector.dart';
import 'score_screen.dart';

class LuxeGameEngine extends StatefulWidget {
  const LuxeGameEngine({super.key});

  @override
  State<LuxeGameEngine> createState() => _LuxeGameEngineState();
}

class _LuxeGameEngineState extends State<LuxeGameEngine> {
  final Map<FashionCategory, ClothingItem?> _currentLook = {
    FashionCategory.tops: null,
    FashionCategory.bottoms: null,
    FashionCategory.shoes: null,
    FashionCategory.accessories: null,
  };

  bool _isGameOver = false;

  void _onItemSelected(ClothingItem item) {
    setState(() {
      _currentLook[item.category] = item;
    });
  }

  void _finishStyling() {
    setState(() {
      _isGameOver = true;
    });
  }

  void _resetGame() {
    setState(() {
      _currentLook.updateAll((key, value) => null);
      _isGameOver = false;
    });
  }

  int _calculateScore() {
    int total = 0;
    _currentLook.forEach((key, value) {
      if (value != null) total += value.rarityScore;
    });
    return total;
  }

  int get _itemsSelected => _currentLook.values.where((v) => v != null).length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Look Progress:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _itemsSelected / 4.0,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.black87,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_itemsSelected/4',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Avatar Display
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AvatarDisplay(currentLook: _currentLook),
              ),
            ),

            // Wardrobe Selector
            Expanded(
              flex: 4,
              child: WardrobeSelector(
                onItemSelected: _onItemSelected,
                currentLook: _currentLook,
              ),
            ),

            // Finish Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _itemsSelected > 0 ? _finishStyling : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _itemsSelected == 4
                            ? 'REVEAL FASHION SCORE ✨'
                            : 'FINISH LOOK ($_itemsSelected/4)',
                        style: TextStyle(
                          color: _itemsSelected > 0
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Score Overlay
        if (_isGameOver)
          Container(
            color: Colors.black.withValues(alpha: 0.65),
            child: ScoreScreen(
              totalScore: _calculateScore(),
              currentLook: _currentLook,
              onRetry: _resetGame,
            ),
          ),
      ],
    );
  }
}

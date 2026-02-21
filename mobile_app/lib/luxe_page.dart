import 'package:flutter/material.dart';
import 'widgets/luxe_game/game_engine.dart'; // Import the game engine

class LuxePage extends StatelessWidget {
  const LuxePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Luxe Studio',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show instructions
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("How to Play"),
                  content: const Text(
                    "Select items from the wardrobe below to style your model. Try to match items to get the highest Fashion Score!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Got it"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const LuxeGameEngine(),
    );
  }
}

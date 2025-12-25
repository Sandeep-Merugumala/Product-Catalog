import 'package:flutter/material.dart';

class SkeletonProductCard extends StatefulWidget {
  const SkeletonProductCard({super.key});

  @override
  State<SkeletonProductCard> createState() => _SkeletonProductCardState();
}

class _SkeletonProductCardState extends State<SkeletonProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildShimmer(double height,
      {double? width, double borderRadius = 8}) {
    return ShimmerBox(
      height: height,
      width: width,
      borderRadius: borderRadius,
      animation: _animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _buildShimmer(double.infinity, borderRadius: 20),
            ),
          ),
          // Content placeholders
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand placeholder
                      _buildShimmer(10, width: 60),
                      const SizedBox(height: 8),
                      // Title placeholder
                      _buildShimmer(14, width: double.infinity),
                      const SizedBox(height: 10),
                      // Price placeholder
                      _buildShimmer(16, width: 80),
                    ],
                  ),
                  // Button placeholder
                  _buildShimmer(32, borderRadius: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for linear gradient rotation
  // Note: Flutter's GradientRotation expects radians, but simple offset shift works better for standard shimmer
  // Implementing a custom shader mask approach or just moving separate gradient stops is complex
  // Simplified approach: Mapping animation value to Alignment could be cleaner
}

// Since GradientRotation might not be ideal for linear shimmer without a shader,
// let's use a simpler LinearGradient alignment interpolation for a smoother effect
// by overriding the builder slightly.

class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final Animation<double> animation;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Calculate gradient alignment based on animation value (-1.0 to 2.0)
        // We want the highlight to move from left to right
        final double start = animation.value;
        final double end = start + 1.5;

        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
                begin: Alignment(start, 0),
                end: Alignment(end, 0),
                colors: [
                  Colors.grey.shade200, // Background color
                  Colors.grey.shade100, // Highlight color (lighter)
                  Colors.grey.shade200, // Background color
                ],
                stops: const [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
        );
      },
    );
  }
}

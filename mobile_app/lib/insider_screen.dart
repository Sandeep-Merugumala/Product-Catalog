import 'package:flutter/material.dart';

class InsiderScreen extends StatelessWidget {
  const InsiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MYNTRA INSIDER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark Header Section
            Container(
              color: const Color(0xFF16151A), // Very dark slate/black
              width: double.infinity,
              child: Stack(
                children: [
                  // Decorative background lines (simulated with an icon for now, would ideally be an SVG or CustomPainter)
                  Positioned(
                    right: -50,
                    top: 50,
                    child: Icon(
                      Icons.waves,
                      color: Colors.amber.withValues(alpha: 0.1),
                      size: 300,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Welcome Sandeep!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Insider Logo/Text
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              color: Color(0xFFD4AF37),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'INSIDER',
                              style: TextStyle(
                                color: const Color(0xFFD4AF37), // Gold color
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'SELECT MEMBER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'Member since July, 2024',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 40),

                        // Action Buttons Layer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildDarkActionButton(
                              Icons.card_giftcard,
                              '20',
                              'Available Rewards',
                            ),
                            _buildDarkActionButton(
                              Icons.payments_outlined,
                              '₹515',
                              'Your Savings',
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Progress Bar Area
                        _buildProgressBar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Upgrade Prompt Banner
            Container(
              width: double.infinity,
              color: const Color(0xFFB89151), // Mustard/Gold
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Shop for ₹10000 before 11th Jul, 2026 to upgrade your benefits. Shop Now!',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Spotlight Section
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color(0xFFD4AF37),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Spotlight',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2C3240),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color(0xFFD4AF37),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Banner Carousel
                SizedBox(
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildPromoBanner(),
                      const SizedBox(width: 16),
                      _buildPromoBanner(
                        color: const Color(0xFFE1BEE7),
                      ), // A different colored mockup
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pagination Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Trending Now (Placeholder based on bottom of mockup)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 1, width: 40, color: Colors.grey.shade300),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Trending Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2C3240),
                    ),
                  ),
                ),
                Container(height: 1, width: 40, color: Colors.grey.shade300),
              ],
            ),
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildDarkActionButton(IconData icon, String value, String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF232228), // Slightly lighter than background
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFD4AF37), size: 18),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.white54, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track
            Container(height: 4, width: double.infinity, color: Colors.white24),
            // Progress
            Container(
              height: 4,
              width: 40, // Small amount of horizontal progress
              color: const Color(0xFFD4AF37),
            ),
            // Nodes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 4),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SELECT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Column(
              children: const [
                Text(
                  'ELITE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '₹10000',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Column(
              children: const [
                Text(
                  'ICON',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '₹35000',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoBanner({Color color = const Color(0xFFFFD54F)}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Simulated content for the banner
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.stars, color: Colors.pinkAccent, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'INSIDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'EXTRA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text(
                  '10% OFF',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const Text('On Home & Living', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Text(
                    'Use Code: INSIDERHOME',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Shop Now',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.play_circle_filled, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Placeholder for the image portion of the banner on the right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 140,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                color: Colors.white.withValues(alpha: 0.3),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.black26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

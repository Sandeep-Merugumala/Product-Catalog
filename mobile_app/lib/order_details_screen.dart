import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Basic extraction from the passed order details
    final items = order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;
    final status = order['status'] ?? 'Delivered';
    // Moco date for delivery matching the image
    final deliveredDate = 'Thu, 6 Feb';
    final returnDate = 'Thu, 20 Feb 2025';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.support_agent, color: Colors.black54, size: 18),
                  SizedBox(width: 4),
                  Text('Help', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Header Area
            Container(
              color: const Color(
                0xFFF5F5F5,
              ), // Keeping it matching the background for seamless look
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  if (firstItem != null && firstItem['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        firstItem['image'],
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: 140,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 60),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, size: 60),
                    ),

                  const SizedBox(height: 16),

                  Text(
                    firstItem?['brand'] ?? 'WROGN', // Mock brand if missing
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Color(0xFF2C3240),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstItem?['name'] ??
                        firstItem?['description'] ??
                        'Men Maroon Slim Fit Solid Casual Shirt',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${firstItem?['size'] ?? '39'}', // Mock size if missing
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Delivery Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A980), // Emerald green
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'On $deliveredDate',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Return Policy
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exchange/Return window closed on $returnDate',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Rating Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (firstItem != null && firstItem['image'] != null)
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(firstItem['image']),
                      backgroundColor: Colors.grey.shade200,
                    )
                  else
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person),
                    ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate this product',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2C3240),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Items that go well with this item
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Items that go well with this item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2C3240),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildSuggestedItemCard(
                          'assets/pants.jpg',
                        ), // Placeholder images
                        _buildSuggestedItemCard('assets/dhoti.jpg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Padding at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedItemCard(String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 40),
      ), // Placeholder for image
    );
  }
}

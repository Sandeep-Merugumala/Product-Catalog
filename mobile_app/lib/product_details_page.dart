import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/firestore_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isAddingToCart = false;

  int get _quantity =>
      widget.product['quantity'] ?? 50; // Default to 50 if missing
  bool get _isOutOfStock => _quantity <= 0;

  Future<void> _addToCart() async {
    if (_isOutOfStock) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      await _firestoreService.addToCart(widget.product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to Bag Successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product['brand'] ?? 'Product',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 90,
            ), // Spacing for bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.network(
                    widget.product['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback for broken seasonal images
                      final name = widget.product['name'] ?? '';
                      String fallback =
                          'https://images.unsplash.com/photo-1544642899-f0d6e5f6ed6f?auto=format&fit=crop&q=80&w=800';

                      if (name.contains('Sherwani')) {
                        fallback =
                            'https://images.unsplash.com/photo-1727835523545-70ee992b5763?w=500&auto=format';
                      } else if (name.contains('Lehenga')) {
                        fallback =
                            'https://images.pexels.com/photos/2592537/pexels-photo-2592537.jpeg?auto=compress&cs=tinysrgb&w=500';
                      } else if (name.contains('Kurta')) {
                        fallback =
                            'https://images.pexels.com/photos/3317429/pexels-photo-3317429.jpeg?auto=compress&cs=tinysrgb&w=500';
                      } else if (name.contains('Saree')) {
                        fallback =
                            'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=500&auto=format&fit=crop';
                      }

                      return Image.network(fallback, fit: BoxFit.cover);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Name
                      Text(
                        widget.product['brand'] ?? 'Brand Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Product Name
                      Text(
                        widget.product['name'] ??
                            widget.product['title'] ??
                            'Product Title',
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${widget.product['rating'] ?? 4.5}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '|   ${widget.product['reviewCount'] ?? widget.product['ratingCount'] ?? '2400'} Ratings',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${widget.product['price'] ?? 0}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              'MRP ₹${widget.product['originalPrice'] ?? ((widget.product['price'] ?? 0) * 1.5).round()}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              widget.product['discount'] is int
                                  ? '${widget.product['discount']}% OFF'
                                  : (widget.product['discount'] ?? '45% OFF')
                                        .toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFF3F6C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'inclusive of all taxes',
                        style: TextStyle(
                          color: Color(0xFF2E7D32), // Darker green
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stock Status
                      if (_isOutOfStock)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Currently Unavailable',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_quantity > 0 && _quantity < 5)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Hurry, only $_quantity left!',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      // Description
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product['description'] ??
                            'Classic Air Max cushioning for all-day comfort.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar Elements overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Wishlist Button
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseAuth.instance.currentUser != null
                          ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('wishlist')
                                .doc(widget.product['id'].toString())
                                .snapshots()
                          : null,
                      builder: (context, snapshot) {
                        bool isWishlisted = false;
                        if (snapshot.hasData && snapshot.data!.exists) {
                          isWishlisted = true;
                        }
                        return OutlinedButton.icon(
                          onPressed: () async {
                            if (FirebaseAuth.instance.currentUser == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please login first'),
                                ),
                              );
                              return;
                            }
                            if (isWishlisted) {
                              await _firestoreService.removeFromWishlist(
                                widget.product['id'].toString(),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from Wishlist'),
                                  ),
                                );
                              }
                            } else {
                              await _firestoreService.addToWishlist(
                                widget.product,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to Wishlist'),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted
                                ? const Color(0xFFFF3F6C)
                                : Colors.black87,
                            size: 20,
                          ),
                          label: Text(
                            isWishlisted ? 'WISHLISTED' : 'WISHLIST',
                            style: TextStyle(
                              color: isWishlisted
                                  ? const Color(0xFFFF3F6C)
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(
                              color: isWishlisted
                                  ? const Color(0xFFFF3F6C)
                                  : Colors.grey[400]!,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to Bag Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isOutOfStock || _isAddingToCart
                          ? null
                          : _addToCart,
                      icon: _isAddingToCart
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.shopping_bag_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                      label: Text(
                        _isOutOfStock ? 'OUT OF STOCK' : 'ADD TO CART',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isOutOfStock
                            ? Colors.grey
                            : const Color(0xFFFF3F6C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60), // Above the bottom bar
        child: FloatingActionButton(
          onPressed: () {
            // Chat action
          },
          backgroundColor: const Color(0xFFFF3F6C),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

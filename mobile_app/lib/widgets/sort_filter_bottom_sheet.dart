// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

enum SortOption { relevance, priceLowToHigh, priceHighToLow, rating }

class SortFilterBottomSheet extends StatefulWidget {
  final SortOption initialSort;
  final int initialDiscountFilter; // e.g., 0, 10, 30, 50

  const SortFilterBottomSheet({
    super.key,
    required this.initialSort,
    required this.initialDiscountFilter,
  });

  @override
  State<SortFilterBottomSheet> createState() => _SortFilterBottomSheetState();
}

class _SortFilterBottomSheetState extends State<SortFilterBottomSheet> {
  late SortOption _selectedSort;
  late int _selectedDiscount;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
    _selectedDiscount = widget.initialDiscountFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort & Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SORT BY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSortRadio(SortOption.relevance, 'Relevance'),
                  _buildSortRadio(
                    SortOption.priceLowToHigh,
                    'Price: Low to High',
                  ),
                  _buildSortRadio(
                    SortOption.priceHighToLow,
                    'Price: High to Low',
                  ),
                  _buildSortRadio(SortOption.rating, 'Customer Rating'),

                  const SizedBox(height: 24),

                  const Text(
                    'FILTER BY DISCOUNT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDiscountRadio(0, 'All Products'),
                  _buildDiscountRadio(10, '10% and above'),
                  _buildDiscountRadio(30, '30% and above'),
                  _buildDiscountRadio(50, '50% and above'),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSort = SortOption.relevance;
                        _selectedDiscount = 0;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'CLEAR ALL',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'sort': _selectedSort,
                        'discount': _selectedDiscount,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFFF3F6C,
                      ), // Myntra pinkish-red
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'APPLY',
                      style: TextStyle(
                        color: Colors.white,
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
    );
  }

  Widget _buildSortRadio(SortOption value, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<SortOption>(
        value: value,
        groupValue: _selectedSort,
        activeColor: const Color(0xFFFF3F6C),
        onChanged: (SortOption? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedSort = newValue;
            });
          }
        },
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: () {
        setState(() {
          _selectedSort = value;
        });
      },
    );
  }

  Widget _buildDiscountRadio(int discount, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<int>(
        value: discount,
        groupValue: _selectedDiscount,
        activeColor: const Color(0xFFFF3F6C),
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedDiscount = newValue;
            });
          }
        },
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: () {
        setState(() {
          _selectedDiscount = discount;
        });
      },
    );
  }
}

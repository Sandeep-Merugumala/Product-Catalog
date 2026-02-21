import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aura/firestore_service.dart';
import 'package:aura/product_details_page.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final FirestoreService _firestoreService = FirestoreService();

  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Delay removal to allow onTap to fire first
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!_focusNode.hasFocus) {
            _removeOverlay();
          }
        });
      } else if (_controller.text.isNotEmpty) {
        _showOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      _removeOverlay();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isLoading = true);

      final results = await _firestoreService.searchProducts(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
        _showOverlay();
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();

    // Don't show if no results and not loading, or if empty query
    if (_controller.text.isEmpty) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _buildOverlayContent(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  Widget _buildOverlayContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No products found"),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (ctx, index) {
        // Using ctx to avoid shadowing 'context'
        final product = _searchResults[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: NetworkImage(product['image'] ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            product['name'] ?? 'Unknown',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            product['brand'] ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          onTap: () {
            // Use the widget's context to find the navigator
            final nav = Navigator.of(context);

            _removeOverlay();
            _focusNode.unfocus();
            _controller.clear();

            nav.push(
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ),
            );
          },
        );
      },
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search for brands & products',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            isDense: true,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      _controller.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 14),
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}

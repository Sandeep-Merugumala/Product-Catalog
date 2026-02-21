import 'package:flutter/material.dart';
import 'package:aura/firestore_service.dart';
import 'package:aura/address_management.dart';
import 'home_screen.dart';
import 'package:lottie/lottie.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;

  const CheckoutPage({super.key, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AddressService _addressService = AddressService();
  String _paymentMethod = 'Cash on Delivery';
  bool _isLoading = false;
  Address? _selectedAddress;
  bool _loadingAddress = true;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final addresses = await _addressService.getAddresses().first;
      if (mounted) {
        setState(() {
          // Pick default address, or first if none are default
          _selectedAddress = addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addresses.isNotEmpty
                ? addresses.first
                : Address(
                    id: '',
                    name: '',
                    street: '',
                    city: '',
                    state: '',
                    zip: '',
                    mobile: '',
                  ),
          );
          _loadingAddress = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  Future<void> _showAddressPicker() async {
    final addresses = await _addressService.getAddresses().first;
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'SELECT DELIVERY ADDRESS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const Divider(height: 1),
            if (addresses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No saved addresses. Please add one from Profile.'),
              )
            else
              ...addresses.map(
                (addr) => ListTile(
                  leading: Icon(
                    addr.type == 'HOME'
                        ? Icons.home_outlined
                        : Icons.work_outline,
                    color: _selectedAddress?.id == addr.id
                        ? const Color(0xFFFF3F6C)
                        : Colors.grey,
                  ),
                  title: Text(
                    addr.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${addr.street}, ${addr.city} - ${addr.zip}\n${addr.state} | ${addr.mobile}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: _selectedAddress?.id == addr.id
                      ? const Icon(Icons.check_circle, color: Color(0xFFFF3F6C))
                      : null,
                  onTap: () {
                    setState(() => _selectedAddress = addr);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firestoreService.placeOrder(
        widget.totalAmount,
        _paymentMethod,
        _selectedAddress != null
            ? '${_selectedAddress!.street}, ${_selectedAddress!.city} - ${_selectedAddress!.zip}, ${_selectedAddress!.state}'
            : 'No address selected',
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              totalAmount: widget.totalAmount,
              paymentMethod: _paymentMethod,
              address: _selectedAddress != null
                  ? '${_selectedAddress!.street}, ${_selectedAddress!.city} - ${_selectedAddress!.zip}, ${_selectedAddress!.state}'
                  : '',
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            const Text(
              'DELIVERY ADDRESS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _loadingAddress
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child:
                                  _selectedAddress == null ||
                                      _selectedAddress!.name.isEmpty
                                  ? const Text(
                                      'No address saved. Please add one from Profile.',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _selectedAddress!.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                _selectedAddress!.type,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_selectedAddress!.street}\n${_selectedAddress!.city} - ${_selectedAddress!.zip}\n${_selectedAddress!.state}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Mobile: ${_selectedAddress!.mobile}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _showAddressPicker,
                            child: const Text(
                              'CHANGE',
                              style: TextStyle(
                                color: Color(0xFFFF3F6C),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            // Payment Options
            const Text(
              'PAYMENT OPTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'Cash on Delivery',
                    // ignore: deprecated_member_use
                    groupValue: _paymentMethod,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    title: const Text('Cash on Delivery (Cash/UPI)'),
                    activeColor: const Color(0xFFFF3F6C),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'Online Payment',
                    // ignore: deprecated_member_use
                    groupValue: _paymentMethod,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    title: const Text('Credit/Debit Card / Netbanking'),
                    subtitle: const Text('Coming soon'),
                    activeColor: const Color(0xFFFF3F6C),
                    // enabled: false, // For now enabling it as a mock
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Summary
            const Text(
              'PRICE DETAILS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount'),
                      Text(
                        '₹${widget.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3F6C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: const Color(
                0xFFFF3F6C,
              ).withValues(alpha: 0.5),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'PLACE ORDER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Order Success Page
// ─────────────────────────────────────────────
class OrderSuccessPage extends StatelessWidget {
  final double totalAmount;
  final String paymentMethod;
  final String address;

  const OrderSuccessPage({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation
              Lottie.network(
                'https://assets1.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                width: 220,
                height: 220,
                repeat: false,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.check_circle_outline,
                  size: 120,
                  color: Color(0xFFFF3F6C),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed! 🎉',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Thank you for shopping with us!\nYour order is confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Order details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow('Amount', '₹${totalAmount.toStringAsFixed(0)}'),
                    const Divider(height: 20),
                    _detailRow('Payment', paymentMethod),
                    const Divider(height: 20),
                    _detailRow('Delivery to', address, maxLines: 2),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3F6C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class InsiderScreen extends StatefulWidget {
  const InsiderScreen({super.key});

  @override
  State<InsiderScreen> createState() => _InsiderScreenState();
}

class _InsiderScreenState extends State<InsiderScreen> {
  bool _isSubscribed = false;

  void _showPaymentPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentBottomSheet(
        onPayClicked: () {
          // Close the bottom sheet first
          Navigator.pop(context);
          // Show the processing dialog in the center
          _showProcessingDialog(context);
        },
      ),
    );
  }

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PaymentProcessingDialog(
        onSuccess: () {
          setState(() {
            _isSubscribed = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'INSIDER PRIME',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF16151A),
        foregroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark Header Section
            Container(
              color: const Color(0xFF16151A),
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        color: Color(0xFFD4AF37),
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'INSIDER PRIME',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isSubscribed
                        ? 'Welcome to the club! You are now an Insider Prime member.'
                        : 'Join the ultimate fashion club. Get benefits like never before.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_isSubscribed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFFB89151)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '₹999 / year',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cancel anytime',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => _showPaymentPopup(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: const Color(0xFFD4AF37),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'SUBSCRIBE NOW',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isSubscribed)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232228),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFD4AF37),
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Active Subscription',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Valid until Mar 2027',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exclusive Benefits',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3240),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildBenefitItem(
                    Icons.local_shipping_outlined,
                    'Free Shipping',
                    'On all orders with no minimum spend.',
                  ),
                  _buildBenefitItem(
                    Icons.access_time_outlined,
                    'Early Access',
                    'Shop the sales before anyone else.',
                  ),
                  _buildBenefitItem(
                    Icons.local_offer_outlined,
                    'Extra 10% Off',
                    'On selected premium brands.',
                  ),
                  _buildBenefitItem(
                    Icons.support_agent_outlined,
                    'Priority Support',
                    '24/7 dedicated customer service.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), // Light amber
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFFD4AF37), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3240),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBottomSheet extends StatelessWidget {
  final VoidCallback onPayClicked;

  const _PaymentBottomSheet({required this.onPayClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Complete Payment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3240),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '₹999 will be charged to your selected method',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 28),
            _buildPaymentOption(Icons.credit_card, 'Credit / Debit Card', true),
            _buildPaymentOption(
              Icons.account_balance,
              'UPI / Netbanking',
              false,
            ),
            _buildPaymentOption(Icons.account_balance_wallet, 'Wallets', false),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPayClicked,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'PAY ₹999',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? const Color(0xFFFFF8E1) : Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade600,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.radio_button_checked, color: Color(0xFFD4AF37))
          else
            Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _PaymentProcessingDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const _PaymentProcessingDialog({required this.onSuccess});

  @override
  State<_PaymentProcessingDialog> createState() =>
      _PaymentProcessingDialogState();
}

class _PaymentProcessingDialogState extends State<_PaymentProcessingDialog>
    with TickerProviderStateMixin {
  bool _isSuccess = false;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _processPayment();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // Simulate network delay for processing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isSuccess = true;
      });

      _scaleController.forward();
      _confettiController.forward();

      // Close dialog after showing success for a while
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pop(context);
        widget.onSuccess();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isSuccess) ...[
                const CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                  strokeWidth: 4,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Processing Payment...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3240),
                  ),
                ),
              ] else ...[
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                      ),
                    ),
                    // Confetti particles
                    ...List.generate(12, (index) {
                      final angle = (index * 30) * 3.14159 / 180;
                      return AnimatedBuilder(
                        animation: _confettiController,
                        builder: (context, child) {
                          final value = Curves.easeOutQuad.transform(
                            _confettiController.value,
                          );
                          return Positioned(
                            left:
                                60 +
                                (value *
                                    80 *
                                    1.5 *
                                    (index % 2 == 0 ? 1 : -1) *
                                    0.8),
                            top:
                                60 +
                                (value *
                                    80 *
                                    1.5 *
                                    (index % 3 == 0 ? 1 : -1) *
                                    1.2),
                            child: Transform.translate(
                              offset: Offset(
                                80 * value * 1.2 * _cos(angle),
                                80 * value * 1.2 * _sin(angle),
                              ),
                              child: Opacity(
                                opacity: 1 - value,
                                child: Text(
                                  index % 2 == 0 ? '✨' : '🎉',
                                  style: TextStyle(
                                    fontSize: 16 + (index % 3) * 4,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to Insider Prime.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _cos(double x) {
    return 1 - (x * x) / 2 + (x * x * x * x) / 24;
  }

  double _sin(double x) {
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }
}

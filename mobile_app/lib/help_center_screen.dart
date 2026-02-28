import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int? _openIndex;

  static const List<_HelpTopic> _topics = [
    _HelpTopic(
      icon: Icons.shopping_bag_outlined,
      title: 'Orders & Cancellations',
      color: Color(0xFFFF3F6C),
      bg: Color(0xFFFFE5EC),
      content: [
        _Point(
          Icons.local_shipping_outlined,
          'Track Orders',
          'Go to Profile > Orders to see live tracking status of any order, including estimated delivery date and courier details.',
        ),
        _Point(
          Icons.edit_outlined,
          'Modify Orders',
          'Order modifications (size, quantity) are allowed only before the item is shipped. Contact support immediately after placing the order.',
        ),
        _Point(
          Icons.cancel_outlined,
          'Cancel Orders',
          'You can cancel eligible orders from the Orders page before they are shipped. Prepaid orders will be refunded within 5-7 business days.',
        ),
        _Point(
          Icons.report_problem_outlined,
          'Order Not Received',
          'If your order status shows Delivered but you have not received it, raise a complaint within 48 hours via Grievance Redressal.',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.local_shipping_outlined,
      title: 'Delivery & Tracking',
      color: Color(0xFF3B82F6),
      bg: Color(0xFFDBEAFE),
      content: [
        _Point(
          Icons.access_time,
          'Delivery Time',
          'Standard delivery takes 3-7 business days. Express delivery (select cities) takes 1-2 business days.',
        ),
        _Point(
          Icons.location_on_outlined,
          'Live Tracking',
          'Real-time tracking is available once your order is shipped. You will receive SMS and app notifications at every step.',
        ),
        _Point(
          Icons.home_outlined,
          'Delivery Address',
          'Address changes are allowed only before the order is shipped. Update via Orders page within 30 minutes of placing the order.',
        ),
        _Point(
          Icons.refresh,
          'Rescheduling',
          'If delivery was attempted and missed, our partner will try again within 24-48 hours. You can also reschedule via the tracking link.',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.swap_horiz,
      title: 'Returns & Exchanges',
      color: Color(0xFF10B981),
      bg: Color(0xFFD1FAE5),
      content: [
        _Point(
          Icons.assignment_return_outlined,
          'Return Policy',
          'Most items are returnable within 30 days of delivery. Items must be unused, unwashed, with original tags attached.',
        ),
        _Point(
          Icons.sync_alt,
          'Exchange Policy',
          'Size exchanges are free of cost and can be requested from the Orders page. Availability depends on stock.',
        ),
        _Point(
          Icons.directions_car_outlined,
          'Pickup',
          'Return pickup is scheduled within 24-48 hours of your request. Ensure the item is packed and ready for the courier.',
        ),
        _Point(
          Icons.block,
          'Non-Returnable Items',
          'Innerwear, perfumes, customised products, and items marked "Non-Returnable" on the product page cannot be returned.',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Payments & Refunds',
      color: Color(0xFFF59E0B),
      bg: Color(0xFFFEF3C7),
      content: [
        _Point(
          Icons.credit_card_outlined,
          'Payment Methods',
          'We accept UPI, debit/credit cards (Visa, Mastercard, Amex), net banking, and Cash on Delivery (COD) for orders below Rs. 10,000.',
        ),
        _Point(
          Icons.currency_rupee,
          'Refund Timeline',
          'Refunds are initiated within 2 business days after the return is received and verified. Bank credit takes 5-7 additional days.',
        ),
        _Point(
          Icons.error_outline,
          'Payment Failed',
          'If your payment failed but was debited, the amount will auto-reverse within 7 working days. No manual action needed.',
        ),
        _Point(
          Icons.receipt_long_outlined,
          'Invoice',
          'Download your invoice from Orders > Order Details > Download Invoice. GST invoices are available for business accounts.',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.local_offer_outlined,
      title: 'Coupons & Offers',
      color: Color(0xFFEC4899),
      bg: Color(0xFFFCE7F3),
      content: [
        _Point(
          Icons.sell_outlined,
          'Apply Coupon',
          'Enter your coupon code at checkout in the "Apply Coupon" field. The discount reflects instantly on the order total.',
        ),
        _Point(
          Icons.casino_outlined,
          'Spin & Win',
          'Visit the Coupons section in your Profile to spin the wheel and win exclusive discount codes and cashback.',
        ),
        _Point(
          Icons.timer_outlined,
          'Coupon Expiry',
          'Each coupon has an expiry date shown in your Coupons section. Expired coupons cannot be reactivated.',
        ),
        _Point(
          Icons.lock_outline,
          'Coupon Limits',
          'Only one coupon can be applied per order. Some coupons are valid only on selected categories or minimum order values.',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.person_outline,
      title: 'Account & Profile',
      color: Color(0xFF8B5CF6),
      bg: Color(0xFFEDE9FE),
      content: [
        _Point(
          Icons.lock_outline,
          'Change Password',
          'Go to Account Details > Change Password. An OTP will be sent to your registered email or mobile to verify the change.',
        ),
        _Point(
          Icons.location_on_outlined,
          'Manage Addresses',
          'Add, edit or delete delivery addresses in Profile > Addresses. You can save up to 10 addresses.',
        ),
        _Point(
          Icons.delete_outline,
          'Delete Account',
          'Account deletion is permanent. All data, order history and rewards will be erased. Contact support to initiate.',
        ),
        _Point(
          Icons.photo_camera_outlined,
          'Profile Photo',
          'Update your profile photo from Account Details. Supported formats: JPG, PNG (max 5 MB).',
        ),
      ],
    ),
    _HelpTopic(
      icon: Icons.phone_in_talk_outlined,
      title: 'Contact Support',
      color: Color(0xFF6366F1),
      bg: Color(0xFFE0E7FF),
      content: [
        _Point(
          Icons.email_outlined,
          'Email',
          'Write to us at support@myntra.com. We respond within 24-48 business hours.',
        ),
        _Point(
          Icons.call_outlined,
          'Phone',
          'Call us on 1800-102-8508 (Toll Free). Available Monday-Saturday, 9 AM to 9 PM IST.',
        ),
        _Point(
          Icons.assignment_outlined,
          'Grievance',
          'For escalations, use the Grievance Redressal form under Profile. We respond within 48 working hours with a reference ID.',
        ),
        _Point(
          Icons.business_outlined,
          'Address',
          'Myntra Designs Pvt. Ltd., Embassy Tech Village, Outer Ring Road, Devarabisanahalli, Bengaluru - 560103.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How can we help you?',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'We\'re here\nfor you!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Tap any topic below to expand.',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Help Topics',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 14),

            // Accordion topic cards
            ...List.generate(_topics.length, (i) {
              final topic = _topics[i];
              final isOpen = _openIndex == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isOpen
                      ? Border.all(
                          color: topic.color.withValues(alpha: 0.4),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isOpen ? 0.1 : 0.05,
                      ),
                      blurRadius: isOpen ? 14 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header row
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          setState(() => _openIndex = isOpen ? null : i),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: topic.bg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                topic.icon,
                                color: topic.color,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                topic.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isOpen
                                      ? topic.color
                                      : const Color(0xFF1E1B4B),
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: isOpen ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: isOpen
                                    ? topic.color
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded content
                    if (isOpen) ...[
                      Divider(
                        height: 1,
                        color: topic.color.withValues(alpha: 0.2),
                        indent: 16,
                        endIndent: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          children: topic.content
                              .map(
                                (p) => _PointTile(point: p, color: topic.color),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────

class _HelpTopic {
  final IconData icon;
  final String title;
  final Color color;
  final Color bg;
  final List<_Point> content;

  const _HelpTopic({
    required this.icon,
    required this.title,
    required this.color,
    required this.bg,
    required this.content,
  });
}

class _Point {
  final IconData icon;
  final String label;
  final String detail;
  const _Point(this.icon, this.label, this.detail);
}

class _PointTile extends StatelessWidget {
  final _Point point;
  final Color color;
  const _PointTile({required this.point, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(point.icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  point.detail,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.5,
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

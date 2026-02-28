import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  static const List<_FaqSection> _sections = [
    _FaqSection(
      title: 'Orders & Delivery',
      icon: Icons.shopping_bag_outlined,
      color: Color(0xFFFF3F6C),
      items: [
        _FaqItem(
          q: 'How do I track my order?',
          a: 'Go to Profile → Orders. Tap on any order to see real-time tracking updates including delivery partner details and estimated delivery time.',
        ),
        _FaqItem(
          q: 'Can I change my delivery address after placing an order?',
          a: 'Address changes are possible only before the order is shipped. Contact support within 30 minutes of placing the order.',
        ),
        _FaqItem(
          q: 'How long does delivery take?',
          a: 'Standard delivery takes 3–7 business days. Express delivery (available in select cities) takes 1–2 business days.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Returns & Refunds',
      icon: Icons.swap_horiz,
      color: Color(0xFF10B981),
      items: [
        _FaqItem(
          q: 'What is the return policy?',
          a: 'Most items are eligible for return or exchange within 30 days of delivery. Items must be unused, unwashed and have all tags intact.',
        ),
        _FaqItem(
          q: 'How long does a refund take?',
          a: 'Refunds are processed within 5–7 business days after the returned item reaches our warehouse. Bank credits may take an additional 2–3 days.',
        ),
        _FaqItem(
          q: 'My return pickup hasn\'t been scheduled yet. What should I do?',
          a: 'Pickups are typically scheduled within 24–48 hours after the return request. If delayed, please contact our customer support.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Payments & Coupons',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFF59E0B),
      items: [
        _FaqItem(
          q: 'What payment methods are accepted?',
          a: 'We accept UPI, debit/credit cards, net banking, and cash on delivery (COD) for orders below ₹10,000.',
        ),
        _FaqItem(
          q: 'How do I apply a coupon code?',
          a: 'During checkout, look for the "Apply Coupon" field. Enter your code and tap Apply. Valid codes will instantly reflect the discount.',
        ),
        _FaqItem(
          q: 'My payment was deducted but order not placed — what now?',
          a: 'Don\'t worry! If payment was deducted without order confirmation, you\'ll receive a refund within 5–7 working days automatically.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Account & Profile',
      icon: Icons.person_outline,
      color: Color(0xFF8B5CF6),
      items: [
        _FaqItem(
          q: 'How do I change my password?',
          a: 'Go to Profile → Account Details → Change Password. You\'ll receive an OTP on your registered email or phone to verify the change.',
        ),
        _FaqItem(
          q: 'Can I have multiple delivery addresses?',
          a: 'Yes! Go to Profile → Addresses to add, edit or delete multiple delivery addresses up to a maximum of 10.',
        ),
        _FaqItem(
          q: 'How do I delete my account?',
          a: 'Contact our support team. Account deletion is permanent and all your data, orders history and rewards will be erased.',
        ),
      ],
    ),
  ];

  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'FAQs',
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
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
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
                          '❓ Frequently Asked',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Find quick answers\nto common questions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
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
                      Icons.quiz_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ...List.generate(_sections.length, (si) {
              final section = _sections[si];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: section.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          section.icon,
                          color: section.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        section.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: section.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Items
                  ...List.generate(section.items.length, (qi) {
                    final globalIdx = si * 100 + qi;
                    final isOpen = _expanded.contains(globalIdx);
                    final item = section.items[qi];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: isOpen
                            ? Border.all(
                                color: section.color.withValues(alpha: 0.35),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          onExpansionChanged: (open) => setState(() {
                            if (open) {
                              _expanded.add(globalIdx);
                            } else {
                              _expanded.remove(globalIdx);
                            }
                          }),
                          leading: Icon(
                            isOpen
                                ? Icons.remove_circle
                                : Icons.add_circle_outline,
                            color: section.color,
                            size: 22,
                          ),
                          title: Text(
                            item.q,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isOpen
                                  ? section.color
                                  : const Color(0xFF1E1B4B),
                            ),
                          ),
                          trailing: const SizedBox.shrink(),
                          children: [
                            Text(
                              item.a,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Colors.black54,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FaqSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<_FaqItem> items;
  const _FaqSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

import 'package:flutter/material.dart';

/// Reusable legal content screen (Terms of Use, Privacy Policy, About Us)
class LegalScreen extends StatelessWidget {
  final String title;
  final String emoji;
  final List<_LegalSection> sections;

  const LegalScreen({
    super.key,
    required this.title,
    required this.emoji,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : const Color(0xFFFDE7EC),
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: Colors.white10) : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$emoji $title',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Please read\ncarefully',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF282C3F),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last updated: February 2026',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: primaryColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sections
            ...sections.asMap().entries.map((entry) {
              final i = entry.key;
              final s = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: isDark ? Border.all(color: Colors.white10) : null,
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s.heading,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF282C3F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.body,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.7,
                      ),
                    ),
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

class _LegalSection {
  final String heading;
  final String body;
  const _LegalSection({required this.heading, required this.body});
}

// ─── Terms of Use ─────────────────────────────────────────────────────────────
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  static const List<_LegalSection> _sections = [
    _LegalSection(
      heading: 'Acceptance of Terms',
      body:
          'By accessing or using the StyleHub app, you agree to be bound by these Terms of Use. If you do not agree to all the terms, please do not use our services. We reserve the right to update these terms at any time.',
    ),
    _LegalSection(
      heading: 'User Accounts',
      body:
          'You must be 18 years or older to create an account. You are responsible for maintaining the confidentiality of your login credentials. You agree to immediately notify us of any unauthorized use of your account.',
    ),
    _LegalSection(
      heading: 'Products & Pricing',
      body:
          'All products listed are subject to availability. Prices are subject to change without notice. We reserve the right to limit quantities and to cancel or refuse any order at any time.',
    ),
    _LegalSection(
      heading: 'Intellectual Property',
      body:
          'All content on this platform — including text, graphics, logos, images, and software — is the property of StyleHub or its content suppliers and is protected by applicable copyright and trademark laws.',
    ),
    _LegalSection(
      heading: 'Limitation of Liability',
      body:
          'To the fullest extent permitted by law, StyleHub shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the app or any products purchased through it.',
    ),
    _LegalSection(
      heading: 'Governing Law',
      body:
          'These terms shall be governed by and construed in accordance with the laws of India, and disputes shall be subject to the exclusive jurisdiction of the courts in Bangalore, Karnataka.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const LegalScreen(
      title: 'Terms of Use',
      emoji: '📋',
      sections: _sections,
    );
  }
}

// ─── Privacy Policy ───────────────────────────────────────────────────────────
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<_LegalSection> _sections = [
    _LegalSection(
      heading: 'Information We Collect',
      body:
          'We collect information you provide directly (name, email, address) and information generated when you use our services (order history, browsing behaviour, device information, and location when permitted).',
    ),
    _LegalSection(
      heading: 'How We Use Your Information',
      body:
          'Your data is used to process orders, personalise your shopping experience, send promotional communications (with your consent), improve our services, and comply with legal obligations.',
    ),
    _LegalSection(
      heading: 'Data Sharing',
      body:
          'We do not sell your personal data. We may share it with trusted third-party partners (logistics, payment processors) who assist in our operations, under strict confidentiality agreements.',
    ),
    _LegalSection(
      heading: 'Cookies & Tracking',
      body:
          'We use cookies and similar technologies to enhance your experience, analyse usage patterns, and deliver personalised advertisements. You can control cookie settings through your browser preferences.',
    ),
    _LegalSection(
      heading: 'Data Security',
      body:
          'We implement industry-standard security measures including SSL encryption, secure servers, and access controls to protect your personal information from unauthorised access or disclosure.',
    ),
    _LegalSection(
      heading: 'Your Rights',
      body:
          'You have the right to access, correct, or delete your personal data. To exercise these rights, contact our Data Protection Officer at privacy@stylehub.com. We will respond within 30 days.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const LegalScreen(
      title: 'Privacy Policy',
      emoji: '🔒',
      sections: _sections,
    );
  }
}

// ─── About Us ─────────────────────────────────────────────────────────────────
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const List<_LegalSection> _sections = [
    _LegalSection(
      heading: 'Who We Are',
      body:
          'StyleHub is India\'s leading fashion e-commerce platform. Founded in 2007, we connect millions of fashion lovers with the latest trends from thousands of brands — all in one place.',
    ),
    _LegalSection(
      heading: 'Our Mission',
      body:
          'To be the most customer-centric fashion destination in India – helping people discover, express, and celebrate their unique personal style, every single day.',
    ),
    _LegalSection(
      heading: 'Our Journey',
      body:
          'From a small personalised gifting startup in Bangalore, StyleHub has grown into a fashion powerhouse with over 5 million products across 7,000+ brands, serving customers in 19,000+ pin codes.',
    ),
    _LegalSection(
      heading: 'Sustainability',
      body:
          'We are committed to responsible fashion. Our initiatives include eco-friendly packaging, a circular fashion programme, and partnerships with sustainable brands that put the planet first.',
    ),
    _LegalSection(
      heading: 'Contact Us',
      body:
          'Registered Address: StyleHub Designs Pvt. Ltd., Buildings Alyssa, Begonia & Clover,\nEmbassy Tech Village, Outer Ring Road,\nDevarabisanahalli, Bengaluru – 560103\n\nEmail: support@stylehub.com\nPhone: 1800-102-8508 (Toll Free)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const LegalScreen(
      title: 'About Us',
      emoji: '🏢',
      sections: _sections,
    );
  }
}

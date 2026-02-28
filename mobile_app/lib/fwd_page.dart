// ignore_for_file: unnecessary_underscores
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// ─────────────────────────────────────────────
//  FWD PAGE – Ugadi & Pongal Festival Edition
// ─────────────────────────────────────────────

// Festival color palette
const Color _saffron = Color(0xFFFF6B00);
const Color _turmeric = Color(0xFFFFB300);
const Color _deepGreen = Color(0xFF2E7D32);
const Color _leafGreen = Color(0xFF43A047);
const Color _crimson = Color(0xFFC62828);
const Color _cream = Color(0xFFFFF8E1);
const Color _darkBrown = Color(0xFF3E2723);

class FwdPage extends StatefulWidget {
  const FwdPage({super.key});

  @override
  State<FwdPage> createState() => _FwdPageState();
}

class _FwdPageState extends State<FwdPage> with TickerProviderStateMixin {
  late AnimationController _swingController;
  late AnimationController _floatController;

  late Animation<double> _swingAnimation;

  // Countdown to Ugadi (March 30, 2025 / March 19, 2026)
  Duration _timeLeft = Duration.zero;
  Timer? _countdownTimer;

  // Banner carousel
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  int _currentBanner = 0;
  Timer? _bannerTimer;

  // Floating particles
  final List<_FestivalParticle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();

    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _swingAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _swingController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Mix of flower petals and mango leaves
    for (int i = 0; i < 28; i++) {
      _particles.add(_FestivalParticle(rng: _rng, index: i));
    }

    _startCountdown();
    _startBannerAutoPlay();
  }

  void _startCountdown() {
    final now = DateTime.now();
    DateTime festival = DateTime(2026, 3, 19);
    if (now.isAfter(festival)) {
      festival = DateTime(2027, 4, 7);
    }
    _timeLeft = festival.difference(now);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        }
      });
    });
  }

  void _startBannerAutoPlay() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _festivalBanners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _swingController.dispose();
    _floatController.dispose();
    _countdownTimer?.cancel();
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // ── Data ──────────────────────────────────────────────────────────────────

  static const List<Map<String, String>> _festivalBanners = [
    {
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop',
      'title': 'ugadi_and_pongal_utsav',
      'subtitle': 'up_to_70percent_off_on_ethnic_wear',
      'tag': 'festival_special',
      'color': '0xFFFF6B00',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&auto=format&fit=crop&q=80',
      'title': 'silk_sarees_and_lehengas',
      'subtitle': 'kanjivaram_from_2_999',
      'tag': 'ethnic_edit',
      'color': '0xFFC62828',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800&auto=format&fit=crop&q=80',
      'title': 'festive_jewellery',
      'subtitle': 'temple_and_gold_jewellery_from_999',
      'tag': 'gold_and_gems',
      'color': '0xFFFFB300',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
      'title': 'puja_and_home_decor',
      'subtitle': 'rangoli_diyas_and_flowers',
      'tag': 'home_festive',
      'color': '0xFF2E7D32',
    },
  ];

  static const List<Map<String, dynamic>> _categories = [
    {
      'label': 'sarees',
      'icon': Icons.woman,
      'color': _crimson,
      'img':
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=300&auto=format&fit=crop&q=80',
    },
    {
      'label': 'kurtas',
      'icon': Icons.man,
      'color': _saffron,
      'img':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=300&auto=format&fit=crop',
    },
    {
      'label': 'jewellery',
      'icon': Icons.diamond,
      'color': _turmeric,
      'img':
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=300&auto=format&fit=crop&q=80',
    },
    {
      'label': 'footwear',
      'icon': Icons.hiking,
      'color': _deepGreen,
      'img':
          'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=300&auto=format&fit=crop&q=80',
    },
    {
      'label': 'home_decor',
      'icon': Icons.home,
      'color': _leafGreen,
      'img':
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&auto=format&fit=crop&q=80',
    },
    {
      'label': 'gifts',
      'icon': Icons.card_giftcard,
      'color': _darkBrown,
      'img':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=300&auto=format&fit=crop&q=80',
    },
  ];

  static const List<Map<String, dynamic>> _flashDeals = [
    {
      'name': 'kanjivaram_silk_saree',
      'brand': 'nalli_silks',
      'price': '₹3,499',
      'original': '₹8,999',
      'discount': '61% OFF',
      'rating': '4.8',
      'img':
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400&auto=format&fit=crop&q=80',
      'tag': 'bestseller',
    },
    {
      'name': 'men_s_dhoti_kurta_set',
      'brand': 'fabindia',
      'price': '₹1,299',
      'original': '₹3,499',
      'discount': '63% OFF',
      'rating': '4.6',
      'img':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400&auto=format&fit=crop',
      'tag': 'trending',
    },
    {
      'name': 'temple_gold_necklace',
      'brand': 'tanishq',
      'price': '₹2,799',
      'original': '₹5,999',
      'discount': '53% OFF',
      'rating': '4.9',
      'img':
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&auto=format&fit=crop&q=80',
      'tag': 'hot',
    },
    {
      'name': 'kolhapuri_chappals',
      'brand': 'bata',
      'price': '₹799',
      'original': '₹1,799',
      'discount': '56% OFF',
      'rating': '4.5',
      'img':
          'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400&auto=format&fit=crop&q=80',
      'tag': 'festive',
    },
  ];

  static const List<Map<String, dynamic>> _festiveGuide = [
    {
      'title': 'for_women',
      'subtitle': 'sarees_lehengas_and_jewellery',
      'img':
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=500&auto=format&fit=crop&q=80',
      'color': _crimson,
    },
    {
      'title': 'for_men',
      'subtitle': 'kurtas_dhotis_and_sherwanis',
      'img':
          'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=500&auto=format&fit=crop&q=80',
      'color': _deepGreen,
    },
    {
      'title': 'home_and_puja',
      'subtitle': 'decor_diyas_and_rangoli',
      'img':
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=500&auto=format&fit=crop&q=80',
      'color': _saffron,
    },
  ];

  static const List<Map<String, dynamic>> _specialOffers = [
    {
      'title': 'buy_2_get_1_free',
      'desc': 'on_all_ethnic_wear',
      'icon': Icons.redeem,
      'color': _saffron,
    },
    {
      'title': 'free_gift_wrap',
      'desc': 'on_orders_above_1_499',
      'icon': Icons.card_giftcard,
      'color': _crimson,
    },
    {
      'title': 'express_delivery',
      'desc': 'delivered_before_ugadi',
      'icon': Icons.local_shipping,
      'color': _deepGreen,
    },
    {
      'title': 'extra_15percent_off',
      'desc': 'use_code_ugadi15',
      'icon': Icons.discount,
      'color': _turmeric,
    },
  ];

  static const List<Map<String, dynamic>> _products = [
    {
      'name': 'pattu_pavadai_set',
      'brand': 'pothys',
      'price': '₹1,899',
      'original': '₹3,999',
      'discount': '53%',
      'rating': '4.7',
      'img':
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400&auto=format&fit=crop&q=80',
    },
    {
      'name': 'gold_jhumka_earrings',
      'brand': 'malabar_gold',
      'price': '₹1,499',
      'original': '₹2,999',
      'discount': '50%',
      'rating': '4.8',
      'img':
          'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400&auto=format&fit=crop&q=80',
    },
    {
      'name': 'angavastram_shawl',
      'brand': 'fabindia',
      'price': '₹699',
      'original': '₹1,499',
      'discount': '53%',
      'rating': '4.4',
      'img':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&auto=format&fit=crop&q=80',
    },
    {
      'name': 'brass_puja_thali_set',
      'brand': 'craftsvilla',
      'price': '₹899',
      'original': '₹1,999',
      'discount': '55%',
      'rating': '4.6',
      'img':
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400&auto=format&fit=crop&q=80',
    },
    {
      'name': 'anarkali_suit',
      'brand': 'w_for_woman',
      'price': '₹1,599',
      'original': '₹3,499',
      'discount': '54%',
      'rating': '4.5',
      'img':
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400&auto=format&fit=crop&q=80',
    },
    {
      'name': 'sandalwood_attar',
      'brand': 'forest_essentials',
      'price': '₹1,199',
      'original': '₹2,499',
      'discount': '52%',
      'rating': '4.9',
      'img':
          'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=400&auto=format&fit=crop&q=80',
    },
  ];

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Festive background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_cream, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Floating particles overlay – rendered BEHIND content
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, _) {
              return CustomPaint(
                painter: _FestivalParticlesPainter(
                  particles: _particles,
                  progress: _floatController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),

        // Main scrollable content
        CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCountdownTimer(),
                  _buildBannerCarousel(),
                  _buildSpecialOffersRow(),
                  _buildSectionTitle(
                    'shop_by_category'.tr(),
                    subtitle: 'Celebrate in style 🌺',
                  ),
                  _buildCategoryChips(),
                  _buildSectionTitle(
                    'festival_flash_deals'.tr(),
                    subtitle: 'Limited stock – grab fast! ⚡',
                  ),
                  _buildFlashDeals(),
                  _buildFestiveGuide(),
                  _buildSectionTitle(
                    'Top Festive Picks',
                    subtitle: 'Curated for Ugadi & Pongal 🎊',
                  ),
                  _buildProductGrid(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Sliver App Bar ─────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_saffron, _turmeric],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _swingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _swingAnimation.value,
                child: child,
              );
            },
            child: const Text('🌿', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 8),
          const Text(
            'FWD – Ugadi & Pongal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 6),
          const Text('🪔', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // ── Countdown Timer ────────────────────────────────────────────────────────

  Widget _buildCountdownTimer() {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_saffron, _crimson],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _saffron.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🪔', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ugadi 2026 Countdown',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Order now for festive delivery! 🌸',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              _timeUnit(days.toString().padLeft(2, '0'), 'D'),
              _timeSep(),
              _timeUnit(hours.toString().padLeft(2, '0'), 'H'),
              _timeSep(),
              _timeUnit(minutes.toString().padLeft(2, '0'), 'M'),
              _timeSep(),
              _timeUnit(seconds.toString().padLeft(2, '0'), 'S'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }

  Widget _timeSep() => const Padding(
    padding: EdgeInsets.only(bottom: 12, left: 2, right: 2),
    child: Text(
      ':',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );

  // ── Banner Carousel ────────────────────────────────────────────────────────

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _festivalBanners.length,
            onPageChanged: (p) => setState(() => _currentBanner = p),
            itemBuilder: (context, i) {
              final b = _festivalBanners[i];
              final tagColor = Color(
                int.parse(b['color']!.replaceFirst('0x', ''), radix: 16),
              );
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: tagColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        b['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: tagColor.withValues(alpha: 0.2)),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCC1A0A00)],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            b['tag']!.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 12,
                        right: 14,
                        child: Text('🌸', style: TextStyle(fontSize: 22)),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b['title']!.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b['subtitle']!.tr(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_festivalBanners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentBanner == i ? 22 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentBanner == i
                    ? _saffron
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Special Offers Row ─────────────────────────────────────────────────────

  Widget _buildSpecialOffersRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎊 Festival Special Offers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _saffron,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.2,
            children: _specialOffers.map((offer) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: (offer['color'] as Color).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (offer['color'] as Color).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      offer['icon'] as IconData,
                      color: offer['color'] as Color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (offer['title'] as String).tr(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: offer['color'] as Color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            (offer['desc'] as String).tr(),
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Section Title ──────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_saffron, _turmeric],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _darkBrown,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Category Chips ─────────────────────────────────────────────────────────

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (cat['color'] as Color).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          cat['img'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: (cat['color'] as Color).withValues(
                              alpha: 0.2,
                            ),
                            child: Icon(
                              cat['icon'] as IconData,
                              color: cat['color'] as Color,
                              size: 28,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                (cat['color'] as Color).withValues(alpha: 0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  (cat['label'] as String).tr(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _darkBrown,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Flash Deals ────────────────────────────────────────────────────────────

  Widget _buildFlashDeals() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: _flashDeals.length,
        itemBuilder: (context, i) {
          final deal = _flashDeals[i];
          return Container(
            width: 155,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        deal['img'] as String,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 140,
                          color: _cream,
                          child: const Icon(
                            Icons.local_florist,
                            color: _saffron,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _saffron,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (deal['tag'] as String).tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          (deal['discount'] as String).tr(),
                          style: const TextStyle(
                            color: _saffron,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (deal['brand'] as String).tr(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (deal['name'] as String).tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _darkBrown,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            deal['price'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: _saffron,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            deal['original'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: _turmeric, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            deal['rating'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _darkBrown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Festive Guide ──────────────────────────────────────────────────────────

  Widget _buildFestiveGuide() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌺 Festive Shopping Guide',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _darkBrown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _festiveGuide.map((g) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: g == _festiveGuide.last ? 0 : 10,
                  ),
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (g['color'] as Color).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          g['img'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: (g['color'] as Color).withValues(alpha: 0.2),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                (g['color'] as Color).withValues(alpha: 0.85),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (g['title'] as String).tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                (g['subtitle'] as String).tr(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Product Grid ───────────────────────────────────────────────────────────

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: _products.length,
        itemBuilder: (context, i) {
          return _ProductCard(product: _products[i]);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Product Card Widget
// ─────────────────────────────────────────────
class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    p['img'] as String,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _cream,
                      child: const Icon(
                        Icons.local_florist,
                        color: _saffron,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _saffron,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${p['discount']} OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (p['brand'] as String).tr(),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    (p['name'] as String).tr(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _darkBrown,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        p['price'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: _saffron,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p['original'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: _turmeric, size: 11),
                      const SizedBox(width: 2),
                      Text(
                        p['rating'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _darkBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Festival Particle System
//  Types: 0 = rose petal, 1 = marigold petal,
//         2 = mango leaf, 3 = jasmine petal,
//         4 = tiny dot / sparkle
// ─────────────────────────────────────────────

enum _ParticleType {
  rosePetal,
  marigoldPetal,
  mangoLeaf,
  jasminePetal,
  sparkle,
}

class _FestivalParticle {
  /// Normalised starting X position (0–1)
  final double x;

  /// Normalised starting Y offset so particles are spread across the
  /// whole screen at t=0 instead of all spawning at the top.
  final double startY;

  /// How fast the particle falls (normalised units per animation cycle)
  final double speed;

  /// Visual size in logical pixels
  final double size;

  /// Max opacity
  final double opacity;

  /// Phase offset so every particle is at a different point in its cycle
  final double phase;

  /// Horizontal sway amplitude in pixels
  final double swayAmp;

  /// Horizontal sway frequency multiplier
  final double swayFreq;

  /// Initial rotation angle (radians)
  final double initAngle;

  /// How fast the particle spins (radians per full progress cycle)
  final double spinSpeed;

  /// Which shape to draw
  final _ParticleType type;

  /// Pre-chosen colour
  final Color color;

  _FestivalParticle({required Random rng, required int index})
    : x = rng.nextDouble(),
      startY = rng.nextDouble(), // distribute vertically at start
      speed = 0.04 + rng.nextDouble() * 0.06,
      size = 8 + rng.nextDouble() * 14,
      opacity = 0.55 + rng.nextDouble() * 0.35,
      phase = rng.nextDouble(),
      swayAmp = 12 + rng.nextDouble() * 24,
      swayFreq = 1.5 + rng.nextDouble() * 2.5,
      initAngle = rng.nextDouble() * 2 * pi,
      spinSpeed = (rng.nextBool() ? 1 : -1) * (pi + rng.nextDouble() * 3 * pi),
      type = _ParticleType.values[index % _ParticleType.values.length],
      color = _pickColor(rng, index % _ParticleType.values.length);

  static Color _pickColor(Random rng, int typeIndex) {
    // Colour palettes per particle type
    const roseColors = [
      Color(0xFFFF7043),
      Color(0xFFFF8A65),
      Color(0xFFE64A19),
    ];
    const marigoldColors = [
      Color(0xFFFFB300),
      Color(0xFFFF8F00),
      Color(0xFFFFD54F),
    ];
    const mangoLeafColors = [
      Color(0xFF43A047),
      Color(0xFF2E7D32),
      Color(0xFF66BB6A),
      Color(0xFF1B5E20),
    ];
    const jasmineColors = [
      Color(0xFFFFFDE7),
      Color(0xFFFFF9C4),
      Color(0xFFFFFBE7),
    ];
    const sparkleColors = [
      Color(0xFFFFD700),
      Color(0xFFFF6B00),
      Color(0xFFE91E63),
    ];

    final palettes = [
      roseColors,
      marigoldColors,
      mangoLeafColors,
      jasmineColors,
      sparkleColors,
    ];
    final palette = palettes[typeIndex];
    return palette[rng.nextInt(palette.length)];
  }
}

class _FestivalParticlesPainter extends CustomPainter {
  final List<_FestivalParticle> particles;
  final double progress; // 0 → 1, repeating

  const _FestivalParticlesPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Each particle loops independently based on its speed + phase.
      final t = ((progress * p.speed / 0.05 + p.phase) % 1.0);

      // Y goes from slightly above top (negative) to below bottom.
      final rawY = (t - 0.1) * (size.height * 1.2);
      // X sways sinusoidally.
      final rawX =
          size.width * p.x +
          sin(t * 2 * pi * p.swayFreq + p.phase * 6.28) * p.swayAmp;

      // Fade in near top, fade out near bottom.
      final fade = _fade(t);
      final alpha = (p.opacity * fade).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // Current rotation angle.
      final angle = p.initAngle + t * p.spinSpeed;

      canvas.save();
      canvas.translate(rawX, rawY);
      canvas.rotate(angle);

      switch (p.type) {
        case _ParticleType.rosePetal:
          _drawRosePetal(canvas, p.size, paint);
          break;
        case _ParticleType.marigoldPetal:
          _drawMarigoldPetal(canvas, p.size, paint);
          break;
        case _ParticleType.mangoLeaf:
          _drawMangoLeaf(canvas, p.size, paint);
          break;
        case _ParticleType.jasminePetal:
          _drawJasminePetal(canvas, p.size, paint);
          break;
        case _ParticleType.sparkle:
          _drawSparkle(canvas, p.size, paint, alpha);
          break;
      }

      canvas.restore();
    }
  }

  /// Smooth fade: 0→1 in first 10% of travel, 1→0 in last 15%.
  static double _fade(double t) {
    if (t < 0.1) return t / 0.1;
    if (t > 0.85) return (1.0 - t) / 0.15;
    return 1.0;
  }

  // ── Rose / hibiscus petal – asymmetric teardrop ──────────────────────────
  void _drawRosePetal(Canvas canvas, double s, Paint paint) {
    final path = Path();
    // Wider rounded top, tapered tip at bottom.
    path.moveTo(0, -s * 0.55);
    path.cubicTo(
      s * 0.55,
      -s * 0.55, // ctrl1
      s * 0.55,
      s * 0.3, // ctrl2
      0,
      s * 0.55, // end (tip)
    );
    path.cubicTo(-s * 0.55, s * 0.3, -s * 0.55, -s * 0.55, 0, -s * 0.55);

    // Draw slightly translucent highlight for petal depth.
    canvas.drawPath(path, paint);

    // Vein line.
    final veinPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    canvas.drawLine(Offset(0, -s * 0.5), Offset(0, s * 0.5), veinPaint);
  }

  // ── Marigold / sunflower petal – elongated oval ──────────────────────────
  void _drawMarigoldPetal(Canvas canvas, double s, Paint paint) {
    final rect = Rect.fromCenter(
      center: Offset(0, 0),
      width: s * 0.45,
      height: s * 1.0,
    );
    canvas.drawOval(rect, paint);

    // Slightly darker border for definition.
    final borderPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawOval(rect, borderPaint);
  }

  // ── Mango leaf – elongated pointed leaf with midrib ──────────────────────
  void _drawMangoLeaf(Canvas canvas, double s, Paint paint) {
    final path = Path();
    // Start at stem end (bottom), curve out to widest point, taper to tip.
    path.moveTo(0, s * 0.7); // stem base
    path.cubicTo(
      s * 0.38,
      s * 0.4, // right bulge
      s * 0.42,
      -s * 0.2,
      0,
      -s * 0.7, // pointed tip
    );
    path.cubicTo(-s * 0.42, -s * 0.2, -s * 0.38, s * 0.4, 0, s * 0.7);

    canvas.drawPath(path, paint);

    // Midrib.
    final ribPaint = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, s * 0.65), Offset(0, -s * 0.65), ribPaint);

    // A couple of lateral veins.
    final veinPaint = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    for (final dy in [-s * 0.15, s * 0.1, s * 0.35]) {
      canvas.drawLine(
        Offset(0, dy),
        Offset(s * 0.35, dy - s * 0.05),
        veinPaint,
      );
      canvas.drawLine(
        Offset(0, dy),
        Offset(-s * 0.35, dy - s * 0.05),
        veinPaint,
      );
    }
  }

  // ── Jasmine petal – small round petal ───────────────────────────────────
  void _drawJasminePetal(Canvas canvas, double s, Paint paint) {
    // Five rounded lobes arranged in a ring.
    final outerR = s * 0.5;
    final innerR = s * 0.15;
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * pi - pi / 2;
      final cx = cos(angle) * (outerR - innerR * 1.2);
      final cy = sin(angle) * (outerR - innerR * 1.2);
      canvas.drawCircle(Offset(cx, cy), innerR * 1.5, paint);
    }
    // Centre dot.
    final centrePaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: paint.color.a)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, innerR * 0.9, centrePaint);
  }

  // ── Sparkle – four-pointed star ──────────────────────────────────────────
  void _drawSparkle(Canvas canvas, double s, Paint paint, double alpha) {
    final path = Path();
    final outer = s * 0.5;
    final inner = s * 0.15;
    for (int i = 0; i < 4; i++) {
      final outerAngle = (i / 4) * 2 * pi - pi / 2;
      final innerAngle = outerAngle + pi / 4;
      if (i == 0) {
        path.moveTo(cos(outerAngle) * outer, sin(outerAngle) * outer);
      } else {
        path.lineTo(cos(outerAngle) * outer, sin(outerAngle) * outer);
      }
      path.lineTo(cos(innerAngle) * inner, sin(innerAngle) * inner);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Glow ring.
    final glowPaint = Paint()
      ..color = paint.color.withValues(alpha: alpha * 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, s * 0.45, glowPaint);
  }

  @override
  bool shouldRepaint(_FestivalParticlesPainter old) => old.progress != progress;
}

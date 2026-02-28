import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
class _Coupon {
  final String code;
  final String title;
  final String desc;
  final String expiry;
  final Color accentColor;
  final Color bgFrom;
  final Color bgTo;
  final IconData icon;

  const _Coupon({
    required this.code,
    required this.title,
    required this.desc,
    required this.expiry,
    required this.accentColor,
    required this.bgFrom,
    required this.bgTo,
    required this.icon,
  });
}

// ─── Fortune Wheel Items ───────────────────────────────────────────────────────
class _WheelItem {
  final String label;
  final bool isWin;
  final Color color;
  _WheelItem(this.label, this.isWin, this.color);
}

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with TickerProviderStateMixin {
  final StreamController<int> _selected = StreamController<int>();
  bool _isSpinning = false;
  int? _currentResult;

  // Win dialog animation controllers
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  static const List<_Coupon> _coupons = [
    _Coupon(
      code: 'WELCOME50',
      title: '50% OFF',
      desc: 'Flat half-price on your first apparel order',
      expiry: 'Expires in 3 days',
      accentColor: Color(0xFFFF3F6C),
      bgFrom: Color(0xFFFF3F6C),
      bgTo: Color(0xFFFF8FAB),
      icon: Icons.celebration,
    ),
    _Coupon(
      code: 'WINTER20',
      title: '20% OFF',
      desc: 'Extra savings on the Winter Collection',
      expiry: 'Expires in 7 days',
      accentColor: Color(0xFF3B82F6),
      bgFrom: Color(0xFF2563EB),
      bgTo: Color(0xFF60A5FA),
      icon: Icons.ac_unit,
    ),
    _Coupon(
      code: 'FREEDEL',
      title: 'FREE DELIVERY',
      desc: 'Zero delivery charges on orders above ₹999',
      expiry: 'Expires in 2 days',
      accentColor: Color(0xFF10B981),
      bgFrom: Color(0xFF059669),
      bgTo: Color(0xFF34D399),
      icon: Icons.local_shipping,
    ),
    _Coupon(
      code: 'INSIDER15',
      title: '15% OFF',
      desc: 'Exclusive discount for Insider members',
      expiry: 'Expires in 14 days',
      accentColor: Color(0xFF8B5CF6),
      bgFrom: Color(0xFF7C3AED),
      bgTo: Color(0xFFA78BFA),
      icon: Icons.workspace_premium,
    ),
    _Coupon(
      code: 'CASHBACK100',
      title: '₹100 CASHBACK',
      desc: 'Cashback on orders of ₹599 and above',
      expiry: 'Expires in 5 days',
      accentColor: Color(0xFFF59E0B),
      bgFrom: Color(0xFFD97706),
      bgTo: Color(0xFFFBBF24),
      icon: Icons.account_balance_wallet,
    ),
  ];

  final List<_WheelItem> _wheelItems = [
    _WheelItem('10% OFF', true, const Color(0xFFFF3F6C)),
    _WheelItem('Better Luck!', false, const Color(0xFF9CA3AF)),
    _WheelItem('Free Delivery', true, const Color(0xFF10B981)),
    _WheelItem('Try Again', false, const Color(0xFF6B7280)),
    _WheelItem('20% OFF', true, const Color(0xFF3B82F6)),
    _WheelItem('₹100 Cashback', true, const Color(0xFFD97706)),
    _WheelItem('15% OFF', true, const Color(0xFF8B5CF6)),
    _WheelItem('No Luck', false, const Color(0xFF9CA3AF)),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _selected.close();
    _pulseCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _currentResult = Random().nextInt(_wheelItems.length);
      _selected.add(_currentResult!);
    });
  }

  void _onSpinEnd() {
    setState(() => _isSpinning = false);
    if (_currentResult == null) return;

    final item = _wheelItems[_currentResult!];
    if (item.isWin) {
      _scaleCtrl.reset();
      _scaleCtrl.forward();
      _showWinDialog(item);
    } else {
      _showLoseSnackbar(item.label);
    }
  }

  void _showLoseSnackbar(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Text('😅', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              '$label — Better luck next spin!',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showWinDialog(_WheelItem item) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: _WinDialog(item: item, pulseAnim: _pulseAnim),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        title: Text(
          'coupons'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Banner ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '🎁 Your Coupons',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '5 active offers\nwaiting for you!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
                      Icons.local_offer,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Coupons heading ───────────────────────────────────────────────
            const Text(
              'Available Coupons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 14),

            // ── Coupon Cards ─────────────────────────────────────────────────
            ...List.generate(
              _coupons.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CouponCard(coupon: _coupons[i]),
              ),
            ),

            const SizedBox(height: 28),

            // ── Spin & Win Section ────────────────────────────────────────────
            _buildSpinSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFF472B6)],
            ).createShader(bounds),
            child: const Text(
              '🎡 SPIN & WIN',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Spin the wheel and win exclusive coupons!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Wheel
          SizedBox(
            height: 300,
            child: FortuneWheel(
              selected: _selected.stream,
              animateFirst: false,
              onAnimationEnd: _onSpinEnd,
              items: [
                for (final w in _wheelItems)
                  FortuneItem(
                    style: FortuneItemStyle(
                      color: w.color.withValues(alpha: 0.85),
                      borderColor: Colors.white24,
                      borderWidth: 2,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      w.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Spin Button
          GestureDetector(
            onTap: _spin,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 16),
              decoration: BoxDecoration(
                gradient: _isSpinning
                    ? const LinearGradient(
                        colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: _isSpinning
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFFF97316).withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isSpinning
                        ? Icons.hourglass_top
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isSpinning ? 'SPINNING...' : 'SPIN NOW',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
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

// ─── Ticket-style Coupon Card ──────────────────────────────────────────────────
class _CouponCard extends StatelessWidget {
  final _Coupon coupon;
  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: coupon.accentColor.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // ── Coloured left panel ─────────────────────────────────────────
            Container(
              width: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [coupon.bgFrom, coupon.bgTo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(coupon.icon, color: Colors.white, size: 26),
                  const SizedBox(height: 6),
                  Text(
                    coupon.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // ── Dashed divider ──────────────────────────────────────────────
            _DashedDivider(color: coupon.accentColor.withValues(alpha: 0.4)),

            // ── White right panel ───────────────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Code chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: coupon.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: coupon.accentColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tag, size: 13, color: coupon.accentColor),
                          const SizedBox(width: 4),
                          Text(
                            coupon.code,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: coupon.accentColor,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coupon.desc,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1B4B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          coupon.expiry,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
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
      ),
    );
  }
}

// ─── Dashed vertical divider ───────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: double.infinity,
      child: CustomPaint(painter: _DashPainter(color: color)),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 6.0;
    const dashGap = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + dashGap;
    }
    // Semicircle cutouts at top and bottom
    final cutPaint = Paint()
      ..color = const Color(0xFFF1F5FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, 0), 10, cutPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height), 10, cutPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Win Dialog ────────────────────────────────────────────────────────────────
class _WinDialog extends StatelessWidget {
  final _WheelItem item;
  final Animation<double> pulseAnim;
  const _WinDialog({required this.item, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: item.color.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing glow rings + icon
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, __) => Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 110 * pulseAnim.value,
                  height: 110 * pulseAnim.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color.withValues(alpha: 0.12),
                  ),
                ),
                // Middle ring
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color.withValues(alpha: 0.2),
                  ),
                ),
                // Icon circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [item.color, item.color.withValues(alpha: 0.6)],
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Big label
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [item.color, Colors.white],
            ).createShader(bounds),
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            'Congratulations! 🎉\nYour reward has been added.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),

          const SizedBox(height: 28),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: item.color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'AWESOME! 🙌',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

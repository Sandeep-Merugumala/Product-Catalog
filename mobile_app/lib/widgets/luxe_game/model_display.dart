import 'package:flutter/material.dart';
import 'models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AvatarDisplay — outer container with background + badges
// ─────────────────────────────────────────────────────────────────────────────
class AvatarDisplay extends StatelessWidget {
  final Map<FashionCategory, ClothingItem?> currentLook;
  const AvatarDisplay({super.key, required this.currentLook});

  @override
  Widget build(BuildContext context) {
    final top = currentLook[FashionCategory.tops];
    final bottom = currentLook[FashionCategory.bottoms];
    final shoes = currentLook[FashionCategory.shoes];
    final acc = currentLook[FashionCategory.accessories];
    final hasAny = currentLook.values.any((v) => v != null);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCF0F8), Color(0xFFF5EEFF), Color(0xFFEEF2FF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background accent circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE91E63).withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9C27B0).withValues(alpha: 0.05),
              ),
            ),
          ),

          // ── AVATAR ──
          Positioned.fill(
            child: Center(
              child: AspectRatio(
                aspectRatio:
                    0.46, // Standard fashion illustration ratio (approx 1:2.2)
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: CustomPaint(
                    key: ValueKey(
                      '${top?.id}_${bottom?.id}_${shoes?.id}_${acc?.id}',
                    ),
                    size: Size.infinite,
                    painter: _FashionModelPainter(
                      top: top,
                      bottom: bottom,
                      shoes: shoes,
                      acc: acc,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── EMPTY HINT ──
          if (!hasAny)
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✨ Pick items to style her!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // ── ITEM BADGES ──
          if (hasAny)
            Positioned(
              top: 10,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: FashionCategory.values.map((cat) {
                  final item = currentLook[cat];
                  if (item == null) return const SizedBox.shrink();
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey(item.id),
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: item.primaryColor.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item.name,
                            style: TextStyle(
                              color: item.primaryColor.computeLuminance() > 0.4
                                  ? Colors.black87
                                  : Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FashionModelPainter — draws the entire model on one canvas
// Proportions based on a 1:2.4 head-to-body ratio (fashion illustration standard)
// ─────────────────────────────────────────────────────────────────────────────
class _FashionModelPainter extends CustomPainter {
  final ClothingItem? top;
  final ClothingItem? bottom;
  final ClothingItem? shoes;
  final ClothingItem? acc;

  _FashionModelPainter({this.top, this.bottom, this.shoes, this.acc});

  // Skin palette
  static const _skin = Color(0xFFF5C5A3);
  static const _skinMid = Color(0xFFE8A87C);
  static const _skinDark = Color(0xFFD4956A);
  static const _hairDark = Color(0xFF2C1208);
  static const _hairMid = Color(0xFF6B3A2A);
  static const _hairHL = Color(0xFF9B6B4A);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // All measurements as fractions of canvas height
    // Head: top 0–18%, Neck: 18–22%, Torso: 22–50%, Hips: 50–60%, Legs: 60–88%, Feet: 88–100%
    // Center X
    final cx = w / 2;

    // ── HAIR (back layer) ──
    _drawHairBack(canvas, w, h, cx);

    // ── NECK ──
    _drawNeck(canvas, w, h, cx);

    // ── ARMS ──
    _drawArms(canvas, w, h, cx);

    // ── TORSO ──
    _drawTorso(canvas, w, h, cx);

    // ── HIPS / BOTTOM ──
    _drawBottom(canvas, w, h, cx);

    // ── LEGS ──
    _drawLegs(canvas, w, h, cx);

    // ── SHOES ──
    _drawShoes(canvas, w, h, cx);

    // ── HEAD ──
    _drawHead(canvas, w, h, cx);

    // ── HAIR (front) ──
    _drawHairFront(canvas, w, h, cx);

    // ── FACE DETAILS ──
    _drawFace(canvas, w, h, cx);

    // ── ACCESSORIES ──
    if (acc != null) _drawAccessory(canvas, w, h, cx);
  }

  // ── HAIR BACK ──────────────────────────────────────────────────────────────
  void _drawHairBack(Canvas canvas, double w, double h, double cx) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [_hairDark, _hairMid],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(cx - w * 0.22, 0, w * 0.44, h * 0.22));

    // Long flowing hair behind body
    final path = Path()
      ..moveTo(cx - w * 0.19, h * 0.04)
      ..cubicTo(
        cx - w * 0.26,
        h * 0.08,
        cx - w * 0.28,
        h * 0.18,
        cx - w * 0.26,
        h * 0.38,
      )
      ..cubicTo(
        cx - w * 0.25,
        h * 0.44,
        cx - w * 0.22,
        h * 0.48,
        cx - w * 0.20,
        h * 0.50,
      )
      ..lineTo(cx - w * 0.14, h * 0.50)
      ..cubicTo(
        cx - w * 0.16,
        h * 0.44,
        cx - w * 0.17,
        h * 0.36,
        cx - w * 0.16,
        h * 0.22,
      )
      ..cubicTo(
        cx - w * 0.15,
        h * 0.12,
        cx - w * 0.10,
        h * 0.04,
        cx - w * 0.10,
        h * 0.04,
      )
      ..close();
    canvas.drawPath(path, paint);

    final pathR = Path()
      ..moveTo(cx + w * 0.19, h * 0.04)
      ..cubicTo(
        cx + w * 0.26,
        h * 0.08,
        cx + w * 0.28,
        h * 0.18,
        cx + w * 0.26,
        h * 0.38,
      )
      ..cubicTo(
        cx + w * 0.25,
        h * 0.44,
        cx + w * 0.22,
        h * 0.48,
        cx + w * 0.20,
        h * 0.50,
      )
      ..lineTo(cx + w * 0.14, h * 0.50)
      ..cubicTo(
        cx + w * 0.16,
        h * 0.44,
        cx + w * 0.17,
        h * 0.36,
        cx + w * 0.16,
        h * 0.22,
      )
      ..cubicTo(
        cx + w * 0.15,
        h * 0.12,
        cx + w * 0.10,
        h * 0.04,
        cx + w * 0.10,
        h * 0.04,
      )
      ..close();
    canvas.drawPath(pathR, paint);
  }

  // ── NECK ───────────────────────────────────────────────────────────────────
  void _drawNeck(Canvas canvas, double w, double h, double cx) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - w * 0.07, h * 0.178, w * 0.14, h * 0.055),
      Radius.circular(w * 0.03),
    );
    canvas.drawRRect(rect, Paint()..color = _skin);
    // Side shadow
    canvas.drawRRect(
      rect,
      Paint()
        ..shader =
            LinearGradient(
              colors: [
                _skinDark.withValues(alpha: 0.4),
                Colors.transparent,
                _skinDark.withValues(alpha: 0.4),
              ],
              stops: const [0, 0.4, 1],
            ).createShader(
              Rect.fromLTWH(cx - w * 0.07, h * 0.178, w * 0.14, h * 0.055),
            ),
    );
  }

  // ── ARMS ───────────────────────────────────────────────────────────────────
  void _drawArms(Canvas canvas, double w, double h, double cx) {
    final topColor = top?.primaryColor ?? _skin;
    final topAccent = top?.accentColor ?? _skinMid;

    // Left arm
    _drawArm(
      canvas,
      w,
      h,
      cx,
      isLeft: true,
      sleeveColor: top != null ? topColor : null,
      sleeveAccent: top != null ? topAccent : null,
    );
    // Right arm
    _drawArm(
      canvas,
      w,
      h,
      cx,
      isLeft: false,
      sleeveColor: top != null ? topColor : null,
      sleeveAccent: top != null ? topAccent : null,
    );
  }

  void _drawArm(
    Canvas canvas,
    double w,
    double h,
    double cx, {
    required bool isLeft,
    Color? sleeveColor,
    Color? sleeveAccent,
  }) {
    final sign = isLeft ? -1.0 : 1.0;
    final armCx = cx + sign * w * 0.255;

    // Upper arm path (slim, tapered)
    final upperTop = h * 0.228;
    final upperBot = h * 0.40;
    final armW = w * 0.085;

    final upperPath = Path()
      ..moveTo(armCx - armW * 0.5, upperTop)
      ..cubicTo(
        armCx - armW * 0.6,
        upperTop + h * 0.04,
        armCx - armW * 0.55,
        upperBot - h * 0.02,
        armCx - armW * 0.4,
        upperBot,
      )
      ..lineTo(armCx + armW * 0.4, upperBot)
      ..cubicTo(
        armCx + armW * 0.55,
        upperBot - h * 0.02,
        armCx + armW * 0.6,
        upperTop + h * 0.04,
        armCx + armW * 0.5,
        upperTop,
      )
      ..close();

    if (sleeveColor != null) {
      canvas.drawPath(
        upperPath,
        Paint()
          ..shader =
              LinearGradient(
                colors: [
                  sleeveColor,
                  sleeveAccent ?? sleeveColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromLTWH(
                  armCx - armW,
                  upperTop,
                  armW * 2,
                  upperBot - upperTop,
                ),
              ),
      );
    } else {
      canvas.drawPath(
        upperPath,
        _skinPaint(
          Rect.fromLTWH(armCx - armW, upperTop, armW * 2, upperBot - upperTop),
        ),
      );
    }

    // Forearm (always skin, slim)
    final foreTop = upperBot;
    final foreBot = h * 0.545;
    final foreW = w * 0.072;

    final forePath = Path()
      ..moveTo(armCx - foreW * 0.5, foreTop)
      ..cubicTo(
        armCx - foreW * 0.55,
        foreTop + h * 0.03,
        armCx - foreW * 0.45,
        foreBot - h * 0.02,
        armCx - foreW * 0.35,
        foreBot,
      )
      ..lineTo(armCx + foreW * 0.35, foreBot)
      ..cubicTo(
        armCx + foreW * 0.45,
        foreBot - h * 0.02,
        armCx + foreW * 0.55,
        foreTop + h * 0.03,
        armCx + foreW * 0.5,
        foreTop,
      )
      ..close();
    canvas.drawPath(
      forePath,
      _skinPaint(
        Rect.fromLTWH(armCx - foreW, foreTop, foreW * 2, foreBot - foreTop),
      ),
    );

    // Hand (small oval)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(armCx, h * 0.565),
        width: foreW * 1.1,
        height: h * 0.032,
      ),
      Paint()..color = _skin,
    );
  }

  // ── TORSO ──────────────────────────────────────────────────────────────────
  void _drawTorso(Canvas canvas, double w, double h, double cx) {
    final torsoPath = Path()
      ..moveTo(cx - w * 0.19, h * 0.228)
      ..cubicTo(
        cx - w * 0.22,
        h * 0.30,
        cx - w * 0.20,
        h * 0.38,
        cx - w * 0.155,
        h * 0.46,
      )
      ..lineTo(cx + w * 0.155, h * 0.46)
      ..cubicTo(
        cx + w * 0.20,
        h * 0.38,
        cx + w * 0.22,
        h * 0.30,
        cx + w * 0.19,
        h * 0.228,
      )
      ..close();

    if (top != null) {
      final c1 = top!.primaryColor;
      final c2 = top!.accentColor ?? c1.withValues(alpha: 0.75);
      canvas.drawPath(
        torsoPath,
        Paint()
          ..shader =
              LinearGradient(
                colors: [c1, c2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromLTWH(cx - w * 0.22, h * 0.228, w * 0.44, h * 0.232),
              ),
      );
      // Fabric shading
      canvas.drawPath(
        torsoPath,
        Paint()
          ..shader =
              LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.06),
                ],
                stops: const [0, 0.5, 1],
              ).createShader(
                Rect.fromLTWH(cx - w * 0.22, h * 0.228, w * 0.44, h * 0.232),
              ),
      );

      // Neckline
      final isTurtle = top!.name.toLowerCase().contains('turtleneck');
      if (isTurtle) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx, h * 0.238),
              width: w * 0.18,
              height: h * 0.028,
            ),
            Radius.circular(w * 0.04),
          ),
          Paint()..color = c1,
        );
      } else {
        final vPath = Path()
          ..moveTo(cx - w * 0.06, h * 0.228)
          ..lineTo(cx, h * 0.268)
          ..lineTo(cx + w * 0.06, h * 0.228);
        canvas.drawPath(
          vPath,
          Paint()
            ..color = Colors.black.withValues(alpha: 0.12)
            ..strokeWidth = w * 0.012
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    } else {
      canvas.drawPath(
        torsoPath,
        _skinPaint(
          Rect.fromLTWH(cx - w * 0.22, h * 0.228, w * 0.44, h * 0.232),
        ),
      );
    }
  }

  // ── BOTTOM ─────────────────────────────────────────────────────────────────
  void _drawBottom(Canvas canvas, double w, double h, double cx) {
    final isSkirt = bottom?.name.toLowerCase().contains('skirt') ?? false;

    if (bottom != null) {
      final c1 = bottom!.primaryColor;
      final c2 = bottom!.accentColor ?? c1.withValues(alpha: 0.75);
      final grad =
          LinearGradient(
            colors: [c1, c2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(cx - w * 0.22, h * 0.46, w * 0.44, h * 0.15),
          );

      if (isSkirt) {
        final skirtPath = Path()
          ..moveTo(cx - w * 0.155, h * 0.46)
          ..lineTo(cx + w * 0.155, h * 0.46)
          ..cubicTo(
            cx + w * 0.22,
            h * 0.50,
            cx + w * 0.26,
            h * 0.56,
            cx + w * 0.24,
            h * 0.61,
          )
          ..lineTo(cx - w * 0.24, h * 0.61)
          ..cubicTo(
            cx - w * 0.26,
            h * 0.56,
            cx - w * 0.22,
            h * 0.50,
            cx - w * 0.155,
            h * 0.46,
          )
          ..close();
        canvas.drawPath(skirtPath, Paint()..shader = grad);
        // Waistband
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - w * 0.16, h * 0.458, w * 0.32, h * 0.018),
            Radius.circular(w * 0.01),
          ),
          Paint()..color = c1.withValues(alpha: 0.9),
        );
      } else {
        // Pants hips
        final hipPath = Path()
          ..moveTo(cx - w * 0.155, h * 0.46)
          ..lineTo(cx + w * 0.155, h * 0.46)
          ..lineTo(cx + w * 0.175, h * 0.61)
          ..lineTo(cx - w * 0.175, h * 0.61)
          ..close();
        canvas.drawPath(hipPath, Paint()..shader = grad);
        // Waistband
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - w * 0.16, h * 0.458, w * 0.32, h * 0.018),
            Radius.circular(w * 0.01),
          ),
          Paint()..color = c1.withValues(alpha: 0.9),
        );
        // Center seam
        canvas.drawLine(
          Offset(cx, h * 0.476),
          Offset(cx, h * 0.61),
          Paint()
            ..color = Colors.black.withValues(alpha: 0.1)
            ..strokeWidth = w * 0.008,
        );
      }
    } else {
      // Skin
      final skinPath = Path()
        ..moveTo(cx - w * 0.155, h * 0.46)
        ..lineTo(cx + w * 0.155, h * 0.46)
        ..lineTo(cx + w * 0.175, h * 0.61)
        ..lineTo(cx - w * 0.175, h * 0.61)
        ..close();
      canvas.drawPath(
        skinPath,
        _skinPaint(Rect.fromLTWH(cx - w * 0.18, h * 0.46, w * 0.36, h * 0.15)),
      );
    }
  }

  // ── LEGS ───────────────────────────────────────────────────────────────────
  void _drawLegs(Canvas canvas, double w, double h, double cx) {
    final isSkirt = bottom?.name.toLowerCase().contains('skirt') ?? false;
    final isPants = bottom != null && !isSkirt;

    final legTop = h * 0.61;
    final legBot = h * 0.885;
    final legW = w * 0.115;
    final gap = w * 0.018;

    // Left leg
    final lPath = Path()
      ..moveTo(cx - gap - legW, legTop)
      ..lineTo(cx - gap, legTop)
      ..cubicTo(
        cx - gap + w * 0.01,
        legTop + h * 0.05,
        cx - gap + w * 0.01,
        legBot - h * 0.05,
        cx - gap,
        legBot,
      )
      ..lineTo(cx - gap - legW, legBot)
      ..cubicTo(
        cx - gap - legW - w * 0.01,
        legBot - h * 0.05,
        cx - gap - legW - w * 0.01,
        legTop + h * 0.05,
        cx - gap - legW,
        legTop,
      )
      ..close();

    // Right leg
    final rPath = Path()
      ..moveTo(cx + gap, legTop)
      ..lineTo(cx + gap + legW, legTop)
      ..cubicTo(
        cx + gap + legW + w * 0.01,
        legTop + h * 0.05,
        cx + gap + legW + w * 0.01,
        legBot - h * 0.05,
        cx + gap + legW,
        legBot,
      )
      ..lineTo(cx + gap, legBot)
      ..cubicTo(
        cx + gap - w * 0.01,
        legBot - h * 0.05,
        cx + gap - w * 0.01,
        legTop + h * 0.05,
        cx + gap,
        legTop,
      )
      ..close();

    final legRect = Rect.fromLTWH(
      cx - gap - legW - w * 0.01,
      legTop,
      (legW + gap) * 2 + w * 0.02,
      legBot - legTop,
    );

    if (isPants) {
      final c1 = bottom!.primaryColor;
      final c2 = bottom!.accentColor ?? c1.withValues(alpha: 0.75);
      final grad = LinearGradient(
        colors: [c1, c2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(legRect);
      canvas.drawPath(lPath, Paint()..shader = grad);
      canvas.drawPath(rPath, Paint()..shader = grad);
      // Seam lines
      canvas.drawLine(
        Offset(cx - gap - legW * 0.5, legTop),
        Offset(cx - gap - legW * 0.5, legBot),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.08)
          ..strokeWidth = w * 0.006,
      );
      canvas.drawLine(
        Offset(cx + gap + legW * 0.5, legTop),
        Offset(cx + gap + legW * 0.5, legBot),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.08)
          ..strokeWidth = w * 0.006,
      );
    } else {
      canvas.drawPath(lPath, _skinPaint(legRect));
      canvas.drawPath(rPath, _skinPaint(legRect));
      // Knee highlights
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            cx - gap - legW * 0.5,
            legTop + (legBot - legTop) * 0.48,
          ),
          width: legW * 0.55,
          height: h * 0.022,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            cx + gap + legW * 0.5,
            legTop + (legBot - legTop) * 0.48,
          ),
          width: legW * 0.55,
          height: h * 0.022,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );
    }
  }

  // ── SHOES ──────────────────────────────────────────────────────────────────
  void _drawShoes(Canvas canvas, double w, double h, double cx) {
    final c1 = shoes?.primaryColor ?? const Color(0xFF9E9E9E);
    final c2 = shoes?.accentColor ?? c1.withValues(alpha: 0.7);
    final isHeel = shoes?.name.toLowerCase().contains('heel') ?? false;
    final isBoot = shoes?.name.toLowerCase().contains('boot') ?? false;

    final gap = w * 0.018;
    final legW = w * 0.115;
    final shoeTop = h * 0.885;
    final shoeBot = h * 1.0;
    final shoeW = legW * 1.35;

    final shoeRect = Rect.fromLTWH(
      cx - gap - shoeW - w * 0.01,
      shoeTop,
      (shoeW + gap) * 2 + w * 0.02,
      shoeBot - shoeTop,
    );
    final grad = LinearGradient(
      colors: [c1, c2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(shoeRect);

    // Left shoe
    _drawOneSide(
      canvas,
      w,
      h,
      cx - gap - legW * 0.5,
      shoeTop,
      shoeBot,
      shoeW,
      grad,
      c1,
      isHeel,
      isBoot,
      true,
    );
    // Right shoe
    _drawOneSide(
      canvas,
      w,
      h,
      cx + gap + legW * 0.5,
      shoeTop,
      shoeBot,
      shoeW,
      grad,
      c1,
      isHeel,
      isBoot,
      false,
    );
  }

  void _drawOneSide(
    Canvas canvas,
    double w,
    double h,
    double cx,
    double top,
    double bot,
    double sw,
    Shader grad,
    Color c1,
    bool isHeel,
    bool isBoot,
    bool isLeft,
  ) {
    final shoeH = bot - top;

    if (isBoot) {
      // Boot shaft (goes up)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            cx - sw * 0.42,
            top - shoeH * 0.7,
            sw * 0.84,
            shoeH * 0.75,
          ),
          Radius.circular(w * 0.02),
        ),
        Paint()..shader = grad,
      );
    }

    // Shoe body
    final shoePath = Path()
      ..moveTo(cx - sw * 0.5, top)
      ..lineTo(cx + sw * 0.5, top)
      ..cubicTo(
        cx + sw * 0.55,
        top + shoeH * 0.5,
        cx + sw * (isLeft ? 0.7 : 0.5),
        bot,
        cx + sw * (isLeft ? 0.65 : 0.45),
        bot,
      )
      ..lineTo(cx - sw * (isLeft ? 0.45 : 0.65), bot)
      ..cubicTo(
        cx - sw * (isLeft ? 0.5 : 0.7),
        bot,
        cx - sw * 0.55,
        top + shoeH * 0.5,
        cx - sw * 0.5,
        top,
      )
      ..close();
    canvas.drawPath(shoePath, Paint()..shader = grad);

    // Heel
    if (isHeel) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            isLeft ? cx - sw * 0.48 : cx + sw * 0.28,
            top,
            sw * 0.18,
            shoeH * 1.3,
          ),
          Radius.circular(w * 0.01),
        ),
        Paint()..color = c1,
      );
    }

    // Sole
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cx - sw * 0.52,
          bot - shoeH * 0.14,
          sw * 1.04,
          shoeH * 0.14,
        ),
        Radius.circular(w * 0.01),
      ),
      Paint()..color = c1.withValues(alpha: 0.55),
    );

    // Shine
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, top + shoeH * 0.3),
        width: sw * 0.38,
        height: shoeH * 0.15,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );
  }

  // ── HEAD ───────────────────────────────────────────────────────────────────
  void _drawHead(Canvas canvas, double w, double h, double cx) {
    final headRect = Rect.fromLTWH(
      cx - w * 0.21,
      h * 0.01,
      w * 0.42,
      h * 0.175,
    );

    // Face shape — slightly oval, narrower at chin
    final facePath = Path()
      ..moveTo(cx, h * 0.01)
      ..cubicTo(
        cx + w * 0.21,
        h * 0.01,
        cx + w * 0.21,
        h * 0.09,
        cx + w * 0.19,
        h * 0.12,
      )
      ..cubicTo(
        cx + w * 0.17,
        h * 0.16,
        cx + w * 0.10,
        h * 0.185,
        cx,
        h * 0.185,
      )
      ..cubicTo(
        cx - w * 0.10,
        h * 0.185,
        cx - w * 0.17,
        h * 0.16,
        cx - w * 0.19,
        h * 0.12,
      )
      ..cubicTo(cx - w * 0.21, h * 0.09, cx - w * 0.21, h * 0.01, cx, h * 0.01)
      ..close();

    canvas.drawPath(
      facePath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.3),
          radius: 0.9,
          colors: [const Color(0xFFFAD4B0), _skin, _skinMid],
        ).createShader(headRect),
    );

    // Side shadow
    canvas.drawPath(
      facePath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _skinDark.withValues(alpha: 0.28),
            Colors.transparent,
            _skinDark.withValues(alpha: 0.28),
          ],
          stops: const [0, 0.45, 1],
        ).createShader(headRect),
    );

    // Forehead highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.03, h * 0.055),
        width: w * 0.22,
        height: h * 0.055,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.12),
    );

    // Ears
    final earPaint = Paint()..color = _skinMid;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.21, h * 0.105),
        width: w * 0.038,
        height: h * 0.038,
      ),
      earPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + w * 0.21, h * 0.105),
        width: w * 0.038,
        height: h * 0.038,
      ),
      earPaint,
    );
  }

  // ── HAIR FRONT ─────────────────────────────────────────────────────────────
  void _drawHairFront(Canvas canvas, double w, double h, double cx) {
    final hairPaint = Paint()
      ..shader = LinearGradient(
        colors: [_hairDark, _hairMid],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(cx - w * 0.22, 0, w * 0.44, h * 0.12));

    // Top of head / crown
    final crownPath = Path()
      ..moveTo(cx - w * 0.19, h * 0.04)
      ..cubicTo(cx - w * 0.20, h * 0.01, cx - w * 0.05, 0, cx, 0)
      ..cubicTo(
        cx + w * 0.05,
        0,
        cx + w * 0.20,
        h * 0.01,
        cx + w * 0.19,
        h * 0.04,
      )
      ..cubicTo(
        cx + w * 0.21,
        h * 0.07,
        cx + w * 0.21,
        h * 0.09,
        cx + w * 0.195,
        h * 0.10,
      )
      ..lineTo(cx - w * 0.195, h * 0.10)
      ..cubicTo(
        cx - w * 0.21,
        h * 0.09,
        cx - w * 0.21,
        h * 0.07,
        cx - w * 0.19,
        h * 0.04,
      )
      ..close();
    canvas.drawPath(crownPath, hairPaint);

    // Left side hair (covers ear)
    final lSidePath = Path()
      ..moveTo(cx - w * 0.19, h * 0.04)
      ..cubicTo(
        cx - w * 0.22,
        h * 0.07,
        cx - w * 0.225,
        h * 0.11,
        cx - w * 0.215,
        h * 0.145,
      )
      ..lineTo(cx - w * 0.175, h * 0.145)
      ..cubicTo(
        cx - w * 0.185,
        h * 0.11,
        cx - w * 0.185,
        h * 0.07,
        cx - w * 0.19,
        h * 0.04,
      )
      ..close();
    canvas.drawPath(lSidePath, hairPaint);

    // Right side hair
    final rSidePath = Path()
      ..moveTo(cx + w * 0.19, h * 0.04)
      ..cubicTo(
        cx + w * 0.22,
        h * 0.07,
        cx + w * 0.225,
        h * 0.11,
        cx + w * 0.215,
        h * 0.145,
      )
      ..lineTo(cx + w * 0.175, h * 0.145)
      ..cubicTo(
        cx + w * 0.185,
        h * 0.11,
        cx + w * 0.185,
        h * 0.07,
        cx + w * 0.19,
        h * 0.04,
      )
      ..close();
    canvas.drawPath(rSidePath, hairPaint);

    // Hair highlight
    final hlPaint = Paint()..color = _hairHL.withValues(alpha: 0.45);
    final hlPath = Path()
      ..moveTo(cx - w * 0.06, h * 0.005)
      ..cubicTo(
        cx - w * 0.02,
        h * 0.005,
        cx + w * 0.04,
        h * 0.015,
        cx + w * 0.06,
        h * 0.04,
      )
      ..cubicTo(cx + w * 0.04, h * 0.055, cx, h * 0.06, cx - w * 0.04, h * 0.05)
      ..cubicTo(
        cx - w * 0.06,
        h * 0.04,
        cx - w * 0.08,
        h * 0.02,
        cx - w * 0.06,
        h * 0.005,
      )
      ..close();
    canvas.drawPath(hlPath, hlPaint);
  }

  // ── FACE DETAILS ───────────────────────────────────────────────────────────
  void _drawFace(Canvas canvas, double w, double h, double cx) {
    // Eyebrow Y
    final browY = h * 0.088;
    final eyeY = h * 0.108;
    final noseY = h * 0.135;
    final lipY = h * 0.158;

    // ── Eyebrows ──
    final browPaint = Paint()
      ..color = _hairDark
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.14, browY)
        ..quadraticBezierTo(
          cx - w * 0.09,
          browY - h * 0.008,
          cx - w * 0.04,
          browY + h * 0.002,
        ),
      browPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx + w * 0.04, browY + h * 0.002)
        ..quadraticBezierTo(
          cx + w * 0.09,
          browY - h * 0.008,
          cx + w * 0.14,
          browY,
        ),
      browPaint,
    );

    // ── Eyes ──
    _drawEye(canvas, w, h, cx - w * 0.09, eyeY, w * 0.075);
    _drawEye(canvas, w, h, cx + w * 0.09, eyeY, w * 0.075);

    // ── Nose ──
    final nosePaint = Paint()
      ..color = _skinDark.withValues(alpha: 0.5)
      ..strokeWidth = w * 0.012
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.025, noseY - h * 0.012)
        ..quadraticBezierTo(
          cx - w * 0.04,
          noseY,
          cx - w * 0.03,
          noseY + h * 0.004,
        )
        ..quadraticBezierTo(
          cx,
          noseY + h * 0.007,
          cx + w * 0.03,
          noseY + h * 0.004,
        )
        ..quadraticBezierTo(
          cx + w * 0.04,
          noseY,
          cx + w * 0.025,
          noseY - h * 0.012,
        ),
      nosePaint,
    );

    // ── Cheeks ──
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.135, eyeY + h * 0.025),
        width: w * 0.12,
        height: h * 0.025,
      ),
      Paint()..color = const Color(0xFFFFB3BA).withValues(alpha: 0.38),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + w * 0.135, eyeY + h * 0.025),
        width: w * 0.12,
        height: h * 0.025,
      ),
      Paint()..color = const Color(0xFFFFB3BA).withValues(alpha: 0.38),
    );

    // ── Lips ──
    final lipW = w * 0.10;
    final lipH = h * 0.012;

    // Upper lip
    final upperLip = Path()
      ..moveTo(cx - lipW, lipY)
      ..quadraticBezierTo(
        cx - lipW * 0.5,
        lipY - lipH * 1.1,
        cx,
        lipY - lipH * 0.4,
      )
      ..quadraticBezierTo(cx + lipW * 0.5, lipY - lipH * 1.1, cx + lipW, lipY)
      ..quadraticBezierTo(cx, lipY + lipH * 0.5, cx - lipW, lipY);
    canvas.drawPath(
      upperLip,
      Paint()..color = const Color(0xFFE91E63).withValues(alpha: 0.88),
    );

    // Lower lip
    final lowerLip = Path()
      ..moveTo(cx - lipW, lipY)
      ..quadraticBezierTo(cx, lipY + lipH * 2.0, cx + lipW, lipY)
      ..quadraticBezierTo(cx, lipY + lipH * 0.5, cx - lipW, lipY);
    canvas.drawPath(lowerLip, Paint()..color = const Color(0xFFC2185B));

    // Lip highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, lipY + lipH * 0.7),
        width: lipW * 0.5,
        height: lipH * 0.4,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.22),
    );
  }

  void _drawEye(
    Canvas canvas,
    double w,
    double h,
    double cx,
    double cy,
    double r,
  ) {
    // Eye white
    final eyePath = Path()
      ..moveTo(cx - r, cy)
      ..quadraticBezierTo(cx, cy - r * 0.72, cx + r, cy)
      ..quadraticBezierTo(cx, cy + r * 0.72, cx - r, cy);
    canvas.drawPath(eyePath, Paint()..color = Colors.white);

    // Iris
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.58,
      Paint()..color = const Color(0xFF5D4037),
    );
    // Pupil
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.32,
      Paint()..color = const Color(0xFF1A0A00),
    );
    // Shine
    canvas.drawCircle(
      Offset(cx + r * 0.18, cy - r * 0.22),
      r * 0.16,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );

    // Upper lid line
    canvas.drawPath(
      Path()
        ..moveTo(cx - r, cy)
        ..quadraticBezierTo(cx, cy - r * 0.78, cx + r, cy),
      Paint()
        ..color = const Color(0xFF1A0A00)
        ..strokeWidth = r * 0.22
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Eyelashes
    final lashPaint = Paint()
      ..color = const Color(0xFF1A0A00)
      ..strokeWidth = r * 0.13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 5; i++) {
      final t = i / 4.0;
      final lx = cx - r + t * r * 2;
      final ly = cy - r * 0.72 * (1 - (t - 0.5).abs() * 0.6);
      canvas.drawLine(
        Offset(lx, ly),
        Offset(lx - (t - 0.5) * r * 0.35, ly - r * 0.38),
        lashPaint,
      );
    }
  }

  // ── ACCESSORIES ────────────────────────────────────────────────────────────
  void _drawAccessory(Canvas canvas, double w, double h, double cx) {
    final name = acc!.name.toLowerCase();
    final c1 = acc!.primaryColor;

    if (name.contains('sunglass')) {
      // Sunglasses on face
      final glassY = h * 0.108;
      final glassW = w * 0.085;
      final glassH = h * 0.028;
      final frameColor = c1;
      final lensColor = c1.withValues(alpha: 0.75);

      // Bridge
      canvas.drawLine(
        Offset(cx - w * 0.01, glassY),
        Offset(cx + w * 0.01, glassY),
        Paint()
          ..color = frameColor
          ..strokeWidth = w * 0.012
          ..strokeCap = StrokeCap.round,
      );

      // Left lens
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx - w * 0.09, glassY),
            width: glassW * 2,
            height: glassH * 2,
          ),
          Radius.circular(w * 0.02),
        ),
        Paint()..color = lensColor,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx - w * 0.09, glassY),
            width: glassW * 2,
            height: glassH * 2,
          ),
          Radius.circular(w * 0.02),
        ),
        Paint()
          ..color = frameColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.012,
      );

      // Right lens
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx + w * 0.09, glassY),
            width: glassW * 2,
            height: glassH * 2,
          ),
          Radius.circular(w * 0.02),
        ),
        Paint()..color = lensColor,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx + w * 0.09, glassY),
            width: glassW * 2,
            height: glassH * 2,
          ),
          Radius.circular(w * 0.02),
        ),
        Paint()
          ..color = frameColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.012,
      );

      // Arms
      canvas.drawLine(
        Offset(cx - w * 0.175, glassY),
        Offset(cx - w * 0.21, glassY + h * 0.008),
        Paint()
          ..color = frameColor
          ..strokeWidth = w * 0.012
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(
        Offset(cx + w * 0.175, glassY),
        Offset(cx + w * 0.21, glassY + h * 0.008),
        Paint()
          ..color = frameColor
          ..strokeWidth = w * 0.012
          ..strokeCap = StrokeCap.round,
      );
    } else if (name.contains('necklace')) {
      // Necklace at collarbone
      final neckY = h * 0.222;
      final necklacePath = Path()
        ..moveTo(cx - w * 0.12, neckY)
        ..quadraticBezierTo(cx, neckY + h * 0.022, cx + w * 0.12, neckY);
      canvas.drawPath(
        necklacePath,
        Paint()
          ..color = c1
          ..strokeWidth = w * 0.018
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      // Pendant
      canvas.drawCircle(
        Offset(cx, neckY + h * 0.022),
        w * 0.022,
        Paint()..color = c1,
      );
      canvas.drawCircle(
        Offset(cx, neckY + h * 0.022),
        w * 0.013,
        Paint()..color = c1.withValues(alpha: 0.6),
      );
    } else if (name.contains('bag')) {
      // Handbag on right side
      final bagX = cx + w * 0.32;
      final bagY = h * 0.38;
      final bagW = w * 0.18;
      final bagH = h * 0.12;
      final c2 = acc!.accentColor ?? c1.withValues(alpha: 0.7);

      // Strap
      canvas.drawPath(
        Path()
          ..moveTo(bagX - bagW * 0.3, bagY)
          ..quadraticBezierTo(bagX, bagY - bagH * 0.5, bagX + bagW * 0.3, bagY),
        Paint()
          ..color = c1
          ..strokeWidth = w * 0.018
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      // Body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(bagX, bagY + bagH * 0.5),
            width: bagW,
            height: bagH,
          ),
          Radius.circular(w * 0.025),
        ),
        Paint()
          ..shader =
              LinearGradient(
                colors: [c1, c2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromCenter(
                  center: Offset(bagX, bagY + bagH * 0.5),
                  width: bagW,
                  height: bagH,
                ),
              ),
      );
      // Clasp
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(bagX, bagY + bagH * 0.08),
            width: bagW * 0.28,
            height: bagH * 0.14,
          ),
          Radius.circular(w * 0.01),
        ),
        Paint()..color = c2.withValues(alpha: 0.7),
      );
    }
  }

  // ── HELPERS ────────────────────────────────────────────────────────────────
  Paint _skinPaint(Rect rect) => Paint()
    ..shader = LinearGradient(
      colors: [_skinDark, _skin, _skin, _skinDark],
      stops: const [0.0, 0.22, 0.78, 1.0],
    ).createShader(rect);

  @override
  bool shouldRepaint(_FashionModelPainter old) =>
      old.top != top ||
      old.bottom != bottom ||
      old.shoes != shoes ||
      old.acc != acc;
}

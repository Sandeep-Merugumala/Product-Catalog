import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ThemeAnimator extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const ThemeAnimator({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 4200),
  });

  static ThemeAnimatorState of(BuildContext context) {
    final state = context.findAncestorStateOfType<ThemeAnimatorState>();
    if (state == null) {
      throw FlutterError(
        'ThemeAnimator.of() called with a context that does not contain a ThemeAnimator.',
      );
    }
    return state;
  }

  @override
  State<ThemeAnimator> createState() => ThemeAnimatorState();
}

class _Particle {
  double x;
  double size;
  double speed;
  double angle;
  double rotationSpeed;
  int type; // 0 heart, 1 sparkle, 2 dot

  _Particle()
    : x = Random().nextDouble(),
      size = Random().nextDouble() * 12 + 6,
      speed = Random().nextDouble() * 0.8 + 0.6,
      angle = Random().nextDouble() * 2 * pi,
      rotationSpeed = (Random().nextDouble() - 0.5) * 2,
      type = Random().nextInt(3);
}

class ThemeAnimatorState extends State<ThemeAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  ui.Image? _oldThemeImage;
  final GlobalKey _repaintKey = GlobalKey();
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart, // 🔥 smoother cinematic curve
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _oldThemeImage = null;
          _particles.clear();
        });
        _controller.reset();
      }
    });
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 120; i++) {
      _particles.add(_Particle());
    }
  }

  Future<void> changeTheme(VoidCallback onUpdate) async {
    try {
      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary != null && !boundary.debugNeedsPaint) {
        final image = await boundary.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
        );

        setState(() {
          _oldThemeImage = image;
          _generateParticles();
        });
      }
    } catch (e) {
      debugPrint("Screenshot error: $e");
    }

    onUpdate();
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(key: _repaintKey, child: widget.child),
          if (_oldThemeImage != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _UltraThemePainter(
                      image: _oldThemeImage!,
                      progress: _animation.value,
                      particles: _particles,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _UltraThemePainter extends CustomPainter {
  final ui.Image image;
  final double progress;
  final List<_Particle> particles;
  final bool isDark;

  _UltraThemePainter({
    required this.image,
    required this.progress,
    required this.particles,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cutoffY = size.height * progress;
    final amplitude = 28.0;
    final waveLength = size.width;

    double getWaveY(double x) {
      double phase = progress * 2 * pi;
      return cutoffY + amplitude * sin((x / waveLength * 2 * pi) + phase);
    }

    // Flash burst
    if (progress < 0.08) {
      final flashOpacity = (1 - (progress / 0.08));
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = (isDark ? Colors.white : Colors.black).withOpacity(
            flashOpacity * 0.2,
          ),
      );
    }

    // Blur old theme
    canvas.saveLayer(
      Offset.zero & size,
      Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: 5 * progress,
          sigmaY: 5 * progress,
        ),
    );

    Path clipPath = Path();
    clipPath.moveTo(0, size.height);
    clipPath.lineTo(0, getWaveY(0));

    for (double x = 0; x <= size.width; x += 5) {
      clipPath.lineTo(x, getWaveY(x));
    }

    clipPath.lineTo(size.width, size.height);
    clipPath.close();

    canvas.save();
    canvas.clipPath(clipPath);

    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: image,
      fit: BoxFit.cover,
    );

    canvas.restore();
    canvas.restore();

    // Glow behind wave
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, cutoffY),
        size.width * 0.5,
        [
          (isDark ? Colors.white : Colors.black).withOpacity(
            0.12 * (1 - progress),
          ),
          Colors.transparent,
        ],
        [0.0, 1.0],
      );

    canvas.drawCircle(
      Offset(size.width / 2, cutoffY),
      size.width * 0.5,
      glowPaint,
    );

    // Glowing border
    Path borderPath = Path();
    borderPath.moveTo(0, getWaveY(0));
    for (double x = 0; x <= size.width; x += 5) {
      borderPath.lineTo(x, getWaveY(x));
    }

    final borderPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, cutoffY - 30),
        Offset(0, cutoffY + 30),
        [
          Colors.transparent,
          (isDark ? Colors.white : Colors.black).withOpacity(0.85),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(borderPath, borderPaint);

    // 🌊 PARTICLES FOLLOW THE WAVE
    if (progress > 0 && progress < 1.0) {
      for (var p in particles) {
        final px = p.x * size.width;
        final waveY = getWaveY(px);

        // Only activate once wave passes this X
        if (cutoffY < waveY - 2) continue;

        final localProgress = ((cutoffY - waveY) / size.height).clamp(0.0, 1.0);

        final gravity = 650.0;
        final fallDistance = 0.5 * gravity * localProgress * localProgress;

        final py = waveY + fallDistance * p.speed;

        if (py > size.height + 60) continue;

        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(p.angle + localProgress * p.rotationSpeed);

        final opacity = (0.85 * (1 - localProgress)).clamp(0.0, 1.0);

        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = p.type == 0
              ? const Color(0xFFFF3F6C).withOpacity(opacity)
              : p.type == 1
              ? (isDark ? Colors.cyanAccent : Colors.amberAccent).withOpacity(
                  opacity,
                )
              : HSLColor.fromAHSL(opacity, p.x * 360, 0.8, 0.6).toColor();

        if (p.type == 0) {
          _drawHeart(canvas, paint, p.size);
        } else if (p.type == 1) {
          _drawSparkle(canvas, paint, p.size);
        } else {
          canvas.drawCircle(Offset.zero, p.size / 3, paint);
        }

        canvas.restore();
      }
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final s = size * 0.5;

    path.moveTo(0, s);
    path.cubicTo(-s, -s * 0.3, -s * 1.4, s * 0.6, 0, s * 1.6);
    path.cubicTo(s * 1.4, s * 0.6, s, -s * 0.3, 0, s);

    canvas.drawPath(path, paint);
  }

  void _drawSparkle(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final h = size * 0.6;
    final q = size * 0.2;

    path.moveTo(0, -h);
    path.quadraticBezierTo(q, -q, h, 0);
    path.quadraticBezierTo(q, q, 0, h);
    path.quadraticBezierTo(-q, q, -h, 0);
    path.quadraticBezierTo(-q, -q, 0, -h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UltraThemePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.image != image;
  }
}

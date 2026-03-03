import 'dart:math';
import 'package:flutter/material.dart';

enum ParticleType { snow, sparkle }

class ParticleOverlay extends StatefulWidget {
  final ParticleType type;

  const ParticleOverlay({super.key, required this.type});

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            _updateParticles();
          })
          ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initParticles(context.size ?? const Size(400, 800));
    });
  }

  void _initParticles(Size size) {
    int count = widget.type == ParticleType.snow ? 60 : 35;
    for (int i = 0; i < count; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          size:
              _random.nextDouble() *
                  (widget.type == ParticleType.snow ? 3 : 5) +
              2,
          speed: _random.nextDouble() * 2 + 1,
          angle: _random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  void _updateParticles() {
    final size = context.size ?? const Size(400, 800);
    for (var particle in _particles) {
      if (widget.type == ParticleType.snow) {
        // Snow falling down
        particle.y += particle.speed;
        particle.x += sin(particle.angle) * 0.5;
        particle.angle += 0.02;

        if (particle.y > size.height) {
          particle.y = -particle.size;
          particle.x = _random.nextDouble() * size.width;
        }
      } else {
        // Sparkles floating upwards
        particle.y -= particle.speed * 0.4;
        particle.x += sin(particle.angle) * 0.3;
        particle.angle += 0.05;

        if (particle.y < -particle.size) {
          particle.y = size.height + particle.size;
          particle.x = _random.nextDouble() * size.width;
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: ParticlePainter(particles: _particles, type: widget.type),
        child: Container(),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double angle;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final ParticleType type;

  ParticlePainter({required this.particles, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint();
      if (type == ParticleType.snow) {
        paint.color = Colors.white.withValues(alpha: 0.8);
        canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
      } else {
        // Gold shimmering sparkles for wedding season
        double shimmer = 0.5 + sin(p.angle) * 0.5; // pulses between 0 and 1
        paint.color = const Color(
          0xFFFFD700,
        ).withValues(alpha: 0.3 + shimmer * 0.5);

        // Draw a neat 4-point star/sparkle shape
        final path = Path();
        path.moveTo(p.x, p.y - p.size);
        path.quadraticBezierTo(p.x, p.y, p.x + p.size, p.y);
        path.quadraticBezierTo(p.x, p.y, p.x, p.y + p.size);
        path.quadraticBezierTo(p.x, p.y, p.x - p.size, p.y);
        path.quadraticBezierTo(p.x, p.y, p.x, p.y - p.size);
        path.close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

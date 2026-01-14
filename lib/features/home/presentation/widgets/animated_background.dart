import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFF5F7FA),
          const Color(0xFFE8ECF1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      bgPaint,
    );

    // Floating circles
    final circles = [
      _Circle(0.1, 0.2, 100, const Color(0xFF6C63FF)),
      _Circle(0.8, 0.3, 80, const Color(0xFF00D9FF)),
      _Circle(0.3, 0.7, 120, const Color(0xFFFF6B6B)),
      _Circle(0.9, 0.8, 60, const Color(0xFF4ECDC4)),
    ];

    for (var circle in circles) {
      final offset = math.sin(animationValue * 2 * math.pi + circle.x * 10) * 20;
      final paint = Paint()
        ..color = circle.color.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          circle.x * size.width + offset,
          circle.y * size.height + offset * 0.5,
        ),
        circle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Circle {
  final double x;
  final double y;
  final double radius;
  final Color color;

  _Circle(this.x, this.y, this.radius, this.color);
}
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../data/models/sign_animation_data.dart';

class AnimatedAvatar extends StatefulWidget {
  final SignAnimationInfo? currentSign;
  final bool isPlaying;
  final double speed;
  final VoidCallback? onAnimationComplete;

  const AnimatedAvatar({
    super.key,
    this.currentSign,
    this.isPlaying = false,
    this.speed = 1.0,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStepIndex = 0;

  // Right hand
  double _rightHandX = 0.5;
  double _rightHandY = 0.5;
  double _rightHandRotation = 0;
  String _rightHandFingers = 'open';

  // Left hand
  double _leftHandX = 0.5;
  double _leftHandY = 0.5;
  double _leftHandRotation = 0;
  String _leftHandFingers = 'open';
  bool _showLeftHand = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant AnimatedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentSign != oldWidget.currentSign) {
      _resetAnimation();
      if (widget.isPlaying && widget.currentSign != null) {
        _playAnimation();
      }
    } else if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _playAnimation() : _controller.stop();
    }
  }

  void _resetAnimation() {
    _currentStepIndex = 0;
    _rightHandX = 0.5;
    _rightHandY = 0.5;
    _rightHandRotation = 0;
    _rightHandFingers = 'open';
    _showLeftHand = false;
    _controller.reset();
  }

  Future<void> _playAnimation() async {
    if (widget.currentSign == null) return;

    final steps = widget.currentSign!.steps;

    for (int i = 0; i < steps.length; i++) {
      if (!widget.isPlaying) break;

      _currentStepIndex = i;
      final step = steps[i];

      final duration = Duration(
        milliseconds: (step.duration / widget.speed).round(),
      );

      _controller.duration = duration;

      setState(() {
        if (step.rightHand != null) {
          _rightHandX = step.rightHand!.x;
          _rightHandY = step.rightHand!.y;
          _rightHandRotation = step.rightHand!.rotation;
          _rightHandFingers = step.rightHand!.fingers;
        }

        if (step.leftHand != null) {
          _showLeftHand = true;
          _leftHandX = step.leftHand!.x;
          _leftHandY = step.leftHand!.y;
          _leftHandRotation = step.leftHand!.rotation;
          _leftHandFingers = step.leftHand!.fingers;
        } else {
          _showLeftHand = false;
        }
      });

      _controller.forward(from: 0);
      await Future.delayed(duration);
    }

    widget.onAnimationComplete?.call();
  }

  void _onAnimationStatus(AnimationStatus status) {}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.grey.shade100],
              ),
            ),
          ),

          Center(child: _buildAvatarBody()),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  _buildAnimatedHand(
                    isRight: true,
                    x: _rightHandX,
                    y: _rightHandY,
                    rotation: _rightHandRotation,
                    fingers: _rightHandFingers,
                  ),
                  if (_showLeftHand)
                    _buildAnimatedHand(
                      isRight: false,
                      x: _leftHandX,
                      y: _leftHandY,
                      rotation: _leftHandRotation,
                      fingers: _leftHandFingers,
                    ),
                ],
              );
            },
          ),

          if (widget.currentSign == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sign_language,
                      size: 80, color: AppColors.grey300),
                  const SizedBox(height: 16),
                  Text(
                    'اكتبي نص لترجمته للغة الإشارة',
                    style: TextStyle(
                      color: AppColors.grey500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarBody() {
    return CustomPaint(
      size: const Size(200, 300),
      painter: AvatarBodyPainter(),
    );
  }

  Widget _buildAnimatedHand({
    required bool isRight,
    required double x,
    required double y,
    required double rotation,
    required String fingers,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final handSize = constraints.maxWidth * 0.15;

        return AnimatedPositioned(
          duration: Duration(
            milliseconds: widget.currentSign != null
                ? (widget.currentSign!.steps[_currentStepIndex].duration /
                widget.speed)
                .round()
                : 300,
          ),
          curve: Curves.easeInOut,
          left: (x * constraints.maxWidth) - (handSize / 2),
          top: (y * constraints.maxHeight) - (handSize / 2),
          child: AnimatedRotation(
            turns: rotation / 360,
            duration: const Duration(milliseconds: 300),
            child: _buildHand(
              isRight: isRight,
              fingers: fingers,
              size: handSize,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHand({
    required bool isRight,
    required String fingers,
    required double size,
  }) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
      child: CustomPaint(
        size: Size(size, size * 1.2),
        painter: HandPainter(
          fingerPosition: fingers,
          skinColor: const Color(0xFFE8B89D),
        ),
      ),
    );
  }
}



/* ===== AvatarBodyPainter + HandPainter دول الكلاسين  ===== */


// Avatar Body Painter
class AvatarBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skinColor = const Color(0xFFE8B89D);
    final shirtColor = AppColors.primary;
    final hairColor = const Color(0xFF4A3728);
    final centerX = size.width / 2;

    // Body / Shirt
    final bodyPaint = Paint()
      ..color = shirtColor
      ..style = PaintingStyle.fill;

    final bodyPath = Path()
      ..moveTo(centerX - 60, size.height * 0.45)
      ..quadraticBezierTo(
          centerX - 70, size.height * 0.6, centerX - 50, size.height)
      ..lineTo(centerX + 50, size.height)
      ..quadraticBezierTo(
          centerX + 70, size.height * 0.6, centerX + 60, size.height * 0.45)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Neck
    final neckPaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(centerX - 20, size.height * 0.35, 40, 40),
      neckPaint,
    );

    // Head
    final headPaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.22),
        width: 90,
        height: 100,
      ),
      headPaint,
    );

    // Hair
    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;

    final hairPath = Path()
      ..moveTo(centerX - 50, size.height * 0.18)
      ..quadraticBezierTo(
          centerX - 55, size.height * 0.05, centerX, size.height * 0.02)
      ..quadraticBezierTo(
          centerX + 55, size.height * 0.05, centerX + 50, size.height * 0.18)
      ..quadraticBezierTo(
          centerX + 45, size.height * 0.1, centerX, size.height * 0.08)
      ..quadraticBezierTo(
          centerX - 45, size.height * 0.1, centerX - 50, size.height * 0.18)
      ..close();

    canvas.drawPath(hairPath, hairPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 18, size.height * 0.2),
        width: 20,
        height: 14,
      ),
      eyePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 18, size.height * 0.2),
        width: 20,
        height: 14,
      ),
      eyePaint,
    );

    // Pupils
    final pupilPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(centerX - 18, size.height * 0.2), 5, pupilPaint);
    canvas.drawCircle(
        Offset(centerX + 18, size.height * 0.2), 5, pupilPaint);

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFFE57373)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(centerX - 15, size.height * 0.28)
      ..quadraticBezierTo(
          centerX, size.height * 0.34, centerX + 15, size.height * 0.28);

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Hand Painter
class HandPainter extends CustomPainter {
  final String fingerPosition;
  final Color skinColor;

  HandPainter({
    required this.fingerPosition,
    required this.skinColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = skinColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Palm
    final palmRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.15, size.height * 0.4, size.width * 0.7, size.height * 0.5),
      const Radius.circular(10),
    );
    canvas.drawRRect(palmRect, paint);
    canvas.drawRRect(palmRect, outlinePaint);

    switch (fingerPosition) {
      case 'open':
        _drawOpenHand(canvas, size, paint, outlinePaint);
        break;
      case 'fist':
        _drawFist(canvas, size, paint, outlinePaint);
        break;
      case 'thumb_up':
        _drawThumbUp(canvas, size, paint, outlinePaint);
        break;
      case 'point':
        _drawPointing(canvas, size, paint, outlinePaint);
        break;
      case 'flat':
        _drawFlatHand(canvas, size, paint, outlinePaint);
        break;
      case 'ily':
        _drawILY(canvas, size, paint, outlinePaint);
        break;
      case 'two':
        _drawTwo(canvas, size, paint, outlinePaint);
        break;
      default:
        _drawOpenHand(canvas, size, paint, outlinePaint);
    }
  }

  void _drawOpenHand(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    final fingerWidth = size.width * 0.12;
    final fingerSpacing = size.width * 0.14;
    final startX = size.width * 0.15;

    for (int i = 0; i < 5; i++) {
      final fingerHeight =
      i == 0 ? size.height * 0.25 : size.height * 0.35;
      final x = startX + (i * fingerSpacing);
      final y = i == 0 ? size.height * 0.45 : size.height * 0.08;

      final fingerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, fingerWidth, fingerHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(fingerRect, paint);
      canvas.drawRRect(fingerRect, outlinePaint);
    }
  }

  void _drawFist(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.0, size.height * 0.45, size.width * 0.2, size.height * 0.2),
      const Radius.circular(6),
    );
    canvas.drawRRect(thumbRect, paint);
    canvas.drawRRect(thumbRect, outlinePaint);
  }

  void _drawThumbUp(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    _drawFist(canvas, size, paint, outlinePaint);

    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.0, size.height * 0.15, size.width * 0.2, size.height * 0.35),
      const Radius.circular(6),
    );
    canvas.drawRRect(thumbRect, paint);
    canvas.drawRRect(thumbRect, outlinePaint);
  }

  void _drawPointing(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    _drawFist(canvas, size, paint, outlinePaint);

    final fingerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.3, size.height * 0.05, size.width * 0.15, size.height * 0.38),
      const Radius.circular(6),
    );
    canvas.drawRRect(fingerRect, paint);
    canvas.drawRRect(fingerRect, outlinePaint);
  }

  void _drawFlatHand(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    final fingersRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.15, size.height * 0.05, size.width * 0.6, size.height * 0.38),
      const Radius.circular(8),
    );
    canvas.drawRRect(fingersRect, paint);
    canvas.drawRRect(fingersRect, outlinePaint);

    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.0, size.height * 0.35, size.width * 0.18, size.height * 0.25),
      const Radius.circular(6),
    );
    canvas.drawRRect(thumbRect, paint);
    canvas.drawRRect(thumbRect, outlinePaint);
  }

  void _drawILY(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.0, size.height * 0.15, size.width * 0.18, size.height * 0.35),
        const Radius.circular(6),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.2, size.height * 0.05, size.width * 0.12, size.height * 0.38),
        const Radius.circular(6),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.7, size.height * 0.1, size.width * 0.12, size.height * 0.32),
        const Radius.circular(6),
      ),
      paint,
    );
  }

  void _drawTwo(Canvas canvas, Size size, Paint paint, Paint outlinePaint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.25, size.height * 0.05, size.width * 0.12, size.height * 0.38),
        const Radius.circular(6),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.42, size.height * 0.03, size.width * 0.12, size.height * 0.4),
        const Radius.circular(6),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * 0.05, size.height * 0.5, size.width * 0.15, size.height * 0.2),
        const Radius.circular(6),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant HandPainter oldDelegate) {
    return fingerPosition != oldDelegate.fingerPosition;
  }
}

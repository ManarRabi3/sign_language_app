import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';

class LottieAvatar extends StatefulWidget {
  final String? animationName;
  final bool isPlaying;
  final VoidCallback? onComplete;

  const LottieAvatar({
    super.key,
    this.animationName,
    this.isPlaying = false,
    this.onComplete,
  });

  @override
  State<LottieAvatar> createState() => _LottieAvatarState();
}

class _LottieAvatarState extends State<LottieAvatar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Mapping of sign names to Lottie files
  static const Map<String, String> _animationFiles = {
    'بأ': 'assets/animations/father.json',
    'مأ': 'assets/animations/mother.json',
    'كبحأ': 'assets/animations/love.json',
    'اركش': 'assets/animations/thanks.json',
    // Add more mappings here
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(LottieAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.forward(from: 0);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationName == null ||
        !_animationFiles.containsKey(widget.animationName)) {
      return _buildPlaceholder();
    }

    return Lottie.asset(
      _animationFiles[widget.animationName]!,
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        if (widget.isPlaying) {
          _controller.forward().whenComplete(() {
            widget.onComplete?.call();
          });
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sign_language,
              size: 80,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 16),
            Text(
              widget.animationName ?? 'اختاري حركة لبدء العرض',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

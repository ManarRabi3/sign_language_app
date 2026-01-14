
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../../data/models/sign_animation_data.dart';
import 'animated_avatar.dart';

class AvatarViewer extends StatelessWidget {
  final Map<String, dynamic>? currentSign;
  final bool isPlaying;
  final double speed;
  final VoidCallback? onAnimationComplete;

  const AvatarViewer({
    super.key,
    this.currentSign,
    this.isPlaying = false,
    this.speed = 1.0,
    this.onAnimationComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Get animation data
    SignAnimationInfo? animationInfo;
    if (currentSign != null) {
      final word = currentSign!['word'] as String?;
      if (word != null) {
        animationInfo = SignAnimationData.getAnimation(word);
      }
    }

    return AnimatedAvatar(
      currentSign: animationInfo,
      isPlaying: isPlaying,
      speed: speed,
      onAnimationComplete: onAnimationComplete,
    );
  }
}
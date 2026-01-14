
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final double speed;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<double> onSpeedChanged;
  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.speed,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Speed Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<double>(
            value: speed,
            underline: const SizedBox(),
            isDense: true,
            items: const [
              DropdownMenuItem(value: 0.5, child: Text('0.5x')),
              DropdownMenuItem(value: 1.0, child: Text('1x')),
              DropdownMenuItem(value: 1.5, child: Text('1.5x')),
              DropdownMenuItem(value: 2.0, child: Text('2x')),
            ],
            onChanged: (value) {
              if (value != null) onSpeedChanged(value);
            },
          ),
        ),

        const SizedBox(width: 16),

        // Previous Button
        _ControlButton(
          icon: Icons.skip_previous,
          onPressed: canGoPrevious ? onPrevious : null,
        ),

        const SizedBox(width: 8),

        // Play/Pause Button
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPlayPause,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Next Button
        _ControlButton(
          icon: Icons.skip_next,
          onPressed: canGoNext ? onNext : null,
        ),

        const SizedBox(width: 16),

        // Repeat Toggle
        _ControlButton(
          icon: Icons.repeat,
          onPressed: () {
            // TODO: Implement repeat
          },
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ControlButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null ? AppColors.grey100 : AppColors.grey200,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null ? AppColors.grey700 : AppColors.grey300,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RecognitionResult extends StatelessWidget {
  final String sign;
  final double confidence;
  final VoidCallback onAdd;
  final VoidCallback onDismiss;

  const RecognitionResult({
    super.key,
    required this.sign,
    required this.confidence,
    required this.onAdd,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (confidence * 100).toInt();
    final isHighConfidence = confidence >= 0.8;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHighConfidence
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.orange.shade400, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isHighConfidence ? Colors.green : Colors.orange)
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Result Icon
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
// Result Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sign,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ' ةقثلا: $confidencePercent%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
// Action Buttons
          Column(
            children: [
              _MiniButton(
                icon: Icons.add,
                color: Colors.white,
                onPressed: onAdd,
              ),
              const SizedBox(height: 8),
              _MiniButton(
                icon: Icons.close,
                color: Colors.white.withOpacity(0.7),
                onPressed: onDismiss,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _MiniButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MiniButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickPhrases extends StatelessWidget {
  final Function(String) onPhraseSelected;

  const QuickPhrases({
    super.key,
    required this.onPhraseSelected,
  });

  static const List<Map<String, dynamic>> _phrases = [
    {'text': ' مرحبا', 'icon': Icons.waving_hand},
    {'text': 'شكرا ', 'icon': Icons.favorite},
    {'text': 'احبك', 'icon': Icons.favorite_border},
    {'text': 'من فضلك', 'icon': Icons.volunteer_activism},
    {'text': ' اسف', 'icon': Icons.sentiment_dissatisfied},
    {'text': ' تهانينا', 'icon': Icons.celebration},
    {'text': 'اعجبنى', 'icon': Icons.thumb_up},
    {'text': ' لم يعجبنى', 'icon': Icons.thumb_down},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' عبارات سريعة',
          style: TextStyle(
            color: AppColors.grey700,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _phrases.map((phrase) {
                return _PhraseChip(
                  text: phrase['text'],
                  icon: phrase['icon'],
                  onTap: () => onPhraseSelected(phrase['text']),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhraseChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _PhraseChip({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
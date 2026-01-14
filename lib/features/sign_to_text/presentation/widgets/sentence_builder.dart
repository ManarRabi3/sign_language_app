import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SentenceBuilder extends StatelessWidget {
  final List<String> words;
  final Function(int) onRemove;
  final VoidCallback onClear;

  const SentenceBuilder({
    super.key,
    required this.words,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.text_fields,
                      color: AppColors.grey700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    ' الجملة',
                    style: TextStyle(
                      color: AppColors.grey700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (words.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('مسح الكل'),
                  onPressed: onClear,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Words
          Expanded(
            child: words.isEmpty
                ? _buildEmptyState()
                : _buildWordsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sign_language,
            size: 48,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 12),
          Text(
            'لبناء الجملة n\ بعمل الاشارات',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildWordsList() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: words.asMap().entries.map((entry) {
          final index = entry.key;
          final word = entry.value;
          return _WordChip(
            word: word,
            index: index + 1,
            onRemove: () => onRemove(index),
          );
        }).toList(),
      ),
    );
  }
}
class _WordChip extends StatelessWidget {
  final String word;
  final int index;
  final VoidCallback onRemove;
  const _WordChip({
    required this.word,
    required this.index,
    required this.onRemove,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            word,
            style: TextStyle(
              color: AppColors.grey900,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.close,
              size: 16,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
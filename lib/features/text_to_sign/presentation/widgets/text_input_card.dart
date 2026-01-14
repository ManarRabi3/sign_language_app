import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TextInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTranslate;
  final bool isLoading;

  const TextInputCard({
    super.key,
    required this.controller,
    required this.onTranslate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'اكتب النص هنا',
                hintStyle: TextStyle(color: AppColors.grey500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.clear(),
                  color: AppColors.grey500,
                )
                    : null,
              ),
              onChanged: (_) {
                // Trigger rebuild for clear button
                (context as Element).markNeedsBuild();
              },
              onSubmitted: (_) => onTranslate(),
            ),
          ),
// Translate Button
          Container(
            margin: const EdgeInsets.all(8),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: isLoading ? null : onTranslate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(
                    Icons.translate,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
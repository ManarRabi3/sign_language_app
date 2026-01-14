import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_language_app_fixed/features/home/presentation/widgets/feature_card.dart';
import 'package:sign_language_app_fixed/core/constants/app_colors.dart';
import 'package:sign_language_app_fixed/features/sign_to_text/presentation/widgets/sentence_builder.dart';

void main() {
  group('FeatureCard', () {
    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.star,
              gradient: AppColors.primaryGradient,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureCard(
              title: 'Test',
              subtitle: 'Test',
              icon: Icons.star,
              gradient: AppColors.primaryGradient,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FeatureCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureCard(
              title: 'Test',
              subtitle: 'Test',
              icon: Icons.camera_alt,
              gradient: AppColors.primaryGradient,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });

  // ====================== SentenceBuilder tests ======================
  group('SentenceBuilder', () {
    testWidgets('displays empty state when no words', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceBuilder(
              words: const [],
              onRemove: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.text(' تاراشلإا  لمعب  أدبا\n ةلمجلا  ءانبل'), findsOneWidget);
    });

    testWidgets('displays words as chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceBuilder(
              words: const ['اركش', 'ابحرم'],
              onRemove: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.text(' ابحرم'), findsOneWidget);
      expect(find.text('اركش'), findsOneWidget);
    });

    testWidgets('shows clear button when words exist', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceBuilder(
              words: const ['ابحرم'],
              onRemove: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.text('لكلا  حسم'), findsOneWidget);
    });

    testWidgets('calls onRemove when chip deleted', (tester) async {
      int? removedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceBuilder(
              words: const ['اركش', 'ابحرم'],
              onRemove: (index) => removedIndex = index,
              onClear: () {},
            ),
          ),
        ),
      );

      // Find and tap the close icon on first chip
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(removedIndex, 0);
    });
  });
}

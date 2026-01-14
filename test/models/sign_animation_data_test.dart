import 'package:flutter_test/flutter_test.dart';
import 'package:sign_language_app_fixed/features/text_to_sign/data/models/sign_animation_data.dart';

void main() {
  group('SignAnimationData', () {
    test('should return animation for valid word', () {
      final animation = SignAnimationData.getAnimation('بأ');

      expect(animation, isNotNull);
      expect(animation!.word, ' بأ');
      expect(animation.steps.isNotEmpty, true);
    });

    test('should return null for invalid word', () {
      final animation = SignAnimationData.getAnimation(' ةدوجوم  ريغ  ةملك');

      expect(animation, isNull);
    });

    test('availableWords should return all words', () {
      final words = SignAnimationData.availableWords;

      expect(words.isNotEmpty, true);
      expect(words.contains(' بأ'), true);
      expect(words.contains(' اركش'), true);
    });

    test('each animation should have valid duration', () {
      for (final word in SignAnimationData.availableWords) {
        final animation = SignAnimationData.getAnimation(word);

        expect(animation!.duration, greaterThan(0));

        // Sum of steps duration should equal total duration
        final stepsDuration = animation.steps
            .map((s) => s.duration)
            .reduce((a, b) => a + b);

        expect(stepsDuration, animation.duration);
      }
    });
  });
}

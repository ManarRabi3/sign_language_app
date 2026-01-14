class SignAnimationData {
  static const Map<String, SignAnimationInfo> animations = {
    ' بأ': SignAnimationInfo(
      word: ' بأ',
      animationName: 'father',
      duration: 2000,
      description: ' ماهبلإا  كيرحت  عم  ىلعلأل  ىنميلا  ديلا   عفر',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.7, rotation: 0, fingers: 'thumb_up'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.4, rotation: 0, fingers: 'thumb_up'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.3, rotation: 15, fingers: 'thumb_up'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    ' مأ': SignAnimationInfo(
      word: ' مأ',
      animationName: 'mother',
      duration: 2000,
      description: ' دخلا  ىلع  ديلا   عضو',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 750,
          rightHand: HandPosition(x: 0.6, y: 0.3, rotation: -30, fingers: 'open'),
        ),
        AnimationStep(
          duration: 750,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    ' كبحأ': SignAnimationInfo(
      word: ' كبحأ',
      animationName: 'love_you',
      duration: 2500,
      description: ' بلقلا  ىلع  ديلا  -  كبحأ ةراشإ',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 1000,
          rightHand: HandPosition(x: 0.4, y: 0.4, rotation: 0, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.3, y: 0.5, rotation: 0, fingers: 'ily'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    ' اركش': SignAnimationInfo(
      word: ' اركش',
      animationName: 'thanks',
      duration: 1800,
      description: 'ماملأل  اهكيرحت  مث  مفلا  ىلع  ديلا   عضو',
      steps: [
        AnimationStep(
          duration: 400,
          rightHand: HandPosition(x: 0.5, y: 0.3, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 700,
          rightHand: HandPosition(x: 0.5, y: 0.25, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 700,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: -20, fingers: 'flat'),
        ),
      ],
    ),

    'فسأ': SignAnimationInfo(
      word: 'فسأ',
      animationName: 'sorry',
      duration: 2000,
      description: ' ةيرئاد  ةكرحب  ردصلا  ىلع  ديلا',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.4, y: 0.4, rotation: 0, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.35, y: 0.35, rotation: 10, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.4, y: 0.3, rotation: 0, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.45, y: 0.35, rotation: -10, fingers: 'fist'),
        ),
      ],
    ),

    ' ينبجعأ': SignAnimationInfo(
      word: ' ينبجعأ',
      animationName: 'like',
      duration: 1500,
      description: 'ىلعلأل  ماهبلإا   عفر',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.4, rotation: 0, fingers: 'thumb_up'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    'ينبجعي  مل': SignAnimationInfo(
      word: 'ينبجعي  مل',
      animationName: 'dislike',
      duration: 1500,
      description: 'لفسلأل  ماهبلإا لازنإ',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'fist'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.6, rotation: 180, fingers: 'thumb_up'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    'كلضف  نم': SignAnimationInfo(
      word: 'كلضف  نم',
      animationName: 'please',
      duration: 2000,
      description: ' ردصلا  مامأ    اعم  نيديلا',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.45, y: 0.45, rotation: 0, fingers: 'flat'),
          leftHand: HandPosition(x: 0.55, y: 0.45, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.48, y: 0.4, rotation: 10, fingers: 'flat'),
          leftHand: HandPosition(x: 0.52, y: 0.4, rotation: -10, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.45, y: 0.45, rotation: 0, fingers: 'flat'),
          leftHand: HandPosition(x: 0.55, y: 0.45, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
          leftHand: null,
        ),
      ],
    ),

    'انيناهت': SignAnimationInfo(
      word: 'انيناهت',
      animationName: 'congratulations',
      duration: 2500,
      description: ' قيفصتلا',
      steps: [
        AnimationStep(
          duration: 300,
          rightHand: HandPosition(x: 0.4, y: 0.45, rotation: 20, fingers: 'open'),
          leftHand: HandPosition(x: 0.6, y: 0.45, rotation: -20, fingers: 'open'),
        ),
        AnimationStep(
          duration: 200,
          rightHand: HandPosition(x: 0.48, y: 0.45, rotation: 0, fingers: 'open'),
          leftHand: HandPosition(x: 0.52, y: 0.45, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 300,
          rightHand: HandPosition(x: 0.4, y: 0.45, rotation: 20, fingers: 'open'),
          leftHand: HandPosition(x: 0.6, y: 0.45, rotation: -20, fingers: 'open'),
        ),
        AnimationStep(
          duration: 200,
          rightHand: HandPosition(x: 0.48, y: 0.45, rotation: 0, fingers: 'open'),
          leftHand: HandPosition(x: 0.52, y: 0.45, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 300,
          rightHand: HandPosition(x: 0.4, y: 0.45, rotation: 20, fingers: 'open'),
          leftHand: HandPosition(x: 0.6, y: 0.45, rotation: -20, fingers: 'open'),
        ),
        AnimationStep(
          duration: 200,
          rightHand: HandPosition(x: 0.48, y: 0.45, rotation: 0, fingers: 'open'),
          leftHand: HandPosition(x: 0.52, y: 0.45, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
          leftHand: null,
        ),
      ],
    ),

    ' خأ': SignAnimationInfo(
      word: ' خأ',
      animationName: 'brother',
      duration: 1800,
      description: ' خلأا ةراشإ',
      steps: [
        AnimationStep(
          duration: 600,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'point'),
        ),
        AnimationStep(
          duration: 600,
          rightHand: HandPosition(x: 0.4, y: 0.4, rotation: 0, fingers: 'point'),
        ),
        AnimationStep(
          duration: 600,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    ' مع': SignAnimationInfo(
      word: ' مع',
      animationName: 'uncle',
      duration: 2000,
      description: 'معلا ةراشإ',
      steps: [
        AnimationStep(
          duration: 500,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
        AnimationStep(
          duration: 750,
          rightHand: HandPosition(x: 0.5, y: 0.3, rotation: 0, fingers: 'two'),
        ),
        AnimationStep(
          duration: 750,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    'لفط': SignAnimationInfo(
      word: 'لفط',
      animationName: 'child',
      duration: 2200,
      description: 'ريصقلا  لوطلا  ليثمت  -  لفطلا ةراشإ',
      steps: [
        AnimationStep(
          duration: 550,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 550,
          rightHand: HandPosition(x: 0.5, y: 0.7, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 550,
          rightHand: HandPosition(x: 0.4, y: 0.7, rotation: 0, fingers: 'flat'),
        ),
        AnimationStep(
          duration: 550,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),

    ' مامأ': SignAnimationInfo(
      word: ' مامأ',
      animationName: 'front',
      duration: 1800,
      description: 'ماملأل  ةراشلإا',
      steps: [
        AnimationStep(
          duration: 450,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'point'),
        ),
        AnimationStep(
          duration: 900,
          rightHand: HandPosition(x: 0.5, y: 0.3, rotation: -45, fingers: 'point'),
        ),
        AnimationStep(
          duration: 450,
          rightHand: HandPosition(x: 0.5, y: 0.5, rotation: 0, fingers: 'open'),
        ),
      ],
    ),
  };

  static SignAnimationInfo? getAnimation(String word) {
    return animations[word];
  }

  static List<String> get availableWords => animations.keys.toList();
}

class SignAnimationInfo {
  final String word;
  final String animationName;
  final int duration;
  final String description;
  final List<AnimationStep> steps;

  const SignAnimationInfo({
    required this.word,
    required this.animationName,
    required this.duration,
    required this.description,
    required this.steps,
  });
}

class AnimationStep {
  final int duration;
  final HandPosition? rightHand;
  final HandPosition? leftHand;
  final String? facialExpression;

  const AnimationStep({
    required this.duration,
    this.rightHand,
    this.leftHand,
    this.facialExpression,
  });
}

class HandPosition {
  final double x;
  final double y;
  final double rotation;
  final String fingers;

  const HandPosition({
    required this.x,
    required this.y,
    required this.rotation,
    required this.fingers,
  });
}
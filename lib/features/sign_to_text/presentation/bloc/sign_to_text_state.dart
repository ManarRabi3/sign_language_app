import 'package:equatable/equatable.dart';

enum RecognitionStatus {
  initial,
  connecting,
  ready,
  capturing,
  processing,
  success,
  error,
}

class SignToTextState extends Equatable {
  final RecognitionStatus status;
  final bool hasHand;
  final int bufferSize;
  final String? recognizedSign;
  final double? confidence;
  final List<String> sentence;
  final String? errorMessage;
  final bool isCameraInitialized;

  const SignToTextState({
    this.status = RecognitionStatus.initial,
    this.hasHand = false,
    this.bufferSize = 0,
    this.recognizedSign,
    this.confidence,
    this.sentence = const [],
    this.errorMessage,
    this.isCameraInitialized = false,
  });

  SignToTextState copyWith({
    RecognitionStatus? status,
    bool? hasHand,
    int? bufferSize,
    String? recognizedSign,
    double? confidence,
    List<String>? sentence,
    String? errorMessage,
    bool? isCameraInitialized,
  }) {
    return SignToTextState(
      status: status ?? this.status,
      hasHand: hasHand ?? this.hasHand,
      bufferSize: bufferSize ?? this.bufferSize,
      recognizedSign: recognizedSign ?? this.recognizedSign,
      confidence: confidence ?? this.confidence,
      sentence: sentence ?? this.sentence,
      errorMessage: errorMessage ?? this.errorMessage,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hasHand,
    bufferSize,
    recognizedSign,
    confidence,
    sentence,
    errorMessage,
    isCameraInitialized,
  ];
}
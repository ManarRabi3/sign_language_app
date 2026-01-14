import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/tts_service.dart';
import 'sign_to_text_state.dart';

class SignToTextCubit extends Cubit<SignToTextState> {
  final WebSocketService _wsService;
  final TtsService _ttsService;

  CameraController? _cameraController;
  StreamSubscription? _wsSubscription;
  Timer? _frameTimer;

  static const int _frameInterval = 100; // ms between frames

  SignToTextCubit({
    required WebSocketService wsService,
    required TtsService ttsService,
  })  : _wsService = wsService,
        _ttsService = ttsService,
        super(const SignToTextState());

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      emit(state.copyWith(
        isCameraInitialized: true,
        status: RecognitionStatus.ready,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecognitionStatus.error,
        errorMessage: 'اريماكلا  ةئيهت  يف  لشف: $e',
      ));
    }
  }

  Future<void> connectWebSocket() async {
    emit(state.copyWith(status: RecognitionStatus.connecting));

    final connected = await _wsService.connect();

    if (connected) {
      _listenToWebSocket();
      emit(state.copyWith(status: RecognitionStatus.ready));
    } else {
      emit(state.copyWith(
        status: RecognitionStatus.error,
        errorMessage: ' مداخلاب  لاصتلا  لشف',
      ));
    }
  }

  void _listenToWebSocket() {
    _wsSubscription = _wsService.messages?.listen((message) {
      final type = message['type'];

      switch (type) {
        case 'status':
          emit(state.copyWith(
            hasHand: message['has_hand'] ?? false,
            bufferSize: message['buffer_size'] ?? 0,
            status: message['has_hand'] == true
                ? RecognitionStatus.capturing
                : RecognitionStatus.ready,
          ));
          break;

        case 'prediction':
          final sign = message['sign'] as String;
          final confidence = (message['confidence'] as num).toDouble();

          emit(state.copyWith(
            status: RecognitionStatus.success,
            recognizedSign: sign,
            confidence: confidence,
          ));

          //  ةملكلا  قطن
          _ttsService.speak(sign);
          break;

        case 'low_confidence':
          emit(state.copyWith(
            status: RecognitionStatus.ready,
            recognizedSign: message['sign'],
            confidence: (message['confidence'] as num).toDouble(),
          ));
          break;

        case 'error':
          emit(state.copyWith(
            status: RecognitionStatus.error,
            errorMessage: message['message'],
          ));
          break;
      }
    });
  }

  void startCapturing() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _frameTimer = Timer.periodic(
      const Duration(milliseconds: _frameInterval),
          (_) => _captureAndSendFrame(),
    );
  }

  Future<void> _captureAndSendFrame() async {
    if (_cameraController == null || !_wsService.isConnected) return;

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      _wsService.sendFrame(base64Image);
    } catch (e) {
      // Ignore frame capture errors
    }
  }

  void stopCapturing() {
    _frameTimer?.cancel();
    _frameTimer = null;
  }

  void addToSentence() {
    if (state.recognizedSign != null && state.recognizedSign!.isNotEmpty) {
      final newSentence = [...state.sentence, state.recognizedSign!];
      emit(state.copyWith(
        sentence: newSentence,
        recognizedSign: null,
        confidence: null,
        status: RecognitionStatus.ready,
      ));
      _wsService.reset();
    }
  }
  void removeFromSentence(int index) {
    final newSentence = [...state.sentence];
    newSentence.removeAt(index);
    emit(state.copyWith(sentence: newSentence));
  }
  void clearSentence() {
    emit(state.copyWith(
      sentence: [],
      recognizedSign: null,
      confidence: null,
    ));
  }
  void speakSentence() {
    if (state.sentence.isNotEmpty) {
      final text = state.sentence.join(' ');
      _ttsService.speak(text);
    }
  }
  void reset() {
    _wsService.reset();
    emit(state.copyWith(
      status: RecognitionStatus.ready,
      hasHand: false,
      bufferSize: 0,
      recognizedSign: null,
      confidence: null,
    ));
  }
  @override
  Future<void> close() {
    _frameTimer?.cancel();
    _wsSubscription?.cancel();
    _cameraController?.dispose();
    _wsService.disconnect();
    return super.close();
  }
}
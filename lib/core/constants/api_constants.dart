class ApiConstants {
  // Base URL - ـلل  هيريغ IP  كعاتب
  static const String baseUrl = 'http://192.168.1.100:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android Emulator

  // API Endpoints
  static const String apiVersion = '/api/v1';
  static const String health = '$apiVersion/health';
  static const String signToText = '$apiVersion/sign-to-text';
  static const String textToSign = '$apiVersion/text-to-sign';
  static const String processFrame = '$apiVersion/process-frame';
  static const String dictionary = '$apiVersion/dictionary';
  static const String actions = '$apiVersion/actions';

  // WebSocket
  static const String wsBaseUrl = 'ws://192.168.1.100:8000';
  static const String wsSignRecognition = '/ws/sign-recognition';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
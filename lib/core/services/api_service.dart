import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptors for logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Health Check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get(ApiConstants.health);
      return response.data['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  // Sign to Text
  Future<Map<String, dynamic>> signToText(List<Map<String, dynamic>> frames) async {
    try {
      final response = await _dio.post(
        ApiConstants.signToText,
        data: {'frames': frames},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Process Single Frame
  Future<Map<String, dynamic>> processFrame(String base64Image) async {
    try {
      final response = await _dio.post(
        ApiConstants.processFrame,
        data: {'image': base64Image},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
// Text to Sign
  Future<Map<String, dynamic>> textToSign(String text) async {
    try {
      final response = await _dio.post(
        ApiConstants.textToSign,
        data: {'text': text},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
// Get Dictionary
  Future<Map<String, dynamic>> getDictionary({String? category}) async {
    try {
      final response = await _dio.get(
        ApiConstants.dictionary,
        queryParameters: category != null ? {'category': category} : null,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
// Get Actions
  Future<List<String>> getActions() async {
    try {
      final response = await _dio.get(ApiConstants.actions);
      return List<String>.from(response.data['actions']);
    } catch (e) {
      rethrow;
    }
  }
}
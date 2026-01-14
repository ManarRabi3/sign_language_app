import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/api_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  bool _isConnected = false;

  Stream<Map<String, dynamic>>? get messages => _messageController?.stream;
  bool get isConnected => _isConnected;

  /// Connect to WebSocket
  Future<bool> connect() async {
    try {
      final wsUrl = Uri.parse(
          '${ApiConstants.wsBaseUrl}${ApiConstants.wsSignRecognition}');

      _channel = WebSocketChannel.connect(wsUrl);
      _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

      _channel!.stream.listen(
            (data) {
          final message = json.decode(data);
          _messageController?.add(message);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket Closed');
          _isConnected = false;
        },
      );

      _isConnected = true;
      return true;
    } catch (e) {
      print('WebSocket Connection Error: $e');
      return false;
    }
  }

  /// Send a frame (image) to the WebSocket server
  void sendFrame(String base64Image) {
    if (_isConnected && _channel != null) {
      final message = json.encode({
        'type': 'frame',
        'image': base64Image,
      });
      _channel!.sink.add(message);
    }
  }

  /// Send a reset command to the WebSocket server
  void reset() {
    if (_isConnected && _channel != null) {
      final message = json.encode({'type': 'reset'});
      _channel!.sink.add(message);
    }
  }

  /// Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _messageController?.close();
    _isConnected = false;
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<dynamic> _controller = StreamController.broadcast();

  WebSocketService({required this.url});

  Stream<dynamic> get stream => _controller.stream;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          _controller.add(message);
        },
        onDone: () {
          _controller.addError('Connection Closed');
          reconnect();
        },
        onError: (error) {
          _controller.addError(error);
          reconnect();
        },
      );
    } catch (e) {
      _controller.addError(e);
      reconnect();
    }
  }

  void sendAudio(Uint8List data) {
    if (_channel?.closeCode == null) {
      _channel?.sink.add(data);
    }
  }

  void reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      connect();
    });
  }

  void close() {
    _channel?.sink.close();
    _controller.close();
  }
}
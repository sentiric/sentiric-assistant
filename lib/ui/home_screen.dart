import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sentiric_assistant/services/audio_service.dart';
import 'package:sentiric_assistant/services/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  final WebSocketService _webSocketService = WebSocketService(url: 'ws://10.0.2.2:18030/ws'); // Android emulator -> Host machine
  
  StreamSubscription<Uint8List>? _micSubscription;
  StreamSubscription<dynamic>? _socketSubscription;
  
  bool _isRecording = false;
  String _statusText = "Dokun ve Konuş";
  
  // Jitter Buffer
  final List<Uint8List> _audioQueue = [];
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    await _audioService.requestMicPermission();
    _webSocketService.connect();
    _socketSubscription = _webSocketService.stream.listen(_handleSocketMessage,
        onError: (e) => setState(() => _statusText = "Bağlantı Hatası"));
  }

  void _handleSocketMessage(dynamic message) {
    if (message is List<int>) {
      _audioQueue.add(Uint8List.fromList(message));
      if (!_isPlaying) {
        _playQueue();
      }
    }
  }

  void _playQueue() async {
    if (_audioQueue.isEmpty) {
      _isPlaying = false;
      return;
    }
    _isPlaying = true;
    final chunk = _audioQueue.removeAt(0);
    await _audioService.playChunk(chunk);
    _playQueue(); // Recursive call to play next chunk
  }

  void _toggleRecording() {
    if (_isRecording) {
      _micSubscription?.cancel();
      setState(() {
        _isRecording = false;
        _statusText = "İşleniyor...";
      });
    } else {
      final stream = _audioService.startRecording();
      if(stream != null){
         _micSubscription = stream.listen((data) {
            _webSocketService.sendAudio(data);
         });
         setState(() {
           _isRecording = true;
           _statusText = "Dinleniyor...";
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiric Assistant'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _statusText,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _toggleRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording ? Colors.red : Theme.of(context).colorScheme.primary).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: _isRecording ? 10 : 0,
                    ),
                  ],
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _micSubscription?.cancel();
    _socketSubscription?.cancel();
    _audioService.dispose();
    _webSocketService.close();
    super.dispose();
  }
}
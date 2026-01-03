import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Stream<Uint8List>? _micStream;
  StreamSubscription<Uint8List>? _micSubscription;

  AudioService() {
    _audioPlayer.setSource(BytesSource(Uint8List(0))); // Low latency mode
  }

  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Stream<Uint8List>? startRecording() {
    _micStream = MicStream.microphone(
      audioSource: AudioSource.MIC,
      sampleRate: 16000,
      channelConfig: ChannelConfig.mono,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );
    return _micStream;
  }

  void stopRecording() {
    _micSubscription?.cancel();
    _micStream = null;
  }

  Future<void> playChunk(Uint8List chunk) async {
    if (chunk.isNotEmpty) {
      await _audioPlayer.play(BytesSource(chunk));
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
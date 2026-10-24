import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocabulary_app/core/utils/app_logger.dart';

class FlutterTtsSpeechDataSource {
  final FlutterTts _flutterTts = FlutterTts();
  bool _configured = false;
  int _speechRequestId = 0;

  Future<void> speak(String word) async {
    final requestId = ++_speechRequestId;

    try {
      if (!_configured) {
        await _flutterTts.setLanguage('en-AU');
        await _flutterTts.setSpeechRate(0.45);
        _configured = true;
      }

      if (requestId != _speechRequestId) return;
      await _flutterTts.stop();
      if (requestId != _speechRequestId) return;
      await _flutterTts.speak(word);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to pronounce vocabulary word',
        tag: 'TTS',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> stop() async {
    ++_speechRequestId;
    try {
      await _flutterTts.stop();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to stop pronunciation',
        tag: 'TTS',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

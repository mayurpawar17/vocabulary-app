import 'package:vocabulary_app/features/vocabulary/data/datasources/flutter_tts_speech_data_source.dart';
import 'package:vocabulary_app/features/vocabulary/domain/repositories/speech_repository.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  const SpeechRepositoryImpl(this._speechDataSource);

  final FlutterTtsSpeechDataSource _speechDataSource;

  @override
  Future<void> pronounce(String word) {
    return _speechDataSource.speak(word);
  }

  @override
  Future<void> stop() {
    return _speechDataSource.stop();
  }
}

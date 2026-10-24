import 'package:vocabulary_app/features/vocabulary/domain/repositories/speech_repository.dart';

class StopSpeechUseCase {
  const StopSpeechUseCase(this._speechRepository);

  final SpeechRepository _speechRepository;

  Future<void> execute() {
    return _speechRepository.stop();
  }
}

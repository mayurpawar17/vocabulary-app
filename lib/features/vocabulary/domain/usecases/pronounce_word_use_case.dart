import 'package:vocabulary_app/features/vocabulary/domain/repositories/speech_repository.dart';

class PronounceWordUseCase {
  const PronounceWordUseCase(this._speechRepository);

  final SpeechRepository _speechRepository;

  Future<void> execute(String word) {
    return _speechRepository.pronounce(word);
  }
}

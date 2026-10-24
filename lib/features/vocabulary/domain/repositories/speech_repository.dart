abstract class SpeechRepository {
  Future<void> pronounce(String word);

  Future<void> stop();
}

abstract class SequenceRepository {
  Future<String> getNextSequence(String collectionName);
}

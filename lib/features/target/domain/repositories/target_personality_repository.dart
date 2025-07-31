import 'package:app/features/target/domain/entities/target_personality.dart';

abstract class TargetPersonalityRepository {
  Future<TargetPersonality> create(TargetPersonality targetPersonality);

  Future<List<TargetPersonality>> readAllByTargetId(String targetId);

  Future<void> delete(String id);
}

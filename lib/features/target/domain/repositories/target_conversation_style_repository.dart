import 'package:app/features/target/domain/entities/target_conversation_style.dart';

abstract class TargetConversationStyleRepository {
  Future<TargetConversationStyle> create(TargetConversationStyle targetConversationStyle);

  Future<List<TargetConversationStyle>> readAllByTargetId(String targetId);

  Future<void> delete(String id);
}

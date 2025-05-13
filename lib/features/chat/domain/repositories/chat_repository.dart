import 'package:app/features/chat/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<Chat> create(Chat chat);

  Future<bool> existsByMemberIdAndTargetId(String memberId, String targetId);

  Future<Chat> readByMemberIdAndTargetId(String memberId, String targetId);

  Future<Chat> update(Chat chat);
}

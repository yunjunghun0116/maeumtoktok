import 'package:app/features/member/domain/entities/member_conversation_style.dart';

abstract class MemberConversationStyleRepository {
  Future<MemberConversationStyle> create(MemberConversationStyle memberConversationStyle);

  Future<List<MemberConversationStyle>> readAllByMemberId(String memberId);

  Future<void> delete(String id);
}

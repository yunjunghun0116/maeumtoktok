import 'package:app/features/member/domain/entities/member_conversation_style.dart';
import 'package:app/features/member/domain/repositories/member_conversation_style_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadAllMemberConversationStyle extends BaseUseCaseWithParam<String, List<MemberConversationStyle>> {
  final MemberConversationStyleRepository _memberConversationStyleRepository;

  ReadAllMemberConversationStyle({required MemberConversationStyleRepository memberConversationStyleRepository})
    : _memberConversationStyleRepository = memberConversationStyleRepository;

  @override
  Future<List<MemberConversationStyle>> execute(String id) async {
    return await _memberConversationStyleRepository.readAllByMemberId(id);
  }
}

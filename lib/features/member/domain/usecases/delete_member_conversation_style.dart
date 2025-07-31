import 'package:app/features/member/domain/repositories/member_conversation_style_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class DeleteMemberConversationStyle extends BaseUseCaseWithParam<String, void> {
  final MemberConversationStyleRepository _memberConversationStyleRepository;

  DeleteMemberConversationStyle({required MemberConversationStyleRepository memberConversationStyleRepository})
    : _memberConversationStyleRepository = memberConversationStyleRepository;

  @override
  Future<void> execute(String id) async {
    await _memberConversationStyleRepository.delete(id);
  }
}

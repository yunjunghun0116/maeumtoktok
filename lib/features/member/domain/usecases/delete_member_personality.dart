import 'package:app/features/member/domain/repositories/member_personality_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class DeleteMemberPersonality extends BaseUseCaseWithParam<String, void> {
  final MemberPersonalityRepository _memberPersonalityRepository;

  DeleteMemberPersonality({required MemberPersonalityRepository memberPersonalityRepository})
    : _memberPersonalityRepository = memberPersonalityRepository;

  @override
  Future<void> execute(String id) async {
    await _memberPersonalityRepository.delete(id);
  }
}

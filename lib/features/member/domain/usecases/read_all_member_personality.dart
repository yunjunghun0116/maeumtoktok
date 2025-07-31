import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/domain/repositories/member_personality_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadAllMemberPersonality extends BaseUseCaseWithParam<String, List<MemberPersonality>> {
  final MemberPersonalityRepository _memberPersonalityRepository;

  ReadAllMemberPersonality({required MemberPersonalityRepository memberPersonalityRepository})
    : _memberPersonalityRepository = memberPersonalityRepository;

  @override
  Future<List<MemberPersonality>> execute(String id) async {
    return await _memberPersonalityRepository.readAllByMemberId(id);
  }
}

import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member/domain/repositories/member_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class UpdateMember extends BaseUseCaseWithParam<Member, Member> {
  final MemberRepository _memberRepository;

  UpdateMember({required MemberRepository memberRepository}) : _memberRepository = memberRepository;

  @override
  Future<Member> execute(Member member) async {
    return await _memberRepository.update(member);
  }
}

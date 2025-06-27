import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class Leave extends BaseUseCaseWithParam<Member, bool> {
  final AuthRepository _authRepository;

  Leave({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<bool> execute(Member member) async {
    return await _authRepository.deleteByMember(member);
  }
}

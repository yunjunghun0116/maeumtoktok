import 'package:app/core/domain/usecases/base_use_case_with_param.dart';
import 'package:app/features/auth/data/models/login_dto.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';

class Login extends BaseUseCaseWithParam<LoginDto, Member> {
  final AuthRepository _authRepository;

  Login({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Member> execute(LoginDto loginDto) async {
    return await _authRepository.readByEmailAndPassword(loginDto.email, loginDto.password);
  }
}

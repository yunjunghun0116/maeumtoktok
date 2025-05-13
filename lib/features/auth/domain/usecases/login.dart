import 'package:app/features/auth/data/models/login_dto.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';
import 'package:app/shared/repositories/local/local_repository.dart';

class Login extends BaseUseCaseWithParam<LoginDto, Member> {
  final AuthRepository authRepository;
  final LocalRepository localRepository;

  Login({required this.authRepository, required this.localRepository});

  @override
  Future<Member> call(LoginDto loginDto) async {
    return await authRepository.readByEmailAndPassword(loginDto.email, loginDto.password);
  }
}

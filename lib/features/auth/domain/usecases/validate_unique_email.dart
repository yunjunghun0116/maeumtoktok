import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class ValidateUniqueEmail extends BaseUseCaseWithParam<String, bool> {
  final AuthRepository authRepository;

  ValidateUniqueEmail({required this.authRepository});

  @override
  Future<bool> call(String email) async {
    return await authRepository.existsByEmail(email);
  }
}

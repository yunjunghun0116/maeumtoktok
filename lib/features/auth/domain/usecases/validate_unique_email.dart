import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/core/domain/usecases/base_use_case_with_param.dart';

class ValidateUniqueEmail extends BaseUseCaseWithParam<String, bool> {
  final AuthRepository _authRepository;

  ValidateUniqueEmail({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<bool> call(String email) async {
    return await _authRepository.existsByEmail(email);
  }
}

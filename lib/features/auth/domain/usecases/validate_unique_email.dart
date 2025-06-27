import 'package:app/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ValidateUniqueEmail extends BaseUseCaseWithParam<String, bool> {
  final AuthRepository _authRepository;

  ValidateUniqueEmail({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<bool> execute(String email) async {
    return await _authRepository.existsByEmail(email);
  }
}

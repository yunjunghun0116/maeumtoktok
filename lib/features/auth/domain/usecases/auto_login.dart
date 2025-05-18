import 'package:app/core/domain/repositories/local_repository.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/shared/constants/local_repository_key.dart';

import '../../../../core/domain/usecases/base_use_case.dart';
import '../../../../core/exceptions/custom_exception.dart';

class AutoLogin extends BaseUseCase<Member> {
  final AuthRepository _authRepository;
  final LocalRepository _localRepository;

  AutoLogin({required LocalRepository localRepository, required AuthRepository authRepository})
    : _localRepository = localRepository,
      _authRepository = authRepository;

  @override
  Future<Member> execute() async {
    try {
      var isLoggedIn = _localRepository.read<bool>(LocalRepositoryKey.isLoggedIn);
      if (!isLoggedIn) throw CustomException(ExceptionMessage.badRequest);

      var memberEmail = _localRepository.read<String>(LocalRepositoryKey.memberEmail);
      return await _authRepository.readByEmail(memberEmail);
    } on CustomException catch (e) {
      rethrow;
    }
  }
}

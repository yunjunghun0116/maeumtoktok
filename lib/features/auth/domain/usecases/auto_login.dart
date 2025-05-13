import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/shared/base/base_use_case.dart';
import 'package:app/shared/constants/local_repository_key.dart';
import 'package:app/shared/repositories/local/local_repository.dart';

import '../../../../core/exceptions/custom_exception.dart';

class AutoLogin extends BaseUseCase<Member> {
  final AuthRepository authRepository;
  final LocalRepository localRepository;

  AutoLogin({required this.localRepository, required this.authRepository});

  @override
  Future<Member> call() async {
    try {
      var isLoggedIn = localRepository.read<bool>(LocalRepositoryKey.isLoggedIn);
      if (!isLoggedIn) throw CustomException(ExceptionMessage.badRequest);

      var memberEmail = localRepository.read<String>(LocalRepositoryKey.memberEmail);
      return await authRepository.readByEmail(memberEmail);
    } on CustomException catch (e) {
      rethrow;
    }
  }
}

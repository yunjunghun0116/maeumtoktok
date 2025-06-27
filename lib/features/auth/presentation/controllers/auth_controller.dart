import 'package:app/features/auth/data/models/login_dto.dart';
import 'package:app/features/auth/data/models/register_dto.dart';
import 'package:app/features/auth/domain/usecases/auto_login.dart';
import 'package:app/features/auth/domain/usecases/leave.dart';
import 'package:app/features/auth/domain/usecases/login.dart';
import 'package:app/features/auth/domain/usecases/register.dart';
import 'package:app/features/auth/domain/usecases/validate_unique_email.dart';
import 'package:app/features/member/domain/entities/member.dart';

import '../../../../core/base/base_controller.dart';

class AuthController extends BaseController {
  final Login _loginUseCase;
  final Register _registerUseCase;
  final AutoLogin _autoLoginUseCase;
  final Leave _leaveUseCase;
  final ValidateUniqueEmail _validateUniqueEmailUseCase;

  AuthController({
    required Login loginUseCase,
    required Register registerUseCase,
    required AutoLogin autoLoginUseCase,
    required Leave leaveUseCase,
    required ValidateUniqueEmail validateUniqueEmailUseCase,
  }) : _validateUniqueEmailUseCase = validateUniqueEmailUseCase,
       _autoLoginUseCase = autoLoginUseCase,
       _registerUseCase = registerUseCase,
       _leaveUseCase = leaveUseCase,
       _loginUseCase = loginUseCase;

  Future<Member> login(LoginDto loginDto) async {
    return await callMethod<Member>(() => _loginUseCase.call(loginDto));
  }

  Future<Member> register(RegisterDto registerDto) async {
    return await callMethod<Member>(() => _registerUseCase.call(registerDto));
  }

  Future<Member> autoLogin() async {
    return await callMethod<Member>(() => _autoLoginUseCase.call());
  }

  Future<bool> leave(Member member) async {
    return await callMethod<bool>(() => _leaveUseCase.call(member));
  }

  Future<bool> validateUniqueEmail(String email) async {
    return await callMethod<bool>(() => _validateUniqueEmailUseCase.call(email));
  }
}

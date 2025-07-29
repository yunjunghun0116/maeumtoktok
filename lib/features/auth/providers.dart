import 'package:app/core/base/base_controller.dart';
import 'package:app/core/providers.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/usecases/leave.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/target/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/usecases/auto_login.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/validate_unique_email.dart';

// --- Repository Providers ---
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl());

// --- UseCases Providers ---
final autoLoginUseCaseProvider = Provider<AutoLogin>((ref) {
  var authRepository = ref.watch(authRepositoryProvider);
  var localRepository = ref.watch(localRepositoryProvider);
  return AutoLogin(authRepository: authRepository, localRepository: localRepository);
});

final loginUseCaseProvider = Provider<Login>((ref) {
  var authRepository = ref.watch(authRepositoryProvider);
  return Login(authRepository: authRepository);
});

final registerUseCaseProvider = Provider<Register>((ref) {
  var authRepository = ref.watch(authRepositoryProvider);
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var targetRepository = ref.watch(targetRepositoryProvider);
  return Register(
    authRepository: authRepository,
    sequenceRepository: sequenceRepository,
    targetRepository: targetRepository,
  );
});

final validateUniqueEmailUseCaseProvider = Provider<ValidateUniqueEmail>((ref) {
  var authRepository = ref.watch(authRepositoryProvider);
  return ValidateUniqueEmail(authRepository: authRepository);
});

final leaveUseCaseProvider = Provider<Leave>((ref) {
  var authRepository = ref.watch(authRepositoryProvider);
  return Leave(authRepository: authRepository);
});

// --- Controller Providers ---
final authControllerProvider = StateNotifierProvider<AuthController, BaseState>((ref) {
  var autoLogin = ref.watch(autoLoginUseCaseProvider);
  var login = ref.watch(loginUseCaseProvider);
  var register = ref.watch(registerUseCaseProvider);
  var leave = ref.watch(leaveUseCaseProvider);
  var validateUniqueEmail = ref.watch(validateUniqueEmailUseCaseProvider);
  return AuthController(
    autoLoginUseCase: autoLogin,
    loginUseCase: login,
    registerUseCase: register,
    leaveUseCase: leave,
    validateUniqueEmailUseCase: validateUniqueEmail,
  );
});

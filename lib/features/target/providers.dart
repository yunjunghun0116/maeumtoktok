import 'package:app/core/providers.dart';
import 'package:app/features/target/data/repositories/target_conversation_style_repository_impl.dart';
import 'package:app/features/target/data/repositories/target_personality_repository_impl.dart';
import 'package:app/features/target/data/repositories/target_repository_impl.dart';
import 'package:app/features/target/domain/repositories/target_conversation_style_repository.dart';
import 'package:app/features/target/domain/repositories/target_personality_repository.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';
import 'package:app/features/target/domain/usecases/create_target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/create_target_personality.dart';
import 'package:app/features/target/domain/usecases/delete_target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/delete_target_personality.dart';
import 'package:app/features/target/domain/usecases/read_all_target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/read_all_target_personality.dart';
import 'package:app/features/target/domain/usecases/read_target_with_member_id.dart';
import 'package:app/features/target/domain/usecases/update_target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target/presentation/controllers/target_conversation_style_controller.dart';
import 'package:app/features/target/presentation/controllers/target_personality_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Repository Providers ---
final targetRepositoryProvider = Provider<TargetRepository>((ref) => TargetRepositoryImpl());
final targetPersonalityRepositoryProvider = Provider<TargetPersonalityRepository>(
  (ref) => TargetPersonalityRepositoryImpl(),
);
final targetConversationStyleRepositoryProvider = Provider<TargetConversationStyleRepository>(
  (ref) => TargetConversationStyleRepositoryImpl(),
);

// --- UseCases Providers ---
final readTargetWithMemberIdUseCaseProvider = Provider<ReadTargetWithMemberId>((ref) {
  var targetRepository = ref.watch(targetRepositoryProvider);
  return ReadTargetWithMemberId(targetRepository: targetRepository);
});

final updateTargetUseCaseProvider = Provider<UpdateTarget>((ref) {
  var targetRepository = ref.watch(targetRepositoryProvider);
  return UpdateTarget(targetRepository: targetRepository);
});

final createTargetPersonalityUseCaseProvider = Provider<CreateTargetPersonality>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var targetPersonalityRepository = ref.watch(targetPersonalityRepositoryProvider);
  return CreateTargetPersonality(
    sequenceRepository: sequenceRepository,
    targetPersonalityRepository: targetPersonalityRepository,
  );
});

final deleteTargetPersonalityUseCaseProvider = Provider<DeleteTargetPersonality>((ref) {
  var targetPersonalityRepository = ref.watch(targetPersonalityRepositoryProvider);
  return DeleteTargetPersonality(targetPersonalityRepository: targetPersonalityRepository);
});

final readAllTargetPersonalityUseCaseProvider = Provider<ReadAllTargetPersonality>((ref) {
  var targetPersonalityRepository = ref.watch(targetPersonalityRepositoryProvider);
  return ReadAllTargetPersonality(targetPersonalityRepository: targetPersonalityRepository);
});

final createTargetConversationStyleUseCaseProvider = Provider<CreateTargetConversationStyle>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var targetConversationStyleRepository = ref.watch(targetConversationStyleRepositoryProvider);
  return CreateTargetConversationStyle(
    sequenceRepository: sequenceRepository,
    targetConversationStyleRepository: targetConversationStyleRepository,
  );
});

final deleteTargetConversationStyleUseCaseProvider = Provider<DeleteTargetConversationStyle>((ref) {
  var targetConversationStyleRepository = ref.watch(targetConversationStyleRepositoryProvider);
  return DeleteTargetConversationStyle(targetConversationStyleRepository: targetConversationStyleRepository);
});

final readAllTargetConversationStyleUseCaseProvider = Provider<ReadAllTargetConversationStyle>((ref) {
  var targetConversationStyleRepository = ref.watch(targetConversationStyleRepositoryProvider);
  return ReadAllTargetConversationStyle(targetConversationStyleRepository: targetConversationStyleRepository);
});

// --- Controller Providers ---
final targetControllerProvider = StateNotifierProvider<TargetController, TargetState>((ref) {
  var readTargetWithMemberId = ref.watch(readTargetWithMemberIdUseCaseProvider);
  var updateTarget = ref.watch(updateTargetUseCaseProvider);
  return TargetController(readTargetWithMemberIdUseCase: readTargetWithMemberId, updateTargetUseCase: updateTarget);
});

final targetPersonalityControllerProvider = StateNotifierProvider<TargetPersonalityController, TargetPersonalityState>((
  ref,
) {
  var createTargetPersonality = ref.watch(createTargetPersonalityUseCaseProvider);
  var deleteTargetPersonality = ref.watch(deleteTargetPersonalityUseCaseProvider);
  var readAllTargetPersonality = ref.watch(readAllTargetPersonalityUseCaseProvider);
  return TargetPersonalityController(
    createTargetPersonalityUseCase: createTargetPersonality,
    deleteTargetPersonalityUseCase: deleteTargetPersonality,
    readAllTargetPersonalityUseCase: readAllTargetPersonality,
  );
});

final targetConversationStyleControllerProvider =
    StateNotifierProvider<TargetConversationStyleController, TargetConversationStyleState>((ref) {
      var createTargetConversationStyle = ref.watch(createTargetConversationStyleUseCaseProvider);
      var deleteTargetConversationStyle = ref.watch(deleteTargetConversationStyleUseCaseProvider);
      var readAllTargetConversationStyle = ref.watch(readAllTargetConversationStyleUseCaseProvider);
      return TargetConversationStyleController(
        createTargetConversationStyleUseCase: createTargetConversationStyle,
        deleteTargetConversationStyleUseCase: deleteTargetConversationStyle,
        readAllTargetConversationStyleUseCase: readAllTargetConversationStyle,
      );
    });

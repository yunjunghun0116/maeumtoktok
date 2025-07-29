import 'package:app/core/providers.dart';
import 'package:app/features/target_issue/data/repositories/target_issue_repository_impl.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';
import 'package:app/features/target_issue/domain/usecases/create_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/delete_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/read_all_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/update_target_issue.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Repository Providers ---
final targetIssueRepositoryProvider = Provider<TargetIssueRepository>((ref) => TargetIssueRepositoryImpl());

// --- UseCases Providers ---
final createTargetIssueUseCaseProvider = Provider<CreateTargetIssue>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var targetIssueRepository = ref.watch(targetIssueRepositoryProvider);
  return CreateTargetIssue(sequenceRepository: sequenceRepository, targetIssueRepository: targetIssueRepository);
});

final deleteTargetIssueUseCaseProvider = Provider<DeleteTargetIssue>((ref) {
  var targetIssueRepository = ref.watch(targetIssueRepositoryProvider);
  return DeleteTargetIssue(targetIssueRepository: targetIssueRepository);
});

final readAllTargetIssueUseCaseProvider = Provider<ReadAllTargetIssue>((ref) {
  var targetIssueRepository = ref.watch(targetIssueRepositoryProvider);
  return ReadAllTargetIssue(targetIssueRepository: targetIssueRepository);
});

final updateTargetIssueUseCaseProvider = Provider<UpdateTargetIssue>((ref) {
  var targetIssueRepository = ref.watch(targetIssueRepositoryProvider);
  return UpdateTargetIssue(targetIssueRepository: targetIssueRepository);
});

// --- Controller Providers ---
final targetIssueControllerProvider = StateNotifierProvider<TargetIssueController, TargetIssueState>((ref) {
  var createTargetIssue = ref.watch(createTargetIssueUseCaseProvider);
  var deleteTargetIssue = ref.watch(deleteTargetIssueUseCaseProvider);
  var readAllTargetIssue = ref.watch(readAllTargetIssueUseCaseProvider);
  var updateTargetIssue = ref.watch(updateTargetIssueUseCaseProvider);
  return TargetIssueController(
    createTargetIssueUseCase: createTargetIssue,
    deleteTargetIssueUseCase: deleteTargetIssue,
    readAllTargetIssueUseCase: readAllTargetIssue,
    updateTargetIssueUseCase: updateTargetIssue,
  );
});

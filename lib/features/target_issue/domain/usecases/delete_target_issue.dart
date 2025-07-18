import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class DeleteTargetIssue extends BaseUseCaseWithParam<TargetIssue, void> {
  final TargetIssueRepository _targetIssueRepository;

  DeleteTargetIssue({required TargetIssueRepository targetIssueRepository})
    : _targetIssueRepository = targetIssueRepository;

  @override
  Future<void> execute(TargetIssue issue) async {
    await _targetIssueRepository.delete(issue);
  }
}

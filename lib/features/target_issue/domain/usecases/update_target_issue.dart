import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../core/domain/usecases/base_use_case_with_param.dart';

class UpdateTargetIssue extends BaseUseCaseWithParam<TargetIssue, TargetIssue> {
  final TargetIssueRepository _targetIssueRepository;

  UpdateTargetIssue({required TargetIssueRepository targetIssueRepository})
    : _targetIssueRepository = targetIssueRepository;

  @override
  Future<TargetIssue> execute(TargetIssue issue) async {
    return await _targetIssueRepository.update(issue);
  }
}

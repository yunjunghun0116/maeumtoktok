import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class DeleteTargetIssue implements BaseUseCaseWithParam<TargetIssue, void> {
  final TargetIssueRepository targetIssueRepository;

  DeleteTargetIssue({required this.targetIssueRepository});

  @override
  Future<void> call(TargetIssue issue) async {
    await targetIssueRepository.delete(issue);
  }
}

import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class UpdateTargetIssue implements BaseUseCaseWithParam<TargetIssue, TargetIssue> {
  final TargetIssueRepository targetIssueRepository;

  UpdateTargetIssue({required this.targetIssueRepository});

  @override
  Future<TargetIssue> call(TargetIssue issue) async {
    return await targetIssueRepository.update(issue);
  }
}

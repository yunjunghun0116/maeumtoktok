import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadAllTargetIssue extends BaseUseCaseWithParam<String, List<TargetIssue>> {
  final TargetIssueRepository _targetIssueRepository;

  ReadAllTargetIssue({required TargetIssueRepository targetIssueRepository})
    : _targetIssueRepository = targetIssueRepository;

  @override
  Future<List<TargetIssue>> execute(String id) async {
    return await _targetIssueRepository.readAllByTargetId(id);
  }
}

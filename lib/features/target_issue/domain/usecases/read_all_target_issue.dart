import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class ReadAllTargetIssue implements BaseUseCaseWithParam<String, List<TargetIssue>> {
  final TargetIssueRepository targetIssueRepository;

  ReadAllTargetIssue({required this.targetIssueRepository});

  @override
  Future<List<TargetIssue>> call(String id) async {
    return await targetIssueRepository.readAllByTargetId(id);
  }
}

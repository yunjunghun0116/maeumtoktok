import 'package:app/features/target_issue/domain/entities/target_issue.dart';

abstract class TargetIssueRepository {
  Future<TargetIssue> create(TargetIssue issue);

  Future<List<TargetIssue>> readAllByTargetId(String id);

  Future<TargetIssue> update(TargetIssue issue);

  Future<void> delete(TargetIssue issue);
}

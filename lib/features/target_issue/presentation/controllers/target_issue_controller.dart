import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/create_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/delete_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/read_all_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/update_target_issue.dart';

import '../../../../../shared/base/base_controller.dart';

class TargetIssueController extends BaseController {
  final CreateTargetIssue _createTargetIssueUseCase;
  final ReadAllTargetIssue _readAllTargetIssueUseCase;
  final UpdateTargetIssue _updateTargetIssueUseCase;
  final DeleteTargetIssue _deleteTargetIssueUseCase;

  List<TargetIssue> _issues = [];

  List<TargetIssue> get positiveIssues => _issues.where((issue) => issue.issueType == IssueType.positive).toList();

  List<TargetIssue> get negativeIssues => _issues.where((issue) => issue.issueType == IssueType.negative).toList();

  List<TargetIssue> get normalIssues => _issues.where((issue) => issue.issueType == IssueType.normal).toList();

  TargetIssueController({
    required CreateTargetIssue createTargetIssueUseCase,
    required ReadAllTargetIssue readAllTargetIssueUseCase,
    required UpdateTargetIssue updateTargetIssueUseCase,
    required DeleteTargetIssue deleteTargetIssueUseCase,
  }) : _deleteTargetIssueUseCase = deleteTargetIssueUseCase,
       _updateTargetIssueUseCase = updateTargetIssueUseCase,
       _readAllTargetIssueUseCase = readAllTargetIssueUseCase,
       _createTargetIssueUseCase = createTargetIssueUseCase;

  Future<void> initialize(String targetId) async {
    _issues = await readAll(targetId);
    notifyListeners();
  }

  Future<TargetIssue> create(CreateIssueDto createIssueDto) async {
    return await callMethod<TargetIssue>(() => _createTargetIssueUseCase.call(createIssueDto));
  }

  Future<List<TargetIssue>> readAll(String targetId) async {
    return await callMethod<List<TargetIssue>>(() => _readAllTargetIssueUseCase.call(targetId));
  }

  Future<TargetIssue> update(TargetIssue issue) async {
    return await callMethod<TargetIssue>(() => _updateTargetIssueUseCase.call(issue));
  }

  Future<void> delete(TargetIssue issue) async {
    await callMethod<void>(() => _deleteTargetIssueUseCase.call(issue));
  }
}

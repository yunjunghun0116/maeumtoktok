import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/create_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/delete_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/read_all_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/update_target_issue.dart';

import '../../../../core/base/base_controller.dart';

class TargetIssueState extends BaseState {
  final List<TargetIssue> issues;

  const TargetIssueState({required this.issues, super.isLoading});

  List<TargetIssue> get positiveIssues => issues.where((issue) => issue.issueType == IssueType.positive).toList();

  List<TargetIssue> get negativeIssues => issues.where((issue) => issue.issueType == IssueType.negative).toList();

  List<TargetIssue> get normalIssues => issues.where((issue) => issue.issueType == IssueType.normal).toList();

  @override
  TargetIssueState copyWith({List<TargetIssue>? issues, bool? isLoading}) {
    return TargetIssueState(issues: issues ?? this.issues, isLoading: isLoading ?? this.isLoading);
  }
}

class TargetIssueController extends BaseController<TargetIssueState> {
  final CreateTargetIssue _createTargetIssueUseCase;
  final ReadAllTargetIssue _readAllTargetIssueUseCase;
  final UpdateTargetIssue _updateTargetIssueUseCase;
  final DeleteTargetIssue _deleteTargetIssueUseCase;

  TargetIssueController({
    required CreateTargetIssue createTargetIssueUseCase,
    required ReadAllTargetIssue readAllTargetIssueUseCase,
    required UpdateTargetIssue updateTargetIssueUseCase,
    required DeleteTargetIssue deleteTargetIssueUseCase,
  }) : _deleteTargetIssueUseCase = deleteTargetIssueUseCase,
       _updateTargetIssueUseCase = updateTargetIssueUseCase,
       _readAllTargetIssueUseCase = readAllTargetIssueUseCase,
       _createTargetIssueUseCase = createTargetIssueUseCase,
       super(TargetIssueState(issues: []));

  Future<void> initialize(String targetId) async {
    var issues = await readAll(targetId);
    state = state.copyWith(issues: issues);
  }

  Future<void> create(CreateIssueDto createIssueDto) async {
    await callMethod<TargetIssue>(() => _createTargetIssueUseCase.call(createIssueDto));
    initialize(createIssueDto.targetId);
  }

  Future<List<TargetIssue>> readAll(String targetId) async {
    return await callMethod<List<TargetIssue>>(() => _readAllTargetIssueUseCase.call(targetId));
  }

  Future<void> update(TargetIssue issue) async {
    await callMethod<TargetIssue>(() => _updateTargetIssueUseCase.call(issue));
    initialize(issue.targetId);
  }

  Future<void> delete(TargetIssue issue) async {
    await callMethod<void>(() => _deleteTargetIssueUseCase.call(issue));
    initialize(issue.targetId);
  }
}

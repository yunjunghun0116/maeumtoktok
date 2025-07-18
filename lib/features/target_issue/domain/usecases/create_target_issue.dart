import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';
import '../../../../shared/constants/firebase_collection.dart';

class CreateTargetIssue extends BaseUseCaseWithParam<CreateIssueDto, TargetIssue> {
  final TargetIssueRepository _targetIssueRepository;
  final SequenceRepository _sequenceRepository;

  CreateTargetIssue({
    required TargetIssueRepository targetIssueRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _targetIssueRepository = targetIssueRepository;

  @override
  Future<TargetIssue> execute(CreateIssueDto createIssueDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.targetIssueCollection);
    var issue = TargetIssue.fromDto(id, createIssueDto);

    return await _targetIssueRepository.create(issue);
  }
}

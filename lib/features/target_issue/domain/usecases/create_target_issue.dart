import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../core/domain/usecases/base_use_case_with_param.dart';
import '../../../../shared/constants/firebase_collection.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';

class CreateTargetIssue implements BaseUseCaseWithParam<CreateIssueDto, TargetIssue> {
  final TargetIssueRepository _targetIssueRepository;
  final SequenceRepository _sequenceRepository;

  CreateTargetIssue({
    required TargetIssueRepository targetIssueRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _targetIssueRepository = targetIssueRepository;

  @override
  Future<TargetIssue> call(CreateIssueDto createIssueDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.targetIssueCollection);
    var issue = TargetIssue.fromDto(id, createIssueDto);

    return await _targetIssueRepository.create(issue);
  }
}

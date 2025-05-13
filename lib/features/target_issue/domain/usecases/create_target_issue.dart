import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';
import '../../../../shared/constants/firebase_collection.dart';
import '../../../../shared/repositories/sequence/sequence_repository.dart';

class CreateTargetIssue implements BaseUseCaseWithParam<CreateIssueDto, TargetIssue> {
  final TargetIssueRepository targetIssueRepository;
  final SequenceRepository sequenceRepository;

  CreateTargetIssue({required this.targetIssueRepository, required this.sequenceRepository});

  @override
  Future<TargetIssue> call(CreateIssueDto createIssueDto) async {
    var id = await sequenceRepository.getNextSequence(FirebaseCollection.targetIssueCollection);
    var issue = TargetIssue.fromDto(id, createIssueDto);

    return await targetIssueRepository.create(issue);
  }
}

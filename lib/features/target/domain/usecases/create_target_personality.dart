import 'package:app/features/target/data/models/create_target_personality_dto.dart';
import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/domain/repositories/target_personality_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';

class CreateTargetPersonality extends BaseUseCaseWithParam<CreateTargetPersonalityDto, TargetPersonality> {
  final TargetPersonalityRepository _targetPersonalityRepository;
  final SequenceRepository _sequenceRepository;

  CreateTargetPersonality({
    required TargetPersonalityRepository targetPersonalityRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _targetPersonalityRepository = targetPersonalityRepository;

  @override
  Future<TargetPersonality> execute(CreateTargetPersonalityDto createTargetPersonalityDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.targetPersonalityCollection);
    var targetPersonality = TargetPersonality.fromDto(id, createTargetPersonalityDto);
    return await _targetPersonalityRepository.create(targetPersonality);
  }
}

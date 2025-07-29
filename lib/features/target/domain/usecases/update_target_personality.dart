import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/domain/repositories/target_personality_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class UpdateTargetPersonality extends BaseUseCaseWithParam<TargetPersonality, TargetPersonality> {
  final TargetPersonalityRepository _targetPersonalityRepository;

  UpdateTargetPersonality({required TargetPersonalityRepository targetPersonalityRepository})
    : _targetPersonalityRepository = targetPersonalityRepository;

  @override
  Future<TargetPersonality> execute(TargetPersonality targetPersonality) async {
    return await _targetPersonalityRepository.update(targetPersonality);
  }
}

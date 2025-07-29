import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/domain/repositories/target_personality_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadAllTargetPersonality extends BaseUseCaseWithParam<String, List<TargetPersonality>> {
  final TargetPersonalityRepository _targetPersonalityRepository;

  ReadAllTargetPersonality({required TargetPersonalityRepository targetPersonalityRepository})
    : _targetPersonalityRepository = targetPersonalityRepository;

  @override
  Future<List<TargetPersonality>> execute(String id) async {
    return await _targetPersonalityRepository.readAllByTargetId(id);
  }
}

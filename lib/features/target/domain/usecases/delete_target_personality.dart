import 'package:app/features/target/domain/repositories/target_personality_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class DeleteTargetPersonality extends BaseUseCaseWithParam<String, void> {
  final TargetPersonalityRepository _targetPersonalityRepository;

  DeleteTargetPersonality({required TargetPersonalityRepository targetPersonalityRepository})
    : _targetPersonalityRepository = targetPersonalityRepository;

  @override
  Future<void> execute(String id) async {
    await _targetPersonalityRepository.delete(id);
  }
}

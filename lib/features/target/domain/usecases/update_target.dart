import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class UpdateTarget extends BaseUseCaseWithParam<Target, Target> {
  final TargetRepository _targetRepository;

  UpdateTarget({required TargetRepository targetRepository}) : _targetRepository = targetRepository;

  @override
  Future<Target> execute(Target target) async {
    return await _targetRepository.update(target);
  }
}

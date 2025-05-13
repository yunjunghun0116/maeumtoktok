import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class UpdateTarget implements BaseUseCaseWithParam<Target, Target> {
  final TargetRepository targetRepository;

  UpdateTarget({required this.targetRepository});

  @override
  Future<Target> call(Target target) async {
    return await targetRepository.update(target);
  }
}

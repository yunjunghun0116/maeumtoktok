import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class ReadTarget implements BaseUseCaseWithParam<String, Target> {
  final TargetRepository _targetRepository;

  ReadTarget({required TargetRepository targetRepository}) : _targetRepository = targetRepository;

  @override
  Future<Target> call(String id) async {
    return await _targetRepository.readById(id);
  }
}

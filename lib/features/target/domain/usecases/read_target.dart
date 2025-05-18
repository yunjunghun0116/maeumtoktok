import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';

import '../../../../core/domain/usecases/base_use_case_with_param.dart';

class ReadTarget extends BaseUseCaseWithParam<String, Target> {
  final TargetRepository _targetRepository;

  ReadTarget({required TargetRepository targetRepository}) : _targetRepository = targetRepository;

  @override
  Future<Target> execute(String id) async {
    return await _targetRepository.readById(id);
  }
}

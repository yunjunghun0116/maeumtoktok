import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadTargetWithMemberId extends BaseUseCaseWithParam<String, Target> {
  final TargetRepository _targetRepository;

  ReadTargetWithMemberId({required TargetRepository targetRepository}) : _targetRepository = targetRepository;

  @override
  Future<Target> execute(String memberId) async {
    return await _targetRepository.readByMemberId(memberId);
  }
}

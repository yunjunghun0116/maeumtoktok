import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/repositories/target_information_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class ReadTargetInformation implements BaseUseCaseWithParam<String, TargetInformation> {
  final TargetInformationRepository _targetInformationRepository;

  ReadTargetInformation({required TargetInformationRepository targetInformationRepository})
    : _targetInformationRepository = targetInformationRepository;

  @override
  Future<TargetInformation> call(String id) async {
    return await _targetInformationRepository.readById(id);
  }
}

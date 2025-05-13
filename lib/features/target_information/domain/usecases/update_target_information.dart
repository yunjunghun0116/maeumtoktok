import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/repositories/target_information_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class UpdateTargetInformation implements BaseUseCaseWithParam<TargetInformation, TargetInformation> {
  final TargetInformationRepository targetInformationRepository;

  UpdateTargetInformation({required this.targetInformationRepository});

  @override
  Future<TargetInformation> call(TargetInformation information) async {
    return await targetInformationRepository.update(information);
  }
}

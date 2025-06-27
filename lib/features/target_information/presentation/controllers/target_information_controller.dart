import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/usecases/read_target_information.dart';
import 'package:app/features/target_information/domain/usecases/update_target_information.dart';

import '../../../../core/base/base_controller.dart';

class TargetInformationController extends BaseController {
  final ReadTargetInformation _readTargetInformationUseCase;
  final UpdateTargetInformation _updateTargetInformationUseCase;

  TargetInformationController({
    required ReadTargetInformation readTargetInformationUseCase,
    required UpdateTargetInformation updateTargetInformationUseCase,
  }) : _updateTargetInformationUseCase = updateTargetInformationUseCase,
       _readTargetInformationUseCase = readTargetInformationUseCase;

  TargetInformation? information;

  Future<void> initialize(String targetId) async {
    information = await read(targetId);
    notifyListeners();
  }

  Future<TargetInformation> read(String id) async {
    return await callMethod<TargetInformation>(() => _readTargetInformationUseCase.call(id));
  }

  Future<void> update(TargetInformation information) async {
    await callMethod<TargetInformation>(() => _updateTargetInformationUseCase.call(information));
    this.information = information;
    notifyListeners();
  }
}

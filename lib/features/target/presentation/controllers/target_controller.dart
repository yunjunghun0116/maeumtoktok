import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/usecases/read_target.dart';
import 'package:app/features/target/domain/usecases/update_target.dart';

import '../../../../core/presentation/base_controller.dart';

class TargetController extends BaseController {
  final ReadTarget _readTargetUseCase;
  final UpdateTarget _updateTargetUseCase;

  Target? target;

  TargetController({required ReadTarget readTargetUseCase, required UpdateTarget updateTargetUseCase})
    : _updateTargetUseCase = updateTargetUseCase,
      _readTargetUseCase = readTargetUseCase;

  Future<void> initialize(Member member) async {
    target = await read(member.id);
    notifyListeners();
  }

  Future<Target> read(String id) async {
    return await callMethod<Target>(() => _readTargetUseCase.call(id));
  }

  Future<Target> update(Target target) async {
    return await callMethod<Target>(() => _updateTargetUseCase.call(target));
  }
}

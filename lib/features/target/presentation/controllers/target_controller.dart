import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/usecases/read_target_with_member_id.dart';
import 'package:app/features/target/domain/usecases/update_target.dart';

import '../../../../core/base/base_controller.dart';

class TargetState extends BaseState {
  final Target? target;

  const TargetState({this.target, super.isLoading});

  @override
  TargetState copyWith({Target? target, bool? isLoading}) {
    return TargetState(target: target ?? this.target, isLoading: isLoading ?? this.isLoading);
  }
}

class TargetController extends BaseController<TargetState> {
  final ReadTargetWithMemberId _readTargetWithMemberIdUseCase;
  final UpdateTarget _updateTargetUseCase;

  TargetController({
    required ReadTargetWithMemberId readTargetWithMemberIdUseCase,
    required UpdateTarget updateTargetUseCase,
  }) : _updateTargetUseCase = updateTargetUseCase,
       _readTargetWithMemberIdUseCase = readTargetWithMemberIdUseCase,
       super(TargetState());

  Future<void> initialize(Member member) async {
    var target = await callMethod<Target>(() => _readTargetWithMemberIdUseCase.call(member.id));
    state = state.copyWith(target: target);
  }

  Future<void> update(Target target) async {
    var updatedTarget = await callMethod<Target>(() => _updateTargetUseCase.call(target));
    state = state.copyWith(target: updatedTarget);
  }
}

import 'package:app/core/base/base_controller.dart';
import 'package:app/features/member/domain/usecases/update_member.dart';

import '../../domain/entities/member.dart';

class MemberState extends BaseState {
  final Member? member;

  const MemberState({this.member, super.isLoading});

  @override
  MemberState copyWith({Member? member, bool? isLoading}) {
    return MemberState(member: member, isLoading: isLoading ?? this.isLoading);
  }
}

class MemberController extends BaseController<MemberState> {
  final UpdateMember _updateMemberUseCase;

  MemberController({required UpdateMember updateMemberUseCase})
    : _updateMemberUseCase = updateMemberUseCase,
      super(MemberState());

  void login(Member member) {
    state = state.copyWith(member: member);
  }

  void logout() {
    state = state.copyWith(member: null);
  }

  Future<void> update(Member member) async {
    var updatedMember = await callMethod<Member>(() => _updateMemberUseCase.call(member));
    state = state.copyWith(member: updatedMember);
  }
}

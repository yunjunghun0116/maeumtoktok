import 'package:app/core/base/base_controller.dart';
import 'package:app/features/member/domain/usecases/update_member.dart';

import '../../domain/entities/member.dart';

class MemberController extends BaseController {
  final UpdateMember _updateMemberUseCase;

  Member? member;

  MemberController({required UpdateMember updateMemberUseCase}) : _updateMemberUseCase = updateMemberUseCase;

  void login(Member member) {
    this.member = member;
    notifyListeners();
  }

  void logout() {
    member = null;
    notifyListeners();
  }

  Future<void> update(Member member) async {
    this.member = await callMethod<Member>(() => _updateMemberUseCase.call(member));
    notifyListeners();
  }
}

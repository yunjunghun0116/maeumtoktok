import 'package:app/core/presentation/base_controller.dart';

import '../../domain/entities/member.dart';

class MemberController extends BaseController {
  Member? member;

  void login(Member member) {
    this.member = member;
    notifyListeners();
  }

  void logout() {
    member = null;
    notifyListeners();
  }
}

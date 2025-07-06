import 'package:app/core/domain/repositories/local_repository.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:app/shared/constants/local_repository_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/main/screens/main_screen.dart';
import '../../features/member/domain/entities/member.dart';
import '../../features/member/presentation/controllers/member_controller.dart';

final class SignUtil {
  static Future<void> login({required BuildContext context, required Member member, bool isSaveLocal = false}) async {
    // 이용자 정보 MemberController 에 저장
    context.read<MemberController>().login(member);
    if (!context.mounted) return;
    // 상대방 정보 TargetController 에 저장
    await context.read<TargetController>().initialize(member);
    if (!context.mounted) return;

    var target = context.read<TargetController>().target!;
    // 상대방과 관련된 사건 목록 TargetIssueController 에 저장
    await context.read<TargetIssueController>().initialize(target.id);
    if (!context.mounted) return;
    // 모든 작업이 완료된 후 Main 화면으로 이동함
    if (isSaveLocal) {
      await context.read<LocalRepository>().save<bool>(LocalRepositoryKey.isLoggedIn, true);
      if (!context.mounted) return;
      await context.read<LocalRepository>().save<String>(LocalRepositoryKey.memberEmail, member.email);
      if (!context.mounted) return;
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
  }
}

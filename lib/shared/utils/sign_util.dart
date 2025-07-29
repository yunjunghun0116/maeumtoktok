import 'package:app/core/providers.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/features/target_issue/providers.dart';
import 'package:app/shared/constants/local_repository_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/main/screens/main_screen.dart';
import '../../features/member/domain/entities/member.dart';
import '../../features/member/presentation/controllers/member_controller.dart';

final class SignUtil {
  static Future<void> login(
    BuildContext context, {
    required WidgetRef ref,
    required Member member,
    bool isSaveLocal = false,
  }) async {
    // 이용자 정보 MemberController 에 저장
    ref.read<MemberController>(memberControllerProvider.notifier).login(member);
    if (!context.mounted) return;
    // 상대방 정보 TargetController 에 저장
    await ref.read(targetControllerProvider.notifier).initialize(member);
    if (!context.mounted) return;

    var target = ref.read(targetControllerProvider).target!;
    // 상대방과 관련된 사건 목록 TargetIssueController 에 저장
    await ref.read(targetIssueControllerProvider.notifier).initialize(target.id);
    if (!context.mounted) return;
    // 모든 작업이 완료된 후 Main 화면으로 이동함
    if (isSaveLocal) {
      await ref.read(localRepositoryProvider).save<bool>(LocalRepositoryKey.isLoggedIn, true);
      if (!context.mounted) return;
      await ref.read(localRepositoryProvider).save<String>(LocalRepositoryKey.memberEmail, member.email);
      if (!context.mounted) return;
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
  }
}

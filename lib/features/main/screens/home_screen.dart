import 'package:app/features/member/presentation/screens/member_information_screen.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/providers.dart';
import 'package:app/shared/widgets/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/constants/app_colors.dart';
import '../../target/presentation/screens/target_information_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _getMemberInformationInputProgress() {
    var totalCnt = 3;
    var inputCnt = 0;
    var member = ref.read(memberControllerProvider).member!;
    if (member.name.isNotEmpty) inputCnt++;
    if (member.personality.isNotEmpty) inputCnt++;
    if (member.conversationStyle.isNotEmpty) inputCnt++;
    return inputCnt / totalCnt;
  }

  double _getTargetInputProgress() {
    var totalCnt = 4;
    var inputCnt = 0;
    var target = ref.read(targetControllerProvider).target!;
    if (target.name.isNotEmpty) inputCnt++;
    if (target.relationship.isNotEmpty) inputCnt++;
    if (ref.read(targetPersonalityControllerProvider).personalities.isNotEmpty) inputCnt++;
    if (target.conversationStyle.isNotEmpty) inputCnt++;
    return inputCnt / totalCnt;
  }

  double _getPositiveIssueProgress(List<TargetIssue> issues) {
    var totalCnt = 1;
    return issues.length / totalCnt;
  }

  double _getNegativeIssueProgress(List<TargetIssue> issues) {
    var totalCnt = 1;
    return issues.length / totalCnt;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "마음톡톡",
            style: TextStyle(fontSize: 28, height: 1, color: AppColors.mainColor, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        statusCard(context: context, target: ref.watch(targetControllerProvider).target!),
        SizedBox(height: 20),
        getCard(
          title: "내 정보 입력하기",
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInformationScreen())),
        ),
        getCard(
          title: "${ref.watch(targetControllerProvider).target!.name} 정보 입력하기",
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TargetInformationScreen())),
        ),
      ],
    );
  }

  Widget statusCard({required BuildContext context, required Target target}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.subColor2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          inputStatus(title: "내 정보 입력 현황", progress: _getMemberInformationInputProgress()),
          SizedBox(height: 10),
          inputStatus(title: "단절된 대상 정보 입력 현황", progress: _getTargetInputProgress()),
          SizedBox(height: 10),
          inputStatus(
            title: "긍정 기억 입력 현황",
            progress: _getPositiveIssueProgress(ref.watch(targetIssueControllerProvider).positiveIssues),
          ),
          SizedBox(height: 10),
          inputStatus(
            title: "부정 기억 입력 현황",
            progress: _getNegativeIssueProgress(ref.watch(targetIssueControllerProvider).negativeIssues),
          ),
        ],
      ),
    );
  }

  Widget inputStatus({required String title, required double progress}) {
    return Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(title, style: TextStyle(fontSize: 12, height: 20 / 12, color: AppColors.fontGray600Color)),
        ),
        Expanded(child: CommonProgressBar(progress: progress)),
      ],
    );
  }

  Widget getCard({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.subColor2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, height: 20 / 16, color: AppColors.subColor4, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

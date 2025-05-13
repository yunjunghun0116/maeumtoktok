import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/member_information/presentation/controllers/member_information_controller.dart';
import 'package:app/features/member_information/presentation/widgets/member_information_input_dialog.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_information/presentation/controllers/target_information_controller.dart';
import 'package:app/features/target_information/presentation/screens/target_information_screen.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:app/shared/widgets/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openMemberInformationDialog() async {
    var controller = context.read<MemberInformationController>();
    var information = controller.information!;
    String? result = await showDialog<String?>(
      context: context,
      builder: (context) => MemberInformationInputDialog(information: information),
    );
    if (result == null) return;
    if (!mounted) return;
    information.updateDescription(result);
    await controller.update(information);
  }

  double _getMemberInformationInputProgress(BuildContext context) {
    var recommendLength = 50;
    var information = context.read<MemberInformationController>().information;
    if (information == null || information.description.isEmpty) return 0;
    return information.description.length / recommendLength;
  }

  double _getTargetInputProgress(BuildContext context, Target target) {
    var totalCnt = 4;
    var inputCnt = 0;
    var information = context.read<TargetInformationController>().information;
    if (information != null && information.description.isNotEmpty) inputCnt++;
    if (target.name.isNotEmpty) inputCnt++;
    if (target.job.isNotEmpty) inputCnt++;
    if (target.age != 0) inputCnt++;
    return inputCnt / totalCnt;
  }

  double _getPositiveIssueProgress(BuildContext context) {
    var totalCnt = 1;
    var issues = context.read<TargetIssueController>().positiveIssues;
    return issues.length / totalCnt;
  }

  double _getNegativeIssueProgress(BuildContext context) {
    var totalCnt = 3;
    var issues = context.read<TargetIssueController>().negativeIssues;
    return issues.length / totalCnt;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MemberController, TargetController>(
      builder: (context, memberController, targetController, child) {
        if (targetController.target == null) throw CustomException(ExceptionMessage.dependencyNotInjectedException);
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
            statusCard(context: context, target: targetController.target!),
            SizedBox(height: 20),
            getCard(title: "내 정보 입력하기", onTap: () => _openMemberInformationDialog()),
            getCard(
              title: "${targetController.target?.name} 정보 입력하기",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TargetInformationScreen())),
            ),
          ],
        );
      },
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
          inputStatus(title: "내 정보 입력현황", progress: _getMemberInformationInputProgress(context)),
          SizedBox(height: 10),
          inputStatus(title: "상대방 정보 입력현황", progress: _getTargetInputProgress(context, target)),
          SizedBox(height: 10),
          inputStatus(title: "긍정 사건 입력현황", progress: _getPositiveIssueProgress(context)),
          SizedBox(height: 10),
          inputStatus(title: "부정 사건 입력현황", progress: _getNegativeIssueProgress(context)),
        ],
      ),
    );
  }

  Widget inputStatus({required String title, required double progress}) {
    return Row(
      children: [
        SizedBox(
          width: 140,
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

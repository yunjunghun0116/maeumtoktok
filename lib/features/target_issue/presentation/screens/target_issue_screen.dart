import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:app/features/target_issue/presentation/widgets/issue_input_dialog.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/input_screen.dart';

class TargetIssueScreen extends StatefulWidget {
  const TargetIssueScreen({super.key});

  @override
  State<TargetIssueScreen> createState() => _TargetIssueScreenState();
}

class _TargetIssueScreenState extends State<TargetIssueScreen> {
  void _createDialog(IssueType issueType) async {
    var result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (inputScreenContext) => InputScreen(
              title: "상대방과의 ${issueType.name} 기억",
              content: "상대방과의 기억 중\n기억에 남았던 ${issueType.name} 기억을 입력해 주세요.",
              hintText:
                  "O년전에 함께 OO에 갔었는데 그때 함께 OO을 했었고, 그 과정에서 OO한 경험을 하다보니 내 감정은 좋았어 등 상대방과의 기억 중 기억에 남았던 기억을 자세하게 입력해 주세요.",
              onTap: (String text) {
                Navigator.pop(inputScreenContext, text);
              },
            ),
      ),
    );
    if (result == null || result.isEmpty) return;
    if (!mounted) return;
    var target = context.read<TargetController>().target!;
    var controller = context.read<TargetIssueController>();
    var createIssueDto = CreateIssueDto(targetId: target.id, description: result, issueType: issueType);
    await controller.create(createIssueDto);
    await controller.initialize(target.id);
  }

  void _updateDialog(TargetIssue issue) async {
    var result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (inputScreenContext) => InputScreen(
              title: "상대방과의 ${issue.issueType.name} 기억",
              content: "상대방과의 기억 중\n기억에 남았던 ${issue.issueType.name} 기억을 입력해 주세요.",
              hintText:
                  "O년전에 함께 OO에 갔었는데 그때 함께 OO을 했었고, 그 과정에서 OO한 경험을 하다보니 내 감정은 좋았어 등 상대방과의 기억 중 기억에 남았던 기억을 자세하게 입력해 주세요.",
              onTap: (String text) {
                Navigator.pop(inputScreenContext, text);
              },
              initialValue: issue.description,
            ),
      ),
    );
    if (result == null) return;
    if (!mounted) return;
    var target = context.read<TargetController>().target!;
    var controller = context.read<TargetIssueController>();
    if (result.isEmpty) {
      await controller.delete(issue);
    } else {
      issue.updateDescription(result);
      await controller.update(issue);
    }
    await controller.initialize(target.id);
  }

  List<TargetIssue> get issuesList {
    var issueController = context.read<TargetIssueController>();
    return [...issueController.positiveIssues, ...issueController.negativeIssues, ...issueController.normalIssues];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TargetIssueController, TargetController>(
      builder: (context, issueController, targetController, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            leadingWidth: 48,
            leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                child: Icon(Icons.arrow_back_ios, size: 28),
              ),
            ),
            centerTitle: true,
            title: Text(
              '${targetController.target!.name} 와(과)의 기억',
              style: TextStyle(
                fontSize: 18,
                height: 28 / 18,
                letterSpacing: -0.5,
                color: AppColors.fontGray800Color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: AppColors.fontGray600Color),
                alignment: Alignment.center,
                child: Text(
                  "${targetController.target!.name} 와(과)의 기억은 자세하게 입력할 수록\n상대방을 더 잘 반영하여 채팅할 수 있습니다.",
                  style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.whiteColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ...issuesList.map((issue) => getIssueCard(issue: issue)).toList(),
            ],
          ),
          floatingActionButton: SpeedDial(
            children: [
              getActionChild(issueType: IssueType.normal),
              getActionChild(issueType: IssueType.negative),
              getActionChild(issueType: IssueType.positive),
            ],
            icon: Icons.add,
            backgroundColor: AppColors.mainColor,
            foregroundColor: AppColors.whiteColor,
          ),
        );
      },
    );
  }

  Widget getIssueCard({required TargetIssue issue}) {
    return GestureDetector(
      onTap: () => _updateDialog(issue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: issue.issueType.color, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(child: Text(issue.description, maxLines: 2, overflow: TextOverflow.ellipsis)),
            Text("수정", style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.fontGray400Color)),
          ],
        ),
      ),
    );
  }

  SpeedDialChild getActionChild({required IssueType issueType}) {
    return SpeedDialChild(
      onTap: () => _createDialog(issueType),
      child: Text(
        issueType.name,
        style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 14, height: 20 / 14),
      ),
      backgroundColor: issueType.color,
      shape: CircleBorder(),
    );
  }
}

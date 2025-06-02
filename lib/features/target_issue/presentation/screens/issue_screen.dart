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

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  void _createDialog(IssueType issueType) async {
    String? result = await showDialog<String?>(
      context: context,
      builder: (context) => IssueInputDialog(issueType: issueType),
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
    String? result = await showDialog<String?>(
      context: context,
      builder: (context) => IssueInputDialog(issue: issue, issueType: issue.issueType),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TargetIssueController>(
      builder: (context, controller, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              '단절된 대상과의 기억',
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
            children:
                [
                  ...controller.positiveIssues,
                  ...controller.negativeIssues,
                  ...controller.normalIssues,
                ].map((issue) => getIssueCard(issue: issue)).toList(),
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

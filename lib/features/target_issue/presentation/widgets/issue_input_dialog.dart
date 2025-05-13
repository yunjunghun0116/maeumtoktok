import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';

class IssueInputDialog extends StatefulWidget {
  final IssueType issueType;
  final TargetIssue? issue;

  const IssueInputDialog({super.key, this.issue, required this.issueType});

  @override
  State<IssueInputDialog> createState() => _IssueInputDialogState();
}

class _IssueInputDialogState extends State<IssueInputDialog> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.issue != null) {
      _descriptionController.text = widget.issue!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${widget.issueType.name} 사건 추가하기",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.fontGray800Color,
                    fontWeight: FontWeight.bold,
                    height: 20 / 16,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "상대방과의 사건(과거) 중\n기억에 남는 사건(과거)를 입력해 주세요.",
              style: TextStyle(fontSize: 14, color: AppColors.fontGray600Color, height: 20 / 14),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  minLines: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "예)\n내가 00살일 때\n00에서 00과 같은 일이 있었는데\n그때 내 감정은 ~~과 같았어.",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    counterText: '',
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.fontGray400Color, height: 20 / 14),
                  ),
                  style: TextStyle(fontSize: 14, color: AppColors.fontGray800Color, height: 20 / 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CommonButton(
              value: true,
              onTap: () => Navigator.of(context).pop(_descriptionController.text),
              title: "입력 완료",
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app/core/logging/report/report_type.dart';
import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportType? _selectedReportType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "채팅 내용 신고하기",
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
            SizedBox(height: 20),
            ...ReportType.values.map((reportType) => _reportButton(reportType)).toList(),
            Spacer(),
            CommonButton(
              value: _selectedReportType != null,
              onTap: () {
                if (_selectedReportType == null) return;
                Navigator.pop(context, _selectedReportType);
              },
              title: "신고하기",
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportButton(ReportType reportType) {
    var isSelected = _selectedReportType == reportType;
    return GestureDetector(
      onTap: () => setState(() => _selectedReportType = reportType),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: isSelected ? null : Border.all(color: AppColors.fontGray400Color),
          color: isSelected ? AppColors.mainColor : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          reportType.title,
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: isSelected ? AppColors.whiteColor : AppColors.fontGray600Color,
          ),
        ),
      ),
    );
  }
}

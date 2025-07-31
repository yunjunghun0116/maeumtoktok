import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/widgets/common_button.dart';

class DeleteDialog extends StatelessWidget {
  final String value;
  final String title;
  final String contents;

  const DeleteDialog({super.key, required this.value, required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
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
            Spacer(),
            Text(contents, style: TextStyle(fontSize: 14, color: AppColors.fontGray600Color, height: 20 / 14)),
            Spacer(),
            CommonButton(value: true, onTap: () => Navigator.of(context).pop(true), title: "삭제"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/widgets/common_button.dart';

class InvitationDialog extends StatefulWidget {
  const InvitationDialog({super.key});

  @override
  State<InvitationDialog> createState() => _InvitationDialogState();
}

class _InvitationDialogState extends State<InvitationDialog> {
  final _invitationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "초대코드 입력하기",
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
              "회원가입을 위해 발급받은\n6글자의 초대코드를 입력해 주세요.",
              style: TextStyle(fontSize: 14, color: AppColors.fontGray600Color, height: 20 / 14),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _invitationCodeController,
                maxLines: 1,
                maxLength: 6,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "예)ABCDEF",
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
            Spacer(),
            CommonButton(
              value: true,
              onTap: () => Navigator.of(context).pop(_invitationCodeController.text),
              title: "입력 완료",
            ),
          ],
        ),
      ),
    );
  }
}

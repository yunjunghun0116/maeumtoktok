import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';

class MemberPersonalityDialog extends StatefulWidget {
  const MemberPersonalityDialog({super.key});

  @override
  State<MemberPersonalityDialog> createState() => _MemberPersonalityDialogState();
}

class _MemberPersonalityDialogState extends State<MemberPersonalityDialog> {
  final _personalityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var member = context.read<MemberController>().member!;
    _personalityController.text = member.personality;
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
                  "내 성격",
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
              "상대방이 보았을 때, 나의 성격은 어떤것 같나요?\n내 성격을 입력해 주세요.",
              style: TextStyle(fontSize: 14, color: AppColors.fontGray600Color, height: 20 / 14),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _personalityController,
                  maxLines: null,
                  minLines: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText:
                        "밝고 긍정적인 성격, 내성적이고 말이 적은 편, 감정을 잘 숨기지 않음, 주변을 잘 챙김, 단호하고 상대방을 신경쓰지 않음 등 내 성격이 잘 드러나도록 자세하게 입력해 주세요. ",
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
              onTap: () {
                if (_personalityController.text.length < 20) {
                  throw CustomException(ExceptionMessage.needMorePersonality);
                }
                Navigator.of(context).pop(_personalityController.text);
              },
              title: "입력 완료",
            ),
          ],
        ),
      ),
    );
  }
}

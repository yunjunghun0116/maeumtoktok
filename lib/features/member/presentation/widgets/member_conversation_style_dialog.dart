import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';

class MemberConversationStyleDialog extends StatefulWidget {
  const MemberConversationStyleDialog({super.key});

  @override
  State<MemberConversationStyleDialog> createState() => _MemberConversationStyleDialogState();
}

class _MemberConversationStyleDialogState extends State<MemberConversationStyleDialog> {
  final _conversationStyleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var member = context.read<MemberController>().member!;
    _conversationStyleController.text = member.conversationStyle;
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
                  "내 말투나 대화 스타일",
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
              "상대방과 대화할 때 사용하는 \n나의 평소 말투나 대화 스타일을 \n자세하게 입력해 주세요.",
              style: TextStyle(fontSize: 14, color: AppColors.fontGray600Color, height: 20 / 14),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _conversationStyleController,
                  maxLines: null,
                  minLines: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText:
                        "퉁명스러운 말투, 차가운 말투, 장난스러운 말투, 친구스러운 대화, 시크하게, 유머러스하게, 조용히 공감하는 스타일, 고민을 많이 들어주는 스타일 등 상대방과 대화할 때의 내 말투나 대화 스타일을 자세하게 입력해 주세요. ",
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
                if (_conversationStyleController.text.length < 20) {
                  throw CustomException(ExceptionMessage.needMoreConversationStyle);
                }
                Navigator.of(context).pop(_conversationStyleController.text);
              },
              title: "입력 완료",
            ),
          ],
        ),
      ),
    );
  }
}

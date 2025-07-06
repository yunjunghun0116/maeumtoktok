import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';

class TargetPersonalityDialog extends StatefulWidget {
  const TargetPersonalityDialog({super.key});

  @override
  State<TargetPersonalityDialog> createState() => _TargetPersonalityDialogState();
}

class _TargetPersonalityDialogState extends State<TargetPersonalityDialog> {
  final _personalityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var target = context.read<TargetController>().target!;
    _personalityController.text = target.personality;
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
                  "상대방의 성격",
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
              "상대방이 나와 있을 때 보여지는\n상대방의 성격을 구체적으로 입력해 주세요.",
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
                        "밝고 긍정적인 성격, 내성적이고 말이 적은 편, 작은 일에도 잘 신경을 씀, 감정을 잘 숨기지 않음, 유머 감각이 있음, 항상 신중함, 주변을 잘 챙김 등 상대방의 성격이 잘 드러나도록 자세하게 입력해 주세요. ",
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

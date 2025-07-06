import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';

class TargetAdditionalDescriptionDialog extends StatefulWidget {
  const TargetAdditionalDescriptionDialog({super.key});

  @override
  State<TargetAdditionalDescriptionDialog> createState() => _TargetAdditionalDescriptionDialogState();
}

class _TargetAdditionalDescriptionDialogState extends State<TargetAdditionalDescriptionDialog> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = context.read<TargetController>().target!.additionalDescription;
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
                  "추가 정보 입력하기",
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
              "상대방의 성격, 말투 및 대화 스타일 외에\n상대방에 대해 기억나는 다양한 추가 정보에\n대해 자유롭게 입력해 주세요.",
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
                    hintText:
                        "말끝마다 '아니, 근데 있잖아~'라고 말해요, 같이 여행을 가면 사진을 엄청 많이 찍어요, 배가 고프면 기분이 엄청 나빠지거나 우울해져요 등 \n평소에 자주 쓰는 말이나 행동, 나와의 인상 깊은 에피소드, 현재는 어떤 상태로 지내는 지 등 상대방에 대해 기억나는 정보를 자유롭게 입력해 주세요.",
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

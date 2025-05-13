import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';

class TargetInformationInputDialog extends StatefulWidget {
  final TargetInformation information;

  const TargetInformationInputDialog({super.key, required this.information});

  @override
  State<TargetInformationInputDialog> createState() => _TargetInformationInputDialogState();
}

class _TargetInformationInputDialogState extends State<TargetInformationInputDialog> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.information.description;
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
              "상대방에 대한 성격이나\n나와 상대방과의 관계를 입력해 주세요.",
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
                    hintText: "예)\n내 아버지 이고\n성격은 엄하시고 단호하시고 ...\n같이 상대방에 대한 정보를\n자세히 적어주면 더 좋아요. :)",
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

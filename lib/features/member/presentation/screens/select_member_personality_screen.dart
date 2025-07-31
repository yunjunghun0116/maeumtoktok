import 'package:app/features/member/providers.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/constants/app_values.dart';
import 'package:app/shared/utils/local_util.dart';
import 'package:app/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectMemberPersonalityScreen extends ConsumerWidget {
  const SelectMemberPersonalityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "내 성격"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "상대방과 함께 있을 때 보여지는 내 성격을 선택해 주세요.\n많이 선택할수록 상대방이 나를 더 잘 이해할 수 있습니다.",
              style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.fontGray800Color),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  AppValues.personalities
                      .map(
                        (personality) => getPersonalityItem(
                          context,
                          personality: personality,
                          contains: ref.watch(memberPersonalityControllerProvider).contains(personality),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPersonalityItem(BuildContext context, {required String personality, required bool contains}) {
    return GestureDetector(
      onTap: () {
        if (contains) {
          LocalUtil.showMessage(context, message: "이미 선택된 성격 입니다.");
          return;
        }
        Navigator.pop(context, personality);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: contains ? AppColors.mainColor : AppColors.subColor1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          personality,
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: contains ? AppColors.fontGray800Color : AppColors.fontGray400Color,
          ),
        ),
      ),
    );
  }
}

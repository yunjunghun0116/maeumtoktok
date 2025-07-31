import 'package:app/features/member/data/models/create_member_personality_dto.dart';
import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/presentation/screens/select_member_personality_screen.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/domain/custom_input_type.dart';
import 'package:app/shared/widgets/common_app_bar.dart';
import 'package:app/shared/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/widgets/input_screen.dart';

class MemberPersonalityScreen extends ConsumerStatefulWidget {
  const MemberPersonalityScreen({super.key});

  @override
  ConsumerState<MemberPersonalityScreen> createState() => _MemberPersonalityScreenScreenState();
}

class _MemberPersonalityScreenScreenState extends ConsumerState<MemberPersonalityScreen> {
  var _isLoading = false;

  void _createPersonality() async {
    try {
      if (_isLoading) return;
      var result = await Navigator.push<String?>(
        context,
        MaterialPageRoute(
          builder:
              (inputScreenContext) => InputScreen(
                title: "내 성격",
                content:
                    "밝고 긍정적인 성격, 내성적이고 말이 적은 편, 작은 일에도 잘 신경을 씀, 감정을 잘 숨기지 않음, 유머 감각이 있음, 항상 신중함, 주변을 잘 챙김 등 내 성격이 잘 드러나도록 자세하게 입력해 주세요. ",
                hintText: "상대방과 함께 있을 때 보여지는\n내 성격을 구체적으로 입력해 주세요.",
                onTap: (String text) {
                  if (text.isEmpty) {
                    throw CustomException(ExceptionMessage.needMorePersonality);
                  }
                  Navigator.pop(inputScreenContext, text);
                },
                initialValue: "",
              ),
        ),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);

      var createMemberPersonalityDto = CreateMemberPersonalityDto(
        memberId: ref.read(memberControllerProvider).member!.id,
        inputType: CustomInputType.text,
        value: result,
      );
      await ref.read(memberPersonalityControllerProvider.notifier).create(createMemberPersonalityDto);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectPersonality() async {
    try {
      if (_isLoading) return;
      var result = await Navigator.push<String?>(
        context,
        MaterialPageRoute(builder: (inputScreenContext) => SelectMemberPersonalityScreen()),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var createMemberPersonalityDto = CreateMemberPersonalityDto(
        memberId: ref.read(memberControllerProvider).member!.id,
        inputType: CustomInputType.button,
        value: result,
      );
      await ref.read(memberPersonalityControllerProvider.notifier).create(createMemberPersonalityDto);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "내 성격"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "상대방과 함께 있을 때의 나의 성격을 자세하게 입력해 주세요.\n자세히 입력할 수록 상대방이 나를 더 잘 이해할 수 있습니다.",
              style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.fontGray800Color),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ref
                      .watch(memberPersonalityControllerProvider)
                      .personalities
                      .map((personality) => getPersonalityItem(personality))
                      .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        children: [getActionChild(inputType: CustomInputType.text), getActionChild(inputType: CustomInputType.button)],
        icon: Icons.add,
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.whiteColor,
      ),
    );
  }

  SpeedDialChild getActionChild({required CustomInputType inputType}) {
    return SpeedDialChild(
      onTap: () {
        if (inputType == CustomInputType.text) {
          _createPersonality();
          return;
        }
        _selectPersonality();
      },
      child: Text(
        inputType.name,
        style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 14, height: 20 / 14),
      ),
      backgroundColor: AppColors.mainColor,
      shape: CircleBorder(),
    );
  }

  Widget getPersonalityItem(MemberPersonality memberPersonality) {
    return GestureDetector(
      onLongPress: () async {
        var result = await showDialog<bool?>(
          context: context,
          builder:
              (context) => DeleteDialog(
                value: memberPersonality.value,
                title: "내 성격을 삭제하시겠습니까?",
                contents: "내 성격 중 '${memberPersonality.value}'을(를)\n삭제하시겠습니까?",
              ),
        );
        if (result == null || !result) return;
        await ref.read(memberPersonalityControllerProvider.notifier).delete(memberPersonality);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(memberPersonality.value),
      ),
    );
  }
}

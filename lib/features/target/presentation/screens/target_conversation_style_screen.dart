import 'package:app/features/target/data/models/create_target_conversation_style_dto.dart';
import 'package:app/features/target/data/models/create_target_personality_dto.dart';
import 'package:app/features/target/domain/entities/conversation_style_type.dart';
import 'package:app/features/target/domain/entities/personality_type.dart';
import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/presentation/screens/select_target_conversation_style_screen.dart';
import 'package:app/features/target/presentation/screens/select_target_personality_screen.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/widgets/common_app_bar.dart';
import 'package:app/shared/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/widgets/input_screen.dart';

class TargetConversationStyleScreen extends ConsumerStatefulWidget {
  const TargetConversationStyleScreen({super.key});

  @override
  ConsumerState<TargetConversationStyleScreen> createState() => _TargetConversationStyleScreenState();
}

class _TargetConversationStyleScreenState extends ConsumerState<TargetConversationStyleScreen> {
  var _isLoading = false;

  void _createConversationStyle() async {
    try {
      if (_isLoading) return;
      var result = await Navigator.push<String?>(
        context,
        MaterialPageRoute(
          builder:
              (inputScreenContext) => InputScreen(
                title: "상대방의 말투나 대화 스타일",
                content:
                    "퉁명스러운 말투, 차가운 말투, 장난스러운 말투, 친구스러운 대화, 시크하게, 유머러스하게, 조용히 공감하는 스타일, 고민을 많이 들어주는 스타일 등 상대방의 말투나 대화 스타일을 자세하게 입력해 주세요. ",
                hintText: "상대방이 나와 대화할 때 사용하는 \n상대방의 평소 말투나 대화 스타일을 \n자세하게 입력해 주세요.",

                onTap: (String text) {
                  if (text.isEmpty) {
                    throw CustomException(ExceptionMessage.needMoreConversationStyle);
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

      var createTargetConversationStyleDto = CreateTargetConversationStyleDto(
        targetId: ref.read(targetControllerProvider).target!.id,
        conversationStyleType: ConversationStyleType.text,
        value: result,
      );
      await ref.read(targetConversationStyleControllerProvider.notifier).create(createTargetConversationStyleDto);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectConversationStyle() async {
    try {
      if (_isLoading) return;
      var result = await Navigator.push<String?>(
        context,
        MaterialPageRoute(builder: (inputScreenContext) => SelectTargetConversationStyleScreen()),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var createTargetConversationStyleDto = CreateTargetConversationStyleDto(
        targetId: ref.read(targetControllerProvider).target!.id,
        conversationStyleType: ConversationStyleType.button,
        value: result,
      );
      await ref.read(targetConversationStyleControllerProvider.notifier).create(createTargetConversationStyleDto);
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
      appBar: CommonAppBar(title: "상대방의 말투 및 대화 스타일"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "상대방이 나와 대화할 때 사용하는 평소 말투나\n대화 스타일을 자세하게 입력해 주세요.\n자세히 입력할 수록 상대방을 더 잘 이해할 수 있습니다.",
              style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.fontGray800Color),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ref
                      .watch(targetConversationStyleControllerProvider)
                      .conversationStyles
                      .map((conversationStyle) => getConversationStyleItem(conversationStyle))
                      .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        children: [
          getActionChild(conversationStyleType: ConversationStyleType.text),
          getActionChild(conversationStyleType: ConversationStyleType.button),
        ],
        icon: Icons.add,
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.whiteColor,
      ),
    );
  }

  SpeedDialChild getActionChild({required ConversationStyleType conversationStyleType}) {
    return SpeedDialChild(
      onTap: () {
        if (conversationStyleType == ConversationStyleType.text) {
          _createConversationStyle();
          return;
        }
        _selectConversationStyle();
      },
      child: Text(
        conversationStyleType.name,
        style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 14, height: 20 / 14),
      ),
      backgroundColor: AppColors.mainColor,
      shape: CircleBorder(),
    );
  }

  Widget getConversationStyleItem(TargetConversationStyle conversationStyle) {
    return GestureDetector(
      onLongPress: () async {
        var result = await showDialog<bool?>(
          context: context,
          builder:
              (context) => DeleteDialog(
                value: conversationStyle.value,
                title: "상대방의 말투 및 대화 스타일을 삭제하시겠습니까?",
                contents: "상대방의 말투 및 대화 스타일 중 '${conversationStyle.value}'을(를)\n삭제하시겠습니까?",
              ),
        );
        if (result == null || !result) return;
        await ref.read(targetConversationStyleControllerProvider.notifier).delete(conversationStyle);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(conversationStyle.value),
      ),
    );
  }
}

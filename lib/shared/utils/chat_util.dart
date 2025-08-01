import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/providers.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/features/target_issue/providers.dart';
import 'package:app/shared/domain/custom_input_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/exceptions/custom_exception.dart';
import '../../core/exceptions/exception_message.dart';
import '../../features/chat/data/models/create_chat_dto.dart';
import '../../features/chat/data/models/exists_chat_dto.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/member/domain/entities/member.dart';
import '../../features/target/domain/entities/target.dart';

final class ChatUtil {
  static int calculateDelay(String message) {
    if (message.length < 10) {
      return 3;
    }
    if (message.length < 60) {
      return (message.length / 4).toInt();
    }
    return 15;
  }

  static int calculateRemainDelay(Message message, int delay) {
    int realtimeDifference = DateTime.now().difference(message.timeStamp).inSeconds;
    return delay - realtimeDifference; // 남은시간, 만약 남은시간이 없을 경우 result는 음수가 된다.
  }

  static Future<void> goToChatScreen(
    BuildContext context, {
    required WidgetRef ref,
    required Member member,
    required Target target,
  }) async {
    _validateRequiredFields(ref);

    var existsChatDto = ExistsChatDto(memberId: member.id, targetId: target.id);
    var existsChat = await ref.read(chatControllerProvider.notifier).exists(existsChatDto);

    if (!existsChat) {
      if (!context.mounted) return;
      var createChatDto = CreateChatDto(member: member, target: target);
      await ref.read(chatControllerProvider.notifier).create(createChatDto);
    }
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
  }

  static void _validateRequiredFields(WidgetRef ref) {
    _validateMember(ref);
    _validateTarget(ref);
    _validateTargetIssues(ref);
  }

  static void _validateMember(WidgetRef ref) {
    var member = ref.read(memberControllerProvider).member;
    var memberPersonalities = ref.read(memberPersonalityControllerProvider).personalities;
    var memberConversationStyles = ref.read(memberConversationStyleControllerProvider).conversationStyles;
    if (member == null) throw CustomException(ExceptionMessage.noObjectAssigned);
    if (member.name.isEmpty) throw CustomException(ExceptionMessage.memberNameRequired);
    if (memberPersonalities.isEmpty) throw CustomException(ExceptionMessage.memberPersonalityRequired);
    if (memberConversationStyles.isEmpty) throw CustomException(ExceptionMessage.memberConversationStyleRequired);
  }

  static void _validateTarget(WidgetRef ref) {
    var target = ref.read(targetControllerProvider).target;
    var targetPersonalities = ref.read(targetPersonalityControllerProvider).personalities;
    var targetConversationStyles = ref.read(targetConversationStyleControllerProvider).conversationStyles;
    if (target == null) throw CustomException(ExceptionMessage.noObjectAssigned);
    if (target.name.isEmpty) throw CustomException(ExceptionMessage.targetNameRequired);
    if (target.relationship.isEmpty) throw CustomException(ExceptionMessage.targetRelationshipRequired);
    if (targetPersonalities.isEmpty) throw CustomException(ExceptionMessage.targetPersonalityRequired);
    if (!targetPersonalities.any((personality) => personality.inputType == CustomInputType.text)) {
      throw CustomException(ExceptionMessage.targetTextTypePersonalityRequired);
    }
    if (targetConversationStyles.isEmpty) throw CustomException(ExceptionMessage.targetConversationStyleRequired);
  }

  static void _validateTargetIssues(WidgetRef ref) {
    var positiveIssues = ref.read(targetIssueControllerProvider).positiveIssues;
    var negativeIssues = ref.read(targetIssueControllerProvider).negativeIssues;
    if (positiveIssues.isEmpty) {
      throw CustomException(ExceptionMessage.targetPositiveIssueRequired);
    }
    if (negativeIssues.isEmpty) {
      throw CustomException(ExceptionMessage.targetNegativeIssueRequired);
    }
  }
}

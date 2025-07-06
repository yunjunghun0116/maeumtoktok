import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/exceptions/custom_exception.dart';
import '../../core/exceptions/exception_message.dart';
import '../../features/chat/data/models/create_chat_dto.dart';
import '../../features/chat/data/models/exists_chat_dto.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/member/domain/entities/member.dart';
import '../../features/target/domain/entities/target.dart';
import '../../features/target_issue/presentation/controllers/target_issue_controller.dart';

final class ChatUtil {
  static int calculateDelay(String message) {
    if (message.length < 10) {
      return 3;
    }
    if (message.length < 100) {
      return (message.length / 3).toInt();
    }
    return 30;
  }

  static int calculateRemainDelay(Message message, int delay) {
    int realtimeDifference = DateTime.now().difference(message.timeStamp).inSeconds;
    return delay - realtimeDifference; // 남은시간, 만약 남은시간이 없을 경우 result는 음수가 된다.
  }

  static Future<void> goToChatScreen(Member member, Target target, BuildContext context) async {
    _validateRequiredFields(context);

    var existsChatDto = ExistsChatDto(memberId: member.id, targetId: target.id);
    var existsChat = await context.read<ChatController>().exists(existsChatDto);

    if (!existsChat) {
      if (!context.mounted) return;
      var createChatDto = CreateChatDto(member: member, target: target);
      await context.read<ChatController>().create(createChatDto);
    }
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
  }

  static void _validateRequiredFields(BuildContext context) {
    _validateMember(context);
    _validateTarget(context);
    _validateTargetIssues(context);
  }

  static void _validateMember(BuildContext context) {
    var member = context.read<MemberController>().member;
    if (member == null) throw CustomException(ExceptionMessage.noObjectAssigned);
    if (member.name.isEmpty) throw CustomException(ExceptionMessage.memberNameRequired);
    if (member.personality.isEmpty) throw CustomException(ExceptionMessage.memberPersonalityRequired);
    if (member.conversationStyle.isEmpty) throw CustomException(ExceptionMessage.memberConversationStyleRequired);
  }

  static void _validateTarget(BuildContext context) {
    var target = context.read<TargetController>().target;
    if (target == null) throw CustomException(ExceptionMessage.noObjectAssigned);
    if (target.name.isEmpty) throw CustomException(ExceptionMessage.targetNameRequired);
    if (target.relationship.isEmpty) throw CustomException(ExceptionMessage.targetRelationshipRequired);
    if (target.personality.isEmpty) throw CustomException(ExceptionMessage.targetPersonalityRequired);
    if (target.conversationStyle.isEmpty) throw CustomException(ExceptionMessage.targetConversationStyleRequired);
  }

  static void _validateTargetIssues(BuildContext context) {
    var positiveIssues = context.read<TargetIssueController>().positiveIssues;
    var negativeIssues = context.read<TargetIssueController>().negativeIssues;
    if (positiveIssues.isEmpty) {
      throw CustomException(ExceptionMessage.targetPositiveIssueRequired);
    }
    if (negativeIssues.isEmpty) {
      throw CustomException(ExceptionMessage.targetNegativeIssueRequired);
    }
  }
}

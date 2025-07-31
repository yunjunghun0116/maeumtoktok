import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member/domain/entities/member_conversation_style.dart';
import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LangchainDto {
  final Target target;
  final List<TargetPersonality> targetPersonalities;
  final List<TargetConversationStyle> targetConversationStyles;
  final Member member;
  final List<MemberPersonality> memberPersonalities;
  final List<MemberConversationStyle> memberConversationStyles;
  final List<TargetIssue> positiveIssues;
  final List<TargetIssue> negativeIssues;
  final List<TargetIssue> normalIssues;
  final List<Message> messages;
  final String conversationsContext;
  final String message;

  LangchainDto({
    required this.target,
    required this.targetPersonalities,
    required this.targetConversationStyles,
    required this.member,
    required this.memberPersonalities,
    required this.memberConversationStyles,
    required this.positiveIssues,
    required this.negativeIssues,
    required this.normalIssues,
    required this.messages,
    required this.conversationsContext,
    required this.message,
  });

  factory LangchainDto.fromWidgetRef({
    required WidgetRef ref,
    required String conversationsContext,
    required List<Message> messages,
    required String message,
  }) {
    var target = ref.read(targetControllerProvider).target!;
    var targetPersonalities = ref.read(targetPersonalityControllerProvider).personalities;
    var targetConversationStyles = ref.read(targetConversationStyleControllerProvider).conversationStyles;
    var member = ref.read(memberControllerProvider).member!;
    var memberPersonalities = ref.read(memberPersonalityControllerProvider).personalities;
    var memberConversationStyles = ref.read(memberConversationStyleControllerProvider).conversationStyles;
    var issueProvider = ref.read(targetIssueControllerProvider);
    return LangchainDto(
      target: target,
      targetPersonalities: targetPersonalities,
      targetConversationStyles: targetConversationStyles,
      member: member,
      memberPersonalities: memberPersonalities,
      memberConversationStyles: memberConversationStyles,
      positiveIssues: issueProvider.positiveIssues,
      negativeIssues: issueProvider.negativeIssues,
      normalIssues: issueProvider.normalIssues,
      messages: messages,
      conversationsContext: conversationsContext,
      message: message,
    );
  }
}

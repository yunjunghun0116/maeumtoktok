import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';

class LangchainDto {
  final Target target;
  final Member member;
  final List<TargetIssue> positiveIssues;
  final List<TargetIssue> negativeIssues;
  final List<TargetIssue> normalIssues;
  final List<Message> messages;
  final String conversationsContext;
  final String message;

  LangchainDto({
    required this.target,
    required this.member,
    required this.positiveIssues,
    required this.negativeIssues,
    required this.normalIssues,
    required this.messages,
    required this.conversationsContext,
    required this.message,
  });

  factory LangchainDto.fromObject({
    required Target target,
    required Member member,
    required List<TargetIssue> positiveIssues,
    required List<TargetIssue> negativeIssues,
    required List<TargetIssue> normalIssues,
    required List<Message> messages,
    required String conversationsContext,
    required String message,
  }) {
    return LangchainDto(
      target: target,
      member: member,
      positiveIssues: positiveIssues,
      negativeIssues: negativeIssues,
      normalIssues: normalIssues,
      messages: messages,
      conversationsContext: conversationsContext,
      message: message,
    );
  }
}

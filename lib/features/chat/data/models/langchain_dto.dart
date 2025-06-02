import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';

class LangchainDto {
  final Target target;
  final MemberInformation memberInformation;
  final TargetInformation targetInformation;
  final List<TargetIssue> positiveIssues;
  final List<TargetIssue> negativeIssues;
  final List<TargetIssue> normalIssues;
  final List<Message> messages;
  final String conversationsContext;
  final String message;

  LangchainDto({
    required this.target,
    required this.memberInformation,
    required this.targetInformation,
    required this.positiveIssues,
    required this.negativeIssues,
    required this.normalIssues,
    required this.messages,
    required this.conversationsContext,
    required this.message,
  });

  factory LangchainDto.fromObject({
    required Target target,
    required MemberInformation memberInformation,
    required TargetInformation targetInformation,
    required List<TargetIssue> positiveIssues,
    required List<TargetIssue> negativeIssues,
    required List<TargetIssue> normalIssues,
    required List<Message> messages,
    required String conversationsContext,
    required String message,
  }) {
    return LangchainDto(
      target: target,
      memberInformation: memberInformation,
      targetInformation: targetInformation,
      positiveIssues: positiveIssues,
      negativeIssues: negativeIssues,
      normalIssues: normalIssues,
      messages: messages,
      conversationsContext: conversationsContext,
      message: message,
    );
  }
}

import 'package:app/features/target_issue/data/models/create_issue_dto.dart';
import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_issue.g.dart';

@JsonSerializable()
class TargetIssue {
  final String id;
  final String targetId;
  final IssueType issueType;
  String description;

  TargetIssue({required this.id, required this.targetId, required this.issueType, required this.description});

  factory TargetIssue.fromJson(Map<String, dynamic> json) => _$TargetIssueFromJson(json);

  factory TargetIssue.fromDto(String id, CreateIssueDto createIssueDto) {
    return TargetIssue(
      id: id,
      targetId: createIssueDto.targetId,
      issueType: createIssueDto.issueType,
      description: createIssueDto.description,
    );
  }

  Map<String, dynamic> toJson() => _$TargetIssueToJson(this);

  void updateDescription(String description) {
    this.description = description;
  }

  @override
  String toString() {
    return 'TargetIssue{id: $id, targetId: $targetId, issueType: ${issueType.type}, description: $description}';
  }
}

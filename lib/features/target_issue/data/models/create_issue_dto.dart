import 'package:app/features/target_issue/domain/entities/issue_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_issue_dto.g.dart';

@JsonSerializable()
class CreateIssueDto {
  final String targetId;
  final IssueType issueType;
  final String description;

  CreateIssueDto({required this.targetId, required this.issueType, required this.description});

  factory CreateIssueDto.fromJson(Map<String, dynamic> json) => _$CreateIssueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIssueDtoToJson(this);
}

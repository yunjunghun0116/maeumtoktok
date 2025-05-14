// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetIssue _$TargetIssueFromJson(Map<String, dynamic> json) => TargetIssue(
  id: json['id'] as String,
  targetId: json['targetId'] as String,
  issueType: $enumDecode(_$IssueTypeEnumMap, json['issueType']),
  description: json['description'] as String,
);

Map<String, dynamic> _$TargetIssueToJson(TargetIssue instance) => <String, dynamic>{
  'id': instance.id,
  'targetId': instance.targetId,
  'issueType': _$IssueTypeEnumMap[instance.issueType]!,
  'description': instance.description,
};

const _$IssueTypeEnumMap = {IssueType.positive: 'positive', IssueType.negative: 'negative', IssueType.normal: 'normal'};

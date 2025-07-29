// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_personality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetPersonality _$TargetPersonalityFromJson(Map<String, dynamic> json) => TargetPersonality(
  id: json['id'] as String,
  targetId: json['targetId'] as String,
  personalityType: $enumDecode(_$PersonalityTypeEnumMap, json['personalityType']),
  value: json['value'] as String,
);

Map<String, dynamic> _$TargetPersonalityToJson(TargetPersonality instance) => <String, dynamic>{
  'id': instance.id,
  'targetId': instance.targetId,
  'personalityType': _$PersonalityTypeEnumMap[instance.personalityType]!,
  'value': instance.value,
};

const _$PersonalityTypeEnumMap = {PersonalityType.button: 'button', PersonalityType.text: 'text'};

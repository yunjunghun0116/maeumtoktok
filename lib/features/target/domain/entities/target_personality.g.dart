// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_personality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetPersonality _$TargetPersonalityFromJson(Map<String, dynamic> json) => TargetPersonality(
  id: json['id'] as String,
  targetId: json['targetId'] as String,
  inputType: $enumDecode(_$CustomInputTypeEnumMap, json['inputType']),
  value: json['value'] as String,
);

Map<String, dynamic> _$TargetPersonalityToJson(TargetPersonality instance) => <String, dynamic>{
  'id': instance.id,
  'targetId': instance.targetId,
  'inputType': _$CustomInputTypeEnumMap[instance.inputType]!,
  'value': instance.value,
};

const _$CustomInputTypeEnumMap = {CustomInputType.button: 'button', CustomInputType.text: 'text'};

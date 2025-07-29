// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_target_personality_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTargetPersonalityDto _$CreateTargetPersonalityDtoFromJson(Map<String, dynamic> json) =>
    CreateTargetPersonalityDto(
      targetId: json['targetId'] as String,
      personalityType: $enumDecode(_$PersonalityTypeEnumMap, json['personalityType']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$CreateTargetPersonalityDtoToJson(CreateTargetPersonalityDto instance) => <String, dynamic>{
  'targetId': instance.targetId,
  'personalityType': _$PersonalityTypeEnumMap[instance.personalityType]!,
  'value': instance.value,
};

const _$PersonalityTypeEnumMap = {PersonalityType.button: 'button', PersonalityType.text: 'text'};

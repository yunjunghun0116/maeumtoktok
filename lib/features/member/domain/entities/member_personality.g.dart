// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_personality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberPersonality _$MemberPersonalityFromJson(Map<String, dynamic> json) =>
    MemberPersonality(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      inputType: $enumDecode(_$CustomInputTypeEnumMap, json['inputType']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$MemberPersonalityToJson(MemberPersonality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'inputType': _$CustomInputTypeEnumMap[instance.inputType]!,
      'value': instance.value,
    };

const _$CustomInputTypeEnumMap = {
  CustomInputType.button: 'button',
  CustomInputType.text: 'text',
};

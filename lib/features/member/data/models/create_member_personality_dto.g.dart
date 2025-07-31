// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_member_personality_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMemberPersonalityDto _$CreateMemberPersonalityDtoFromJson(Map<String, dynamic> json) =>
    CreateMemberPersonalityDto(
      memberId: json['memberId'] as String,
      inputType: $enumDecode(_$CustomInputTypeEnumMap, json['inputType']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$CreateMemberPersonalityDtoToJson(CreateMemberPersonalityDto instance) => <String, dynamic>{
  'memberId': instance.memberId,
  'inputType': _$CustomInputTypeEnumMap[instance.inputType]!,
  'value': instance.value,
};

const _$CustomInputTypeEnumMap = {CustomInputType.button: 'button', CustomInputType.text: 'text'};

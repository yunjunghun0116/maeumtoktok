// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_member_conversation_style_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMemberConversationStyleDto _$CreateMemberConversationStyleDtoFromJson(Map<String, dynamic> json) =>
    CreateMemberConversationStyleDto(
      memberId: json['memberId'] as String,
      inputType: $enumDecode(_$CustomInputTypeEnumMap, json['inputType']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$CreateMemberConversationStyleDtoToJson(CreateMemberConversationStyleDto instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'inputType': _$CustomInputTypeEnumMap[instance.inputType]!,
      'value': instance.value,
    };

const _$CustomInputTypeEnumMap = {CustomInputType.button: 'button', CustomInputType.text: 'text'};

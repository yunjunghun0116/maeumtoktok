// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_target_conversation_style_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTargetConversationStyleDto _$CreateTargetConversationStyleDtoFromJson(
  Map<String, dynamic> json,
) => CreateTargetConversationStyleDto(
  targetId: json['targetId'] as String,
  conversationStyleType: $enumDecode(
    _$ConversationStyleTypeEnumMap,
    json['conversationStyleType'],
  ),
  value: json['value'] as String,
);

Map<String, dynamic> _$CreateTargetConversationStyleDtoToJson(
  CreateTargetConversationStyleDto instance,
) => <String, dynamic>{
  'targetId': instance.targetId,
  'conversationStyleType':
      _$ConversationStyleTypeEnumMap[instance.conversationStyleType]!,
  'value': instance.value,
};

const _$ConversationStyleTypeEnumMap = {
  ConversationStyleType.button: 'button',
  ConversationStyleType.text: 'text',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_conversation_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetConversationStyle _$TargetConversationStyleFromJson(
  Map<String, dynamic> json,
) => TargetConversationStyle(
  id: json['id'] as String,
  targetId: json['targetId'] as String,
  conversationStyleType: $enumDecode(
    _$ConversationStyleTypeEnumMap,
    json['conversationStyleType'],
  ),
  value: json['value'] as String,
);

Map<String, dynamic> _$TargetConversationStyleToJson(
  TargetConversationStyle instance,
) => <String, dynamic>{
  'id': instance.id,
  'targetId': instance.targetId,
  'conversationStyleType':
      _$ConversationStyleTypeEnumMap[instance.conversationStyleType]!,
  'value': instance.value,
};

const _$ConversationStyleTypeEnumMap = {
  ConversationStyleType.button: 'button',
  ConversationStyleType.text: 'text',
};

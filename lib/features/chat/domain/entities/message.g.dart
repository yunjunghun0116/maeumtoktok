// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  chatId: json['chatId'] as String,
  senderId: json['senderId'] as String,
  senderType: $enumDecode(_$SenderTypeEnumMap, json['senderType']),
  contents: json['contents'] as String,
  timeStamp: DateTime.parse(json['timeStamp'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'chatId': instance.chatId,
  'senderId': instance.senderId,
  'senderType': _$SenderTypeEnumMap[instance.senderType]!,
  'contents': instance.contents,
  'timeStamp': instance.timeStamp.toIso8601String(),
};

const _$SenderTypeEnumMap = {SenderType.member: 'member', SenderType.target: 'target'};

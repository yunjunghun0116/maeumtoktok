import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/shared/utils/security_util.dart';

class Message {
  final String chatId;
  final String senderId;
  final SenderType senderType;
  final String contents;
  final DateTime timeStamp;

  Message({
    required this.chatId,
    required this.senderId,
    required this.senderType,
    required this.contents,
    required this.timeStamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    String decryptedMessage = SecurityUtil.decryptChat(json['contents'] as String);
    return Message(
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      senderType: SenderType.getType(json['senderType'] as String),
      contents: decryptedMessage,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    String encryptedMessage = SecurityUtil.encryptChat(contents);
    return <String, dynamic>{
      'chatId': chatId,
      'senderId': senderId,
      'senderType': senderType.type,
      'contents': encryptedMessage,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Message{chatId: $chatId, senderId: $senderId, senderType: ${senderType.type}, contents: $contents, timeStamp: ${timeStamp.toIso8601String()}}';
  }
}

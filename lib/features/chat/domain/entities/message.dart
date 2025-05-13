import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
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

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

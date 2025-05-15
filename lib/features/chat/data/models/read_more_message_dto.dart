import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';

class ReadMoreMessageDto {
  final Chat chat;
  final Message lastMessage;

  ReadMoreMessageDto({required this.chat, required this.lastMessage});

  @override
  String toString() {
    return 'ReadMoreMessageDto{chat: ${chat.toString()}, lastMessage: ${lastMessage.toString()}}';
  }
}

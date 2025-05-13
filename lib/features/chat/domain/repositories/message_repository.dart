import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessageRepository {
  Stream<QuerySnapshot> readAllMessage(Chat chat);

  Future<List<Message>> loadMoreMessage({required Chat chat, required Message lastMessage});

  Future<Message> create(Message message);
}

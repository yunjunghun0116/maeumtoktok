import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class MessageRepositoryImpl implements MessageRepository {
  static final MessageRepositoryImpl _instance = MessageRepositoryImpl._internal();

  factory MessageRepositoryImpl() => _instance;

  MessageRepositoryImpl._internal();

  static final int _getMessageSize = 20;

  static CollectionReference collection(String chatId) => FirebaseFirestore.instance
      .collection(FirebaseCollection.chatCollection)
      .doc(chatId)
      .collection(FirebaseCollection.messageCollection);

  @override
  Future<Message> create(Message message) async {
    await collection(message.chatId).add(message.toJson());
    return message;
  }

  @override
  Future<List<Message>> loadMoreMessage({required Chat chat, required Message lastMessage}) async {
    var result =
        await collection(chat.id)
            .orderBy("timeStamp", descending: true)
            .startAfter([lastMessage.timeStamp.toIso8601String()])
            .limit(_getMessageSize)
            .get();

    return result.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Stream<QuerySnapshot> readAllMessage(Chat chat) {
    return collection(chat.id).orderBy("timeStamp", descending: true).limit(_getMessageSize).snapshots();
  }
}

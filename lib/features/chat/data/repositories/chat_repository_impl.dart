import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class ChatRepositoryImpl implements ChatRepository {
  static final ChatRepositoryImpl _instance = ChatRepositoryImpl._internal();

  factory ChatRepositoryImpl() => _instance;

  ChatRepositoryImpl._internal();

  static CollectionReference get collection => FirebaseFirestore.instance.collection(FirebaseCollection.chatCollection);

  @override
  Future<Chat> create(Chat chat) async {
    await collection.doc(chat.id).set(chat.toJson());
    return chat;
  }

  @override
  Future<bool> existsByMemberIdAndTargetId(String memberId, String targetId) async {
    var snapshot = await collection.where("memberId", isEqualTo: memberId).where("targetId", isEqualTo: targetId).get();
    return snapshot.size >= 1;
  }

  @override
  Future<Chat> readByMemberIdAndTargetId(String memberId, String targetId) async {
    var snapshot = await collection.where("memberId", isEqualTo: memberId).where("targetId", isEqualTo: targetId).get();
    if (snapshot.size == 0) throw CustomException(ExceptionMessage.badRequest);
    return Chat.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
  }

  @override
  Future<Chat> update(Chat chat) async {
    await collection.doc(chat.id).update(chat.toJson());
    return chat;
  }
}

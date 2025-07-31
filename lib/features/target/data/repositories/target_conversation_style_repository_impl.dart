import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/repositories/target_conversation_style_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class TargetConversationStyleRepositoryImpl implements TargetConversationStyleRepository {
  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.targetConversationStyleCollection);

  @override
  Future<TargetConversationStyle> create(TargetConversationStyle targetConversationStyle) async {
    await _collection.doc(targetConversationStyle.id).set(targetConversationStyle.toJson());
    return targetConversationStyle;
  }

  @override
  Future<List<TargetConversationStyle>> readAllByTargetId(String targetId) async {
    var snapshot = await _collection.where("targetId", isEqualTo: targetId).get();
    return snapshot.docs
        .map((document) => TargetConversationStyle.fromJson(document.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

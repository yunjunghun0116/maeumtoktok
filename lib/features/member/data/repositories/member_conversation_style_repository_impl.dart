import 'package:app/features/member/domain/entities/member_conversation_style.dart';
import 'package:app/features/member/domain/repositories/member_conversation_style_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class MemberConversationStyleRepositoryImpl implements MemberConversationStyleRepository {
  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.memberConversationStyleCollection);

  @override
  Future<MemberConversationStyle> create(MemberConversationStyle memberConversationStyle) async {
    await _collection.doc(memberConversationStyle.id).set(memberConversationStyle.toJson());
    return memberConversationStyle;
  }

  @override
  Future<List<MemberConversationStyle>> readAllByMemberId(String memberId) async {
    var snapshot = await _collection.where("memberId", isEqualTo: memberId).get();
    return snapshot.docs
        .map((document) => MemberConversationStyle.fromJson(document.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

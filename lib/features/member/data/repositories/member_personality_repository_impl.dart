import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/domain/repositories/member_personality_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class MemberPersonalityRepositoryImpl implements MemberPersonalityRepository {
  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.memberPersonalityCollection);

  @override
  Future<MemberPersonality> create(MemberPersonality memberPersonality) async {
    await _collection.doc(memberPersonality.id).set(memberPersonality.toJson());
    return memberPersonality;
  }

  @override
  Future<List<MemberPersonality>> readAllByMemberId(String memberId) async {
    var snapshot = await _collection.where("memberId", isEqualTo: memberId).get();
    return snapshot.docs
        .map((document) => MemberPersonality.fromJson(document.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

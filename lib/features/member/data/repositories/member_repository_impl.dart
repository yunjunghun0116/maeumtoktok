import 'package:app/features/member/domain/repositories/member_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';
import '../../domain/entities/member.dart';

class MemberRepositoryImpl implements MemberRepository {
  static final MemberRepositoryImpl _instance = MemberRepositoryImpl._internal();

  factory MemberRepositoryImpl() => _instance;

  MemberRepositoryImpl._internal();

  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.memberCollection);

  @override
  Future<void> update(Member member) async {
    await _collection.doc(member.id).update(member.toJson());
  }
}

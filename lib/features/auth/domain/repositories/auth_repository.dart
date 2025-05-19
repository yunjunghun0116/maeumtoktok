import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../member/domain/entities/member.dart';

abstract class AuthRepository {
  Member create(Member member, Transaction transaction);

  Future<Member> readByEmail(String email);

  Future<Member> readByEmailAndPassword(String email, String password);

  Future<bool> existsByEmail(String email);

  Future<void> runTransaction(Function(Transaction transaction) action);

  Future<bool> deleteByMember(Member member);
}

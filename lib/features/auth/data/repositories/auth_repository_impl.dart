import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/constants/firebase_collection.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final AuthRepositoryImpl _instance = AuthRepositoryImpl._internal();

  factory AuthRepositoryImpl() => _instance;

  AuthRepositoryImpl._internal();

  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.memberCollection);

  @override
  Member create(Member member, Transaction transaction) {
    var ref = _collection.doc(member.id);
    transaction.set(ref, member.toJson());
    return member;
  }

  @override
  Future<bool> existsByEmail(String email) async {
    var snapshot = await _collection.where("email", isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<Member> readByEmailAndPassword(String email, String password) async {
    var snapshot = await _collection.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) throw CustomException(ExceptionMessage.wrongEmailOrPassword);
    var member = Member.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    member.validatePassword(password);
    return member;
  }

  @override
  Future<Member> readByEmail(String email) async {
    var snapshot = await _collection.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) throw CustomException(ExceptionMessage.wrongEmailOrPassword);
    var member = Member.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    return member;
  }

  @override
  Future<void> runTransaction(Function(Transaction transaction) action) async {
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      return await action(transaction);
    });
  }
}

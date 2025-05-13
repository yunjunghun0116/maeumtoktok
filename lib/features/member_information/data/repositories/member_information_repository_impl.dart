import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/constants/firebase_collection.dart';

class MemberInformationRepositoryImpl implements MemberInformationRepository {
  static final MemberInformationRepositoryImpl _instance = MemberInformationRepositoryImpl._internal();

  factory MemberInformationRepositoryImpl() => _instance;

  MemberInformationRepositoryImpl._internal();

  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.memberInformationCollection);

  @override
  MemberInformation create(MemberInformation information, Transaction transaction) {
    var ref = _collection.doc(information.id);
    transaction.set(ref, information.toJson());
    return information;
  }

  @override
  Future<MemberInformation> readById(String id) async {
    var snapshot = await _collection.doc(id).get();
    if (!snapshot.exists) throw CustomException(ExceptionMessage.badRequest);
    var information = MemberInformation.fromJson(snapshot.data() as Map<String, dynamic>);
    return information;
  }

  @override
  Future<MemberInformation> update(MemberInformation information) async {
    await _collection.doc(information.id).update(information.toJson());
    return information;
  }
}

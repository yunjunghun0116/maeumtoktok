import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/repositories/target_information_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/constants/firebase_collection.dart';

class TargetInformationRepositoryImpl implements TargetInformationRepository {
  static final TargetInformationRepositoryImpl _instance = TargetInformationRepositoryImpl._internal();

  factory TargetInformationRepositoryImpl() => _instance;

  TargetInformationRepositoryImpl._internal();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.targetInformationCollection);

  @override
  TargetInformation create(TargetInformation information, Transaction transaction) {
    var ref = collection.doc(information.id);
    transaction.set(ref, information.toJson());
    return information;
  }

  @override
  Future<TargetInformation> readById(String id) async {
    var snapshot = await collection.doc(id).get();
    if (!snapshot.exists) throw CustomException(ExceptionMessage.badRequest);
    var information = TargetInformation.fromJson(snapshot.data() as Map<String, dynamic>);
    return information;
  }

  @override
  Future<TargetInformation> update(TargetInformation information) async {
    await collection.doc(information.id).update(information.toJson());
    return information;
  }
}

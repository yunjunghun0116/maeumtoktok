import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/constants/firebase_collection.dart';

class TargetRepositoryImpl implements TargetRepository {
  static final TargetRepositoryImpl _instance = TargetRepositoryImpl._internal();

  factory TargetRepositoryImpl() => _instance;

  TargetRepositoryImpl._internal();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.targetCollection);

  @override
  Target create(Target target, Transaction transaction) {
    var ref = collection.doc(target.id);
    transaction.set(ref, target.toJson());
    return target;
  }

  @override
  Future<Target> readById(String id) async {
    var snapshot = await collection.doc(id).get();
    if (!snapshot.exists) throw CustomException(ExceptionMessage.badRequest);
    var target = Target.fromJson(snapshot.data() as Map<String, dynamic>);
    return target;
  }

  @override
  Future<Target> update(Target target) async {
    await collection.doc(target.id).update(target.toJson());
    return target;
  }
}

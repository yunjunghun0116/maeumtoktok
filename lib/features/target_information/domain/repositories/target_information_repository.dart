import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TargetInformationRepository {
  TargetInformation create(TargetInformation information, Transaction transaction);

  Future<TargetInformation> readById(String id);

  Future<TargetInformation> update(TargetInformation information);
}

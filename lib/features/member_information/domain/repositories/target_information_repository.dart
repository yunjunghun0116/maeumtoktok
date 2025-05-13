import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/member_information.dart';

abstract class MemberInformationRepository {
  MemberInformation create(MemberInformation information, Transaction transaction);

  Future<MemberInformation> readById(String id);

  Future<MemberInformation> update(MemberInformation information);
}

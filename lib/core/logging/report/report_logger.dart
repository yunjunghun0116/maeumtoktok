import 'package:app/core/logging/report/report_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/constants/firebase_collection.dart';

class ReportLogger {
  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.reportCollection);

  static Future<void> report(ReportEntity reportEntity) async {
    await _collection.add(reportEntity.toJson());
  }
}

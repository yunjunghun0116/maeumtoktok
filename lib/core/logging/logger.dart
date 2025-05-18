import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/constants/firebase_collection.dart';
import 'log_entity.dart';

class Logger {
  static CollectionReference get _collection => FirebaseFirestore.instance.collection(FirebaseCollection.logCollection);

  static Future<void> log(LogEntity log) async {
    await _collection.add(log.toJson());
  }
}

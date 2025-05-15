import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/constants/firebase_collection.dart';
import '../../domain/repositories/sequence_repository.dart';

class SequenceRepositoryImpl implements SequenceRepository {
  static final SequenceRepositoryImpl _instance = SequenceRepositoryImpl._internal();

  factory SequenceRepositoryImpl() => _instance;

  SequenceRepositoryImpl._internal();

  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.sequenceCollection);

  @override
  Future<String> getNextSequence(String collectionName) async {
    if (!(await existsCollectionName(collectionName))) {
      return await setNewCollection(collectionName);
    }
    var snapshot = await _collection.doc(collectionName).get();
    var sequence = snapshot.get("sequence") as int;
    _collection.doc(collectionName).update({"sequence": sequence + 1});

    return sequence.toString();
  }

  Future<String> setNewCollection(String collectionName) async {
    var defaultSequence = 1;
    var defaultMap = {"sequence": defaultSequence};
    await _collection.doc(collectionName).set(defaultMap);
    return defaultSequence.toString();
  }

  Future<bool> existsCollectionName(String collectionName) async {
    return (await _collection.doc(collectionName).get()).exists;
  }
}

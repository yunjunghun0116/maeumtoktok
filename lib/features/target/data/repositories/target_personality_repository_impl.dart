import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/domain/repositories/target_personality_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class TargetPersonalityRepositoryImpl implements TargetPersonalityRepository {
  static CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.targetPersonalityCollection);

  @override
  Future<TargetPersonality> create(TargetPersonality targetPersonality) async {
    await _collection.doc(targetPersonality.id).set(targetPersonality.toJson());
    return targetPersonality;
  }

  @override
  Future<List<TargetPersonality>> readAllByTargetId(String targetId) async {
    var snapshot = await _collection.where("targetId", isEqualTo: targetId).get();
    return snapshot.docs
        .map((document) => TargetPersonality.fromJson(document.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

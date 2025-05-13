import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/constants/firebase_collection.dart';

class TargetIssueRepositoryImpl implements TargetIssueRepository {
  static final TargetIssueRepositoryImpl _instance = TargetIssueRepositoryImpl._internal();

  factory TargetIssueRepositoryImpl() => _instance;

  TargetIssueRepositoryImpl._internal();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection(FirebaseCollection.targetIssueCollection);

  @override
  Future<TargetIssue> create(TargetIssue issue) async {
    await collection.doc(issue.id).set(issue.toJson());
    return issue;
  }

  @override
  Future<List<TargetIssue>> readAllByTargetId(String id) async {
    var snapshot = await collection.where("targetId", isEqualTo: id).get();
    return snapshot.docs.map((document) => TargetIssue.fromJson(document.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<TargetIssue> update(TargetIssue issue) async {
    await collection.doc(issue.id).update(issue.toJson());
    return issue;
  }

  @override
  Future<void> delete(TargetIssue issue) async {
    await collection.doc(issue.id).delete();
  }
}

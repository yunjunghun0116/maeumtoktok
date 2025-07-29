import 'package:app/features/target/domain/entities/target.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TargetRepository {
  Target create(Target target, Transaction transaction);

  Future<Target> readByMemberId(String memberId);

  Future<Target> update(Target target);
}

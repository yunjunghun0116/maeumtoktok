import 'package:app/features/member/domain/entities/member_personality.dart';

abstract class MemberPersonalityRepository {
  Future<MemberPersonality> create(MemberPersonality memberPersonality);

  Future<List<MemberPersonality>> readAllByMemberId(String memberId);

  Future<void> delete(String id);
}

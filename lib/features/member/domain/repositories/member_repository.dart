import '../entities/member.dart';

abstract class MemberRepository {
  Future<void> update(Member member);
}

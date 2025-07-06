import '../entities/member.dart';

abstract class MemberRepository {
  Future<Member> update(Member member);
}

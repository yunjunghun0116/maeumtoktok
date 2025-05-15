import 'package:app/features/target/domain/entities/target.dart';

import '../../../member/domain/entities/member.dart';

class CreateChatDto {
  final Member member;
  final Target target;

  CreateChatDto({required this.member, required this.target});

  @override
  String toString() {
    return 'CreateChatDto{member: ${member.toString()}, target: ${target.toString()}}';
  }
}

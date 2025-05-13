import 'package:app/features/member/domain/entities/role.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/register_dto.dart';
import 'gender.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final String id;
  final String email;
  final String password;
  final String name;
  final int age;
  final Gender gender;
  final Role role;
  final DateTime lastLoginDate;

  Member({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
    required this.role,
    required this.lastLoginDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);

  factory Member.fromDto(String id, RegisterDto registerDto) {
    return Member(
      id: id,
      email: registerDto.email,
      password: registerDto.password,
      name: registerDto.name,
      age: registerDto.age,
      gender: registerDto.gender,
      role: Role.member,
      lastLoginDate: DateTime.now(),
    );
  }
}

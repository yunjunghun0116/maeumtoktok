import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/shared/utils/security_util.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/register_dto.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final String id;
  final String email;
  final String password;
  final String name;
  final DateTime lastLoginDate;

  Member({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastLoginDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);

  factory Member.fromDto(String id, RegisterDto registerDto) {
    String encryptedPassword = SecurityUtil.encryptPassword(registerDto.password);
    return Member(
      id: id,
      email: registerDto.email,
      password: encryptedPassword,
      name: registerDto.name,
      lastLoginDate: DateTime.now(),
    );
  }

  void validatePassword(String inputPassword) {
    if (!SecurityUtil.checkPW(inputPassword, password)) {
      throw CustomException(ExceptionMessage.wrongEmailOrPassword);
    }
  }

  @override
  String toString() {
    return 'Member{id: $id, email: $email, password: $password, name: $name, lastLoginDate: ${lastLoginDate.toIso8601String()}';
  }
}

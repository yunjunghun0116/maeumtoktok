import 'package:json_annotation/json_annotation.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../member/domain/entities/gender.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto {
  final String email;
  final String password;
  final String name;
  final int age;
  final Gender gender;

  RegisterDto({
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    validateJsonInput(json);
    var dto = _$RegisterDtoFromJson(json);
    return dto;
  }

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  static void validateJsonInput(Map<String, dynamic> json) {
    if (!json.containsKey("email")) throw CustomException(ExceptionMessage.badRequest);
    if (!json.containsKey("password")) throw CustomException(ExceptionMessage.badRequest);
    if (!json.containsKey("name")) throw CustomException(ExceptionMessage.badRequest);
    if (!json.containsKey("age")) throw CustomException(ExceptionMessage.badRequest);
    if (!json.containsKey("gender")) throw CustomException(ExceptionMessage.badRequest);
  }
}

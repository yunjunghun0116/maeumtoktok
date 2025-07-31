import 'package:app/shared/domain/custom_input_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_member_personality_dto.g.dart';

@JsonSerializable()
class CreateMemberPersonalityDto {
  final String memberId;
  final CustomInputType inputType;
  final String value;

  CreateMemberPersonalityDto({required this.memberId, required this.inputType, required this.value});

  factory CreateMemberPersonalityDto.fromJson(Map<String, dynamic> json) => _$CreateMemberPersonalityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMemberPersonalityDtoToJson(this);

  @override
  String toString() {
    return 'CreateMemberPersonalityDto{memberId: $memberId, inputType: $inputType, value: $value}';
  }
}

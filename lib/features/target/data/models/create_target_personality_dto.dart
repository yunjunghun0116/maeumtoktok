import 'package:app/features/target/domain/entities/personality_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_target_personality_dto.g.dart';

@JsonSerializable()
class CreateTargetPersonalityDto {
  final String targetId;
  final PersonalityType personalityType;
  final String value;

  CreateTargetPersonalityDto({required this.targetId, required this.personalityType, required this.value});

  factory CreateTargetPersonalityDto.fromJson(Map<String, dynamic> json) => _$CreateTargetPersonalityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTargetPersonalityDtoToJson(this);

  @override
  String toString() {
    return 'CreateTargetPersonalityDto{targetId: $targetId, personalityType: $personalityType, value: $value}';
  }
}

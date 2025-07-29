import 'package:json_annotation/json_annotation.dart';

part 'update_target_personality_dto.g.dart';

@JsonSerializable()
class UpdateTargetPersonalityDto {
  final String id;
  final String value;

  UpdateTargetPersonalityDto({required this.id, required this.value});

  factory UpdateTargetPersonalityDto.fromJson(Map<String, dynamic> json) => _$UpdateTargetPersonalityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTargetPersonalityDtoToJson(this);

  @override
  String toString() {
    return 'UpdateTargetPersonalityDto{id: $id, value: $value}';
  }
}

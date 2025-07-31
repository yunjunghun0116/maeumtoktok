import 'package:app/features/target/data/models/create_target_personality_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/domain/custom_input_type.dart';

part 'target_personality.g.dart';

@JsonSerializable()
class TargetPersonality {
  final String id;
  final String targetId;
  final CustomInputType inputType;
  String value;

  TargetPersonality({required this.id, required this.targetId, required this.inputType, required this.value});

  factory TargetPersonality.fromJson(Map<String, dynamic> json) => _$TargetPersonalityFromJson(json);

  factory TargetPersonality.fromDto(String id, CreateTargetPersonalityDto createTargetPersonalityDto) {
    return TargetPersonality(
      id: id,
      targetId: createTargetPersonalityDto.targetId,
      inputType: createTargetPersonalityDto.inputType,
      value: createTargetPersonalityDto.value,
    );
  }

  Map<String, dynamic> toJson() => _$TargetPersonalityToJson(this);

  void updatePersonality(String newValue) {
    value = newValue;
  }

  @override
  String toString() {
    return 'TargetPersonality{id: $id, targetId: $targetId, inputType: $inputType, value: $value}';
  }
}

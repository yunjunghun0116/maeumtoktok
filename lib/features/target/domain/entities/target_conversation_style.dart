import 'package:app/features/target/data/models/create_target_conversation_style_dto.dart';
import 'package:app/shared/domain/custom_input_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_conversation_style.g.dart';

@JsonSerializable()
class TargetConversationStyle {
  final String id;
  final String targetId;
  final CustomInputType inputType;
  String value;

  TargetConversationStyle({required this.id, required this.targetId, required this.inputType, required this.value});

  factory TargetConversationStyle.fromJson(Map<String, dynamic> json) => _$TargetConversationStyleFromJson(json);

  factory TargetConversationStyle.fromDto(
    String id,
    CreateTargetConversationStyleDto createTargetConversationStyleDto,
  ) {
    return TargetConversationStyle(
      id: id,
      targetId: createTargetConversationStyleDto.targetId,
      inputType: createTargetConversationStyleDto.inputType,
      value: createTargetConversationStyleDto.value,
    );
  }

  Map<String, dynamic> toJson() => _$TargetConversationStyleToJson(this);

  @override
  String toString() {
    return 'TargetConversationStyle{id: $id, targetId: $targetId, inputType: $inputType, value: $value}';
  }
}

import 'package:app/shared/domain/custom_input_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_target_conversation_style_dto.g.dart';

@JsonSerializable()
class CreateTargetConversationStyleDto {
  final String targetId;
  final CustomInputType inputType;
  final String value;

  CreateTargetConversationStyleDto({required this.targetId, required this.inputType, required this.value});

  factory CreateTargetConversationStyleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTargetConversationStyleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTargetConversationStyleDtoToJson(this);

  @override
  String toString() {
    return 'CreateTargetConversationStyleDto{targetId: $targetId, inputType: $inputType, value: $value}';
  }
}

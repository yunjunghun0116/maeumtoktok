import 'package:app/shared/domain/custom_input_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_member_conversation_style_dto.g.dart';

@JsonSerializable()
class CreateMemberConversationStyleDto {
  final String memberId;
  final CustomInputType inputType;
  final String value;

  CreateMemberConversationStyleDto({required this.memberId, required this.inputType, required this.value});

  factory CreateMemberConversationStyleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMemberConversationStyleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMemberConversationStyleDtoToJson(this);

  @override
  String toString() {
    return 'CreateMemberConversationStyleDto{memberId: $memberId, inputType: $inputType, value: $value}';
  }
}

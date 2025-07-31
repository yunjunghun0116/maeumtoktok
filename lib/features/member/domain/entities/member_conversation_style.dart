import 'package:app/features/member/data/models/create_member_conversation_style_dto.dart';
import 'package:app/shared/domain/custom_input_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_conversation_style.g.dart';

@JsonSerializable()
class MemberConversationStyle {
  final String id;
  final String memberId;
  final CustomInputType inputType;
  String value;

  MemberConversationStyle({required this.id, required this.memberId, required this.inputType, required this.value});

  factory MemberConversationStyle.fromJson(Map<String, dynamic> json) => _$MemberConversationStyleFromJson(json);

  factory MemberConversationStyle.fromDto(
    String id,
    CreateMemberConversationStyleDto createMemberConversationStyleDto,
  ) {
    return MemberConversationStyle(
      id: id,
      memberId: createMemberConversationStyleDto.memberId,
      inputType: createMemberConversationStyleDto.inputType,
      value: createMemberConversationStyleDto.value,
    );
  }

  Map<String, dynamic> toJson() => _$MemberConversationStyleToJson(this);

  @override
  String toString() {
    return 'MemberConversationStyle{id: $id, memberId: $memberId, inputType: $inputType, value: $value}';
  }
}

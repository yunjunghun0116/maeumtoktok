import 'package:app/features/member/data/models/create_member_personality_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/domain/custom_input_type.dart';

part 'member_personality.g.dart';

@JsonSerializable()
class MemberPersonality {
  final String id;
  final String memberId;
  final CustomInputType inputType;
  String value;

  MemberPersonality({required this.id, required this.memberId, required this.inputType, required this.value});

  factory MemberPersonality.fromJson(Map<String, dynamic> json) => _$MemberPersonalityFromJson(json);

  factory MemberPersonality.fromDto(String id, CreateMemberPersonalityDto createMemberPersonalityDto) {
    return MemberPersonality(
      id: id,
      memberId: createMemberPersonalityDto.memberId,
      inputType: createMemberPersonalityDto.inputType,
      value: createMemberPersonalityDto.value,
    );
  }

  Map<String, dynamic> toJson() => _$MemberPersonalityToJson(this);

  void updatePersonality(String newValue) {
    value = newValue;
  }

  @override
  String toString() {
    return 'MemberPersonality{id: $id, memberId: $memberId, inputType: $inputType, value: $value}';
  }
}

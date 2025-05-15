import 'package:json_annotation/json_annotation.dart';

part 'member_information.g.dart';

@JsonSerializable()
class MemberInformation {
  final String id;
  String description;

  MemberInformation({required this.id, required this.description});

  factory MemberInformation.fromJson(Map<String, dynamic> json) => _$MemberInformationFromJson(json);

  Map<String, dynamic> toJson() => _$MemberInformationToJson(this);

  factory MemberInformation.fromId(String id) {
    return MemberInformation(id: id, description: "");
  }

  void updateDescription(String description) {
    this.description = description;
  }

  @override
  String toString() {
    return 'MemberInformation{id: $id, description: $description}';
  }
}

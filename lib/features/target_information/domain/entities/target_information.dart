import 'package:json_annotation/json_annotation.dart';

part 'target_information.g.dart';

@JsonSerializable()
class TargetInformation {
  final String id;
  String description;

  TargetInformation({required this.id, required this.description});

  factory TargetInformation.fromJson(Map<String, dynamic> json) => _$TargetInformationFromJson(json);

  Map<String, dynamic> toJson() => _$TargetInformationToJson(this);

  factory TargetInformation.defaultInformation(String id, String image) {
    return TargetInformation(id: id, description: "");
  }

  void updateDescription(String description) {
    this.description = description;
  }

  @override
  String toString() {
    return 'TargetInformation{id: $id, description: $description}';
  }
}

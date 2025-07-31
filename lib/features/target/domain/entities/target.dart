import 'package:json_annotation/json_annotation.dart';

part 'target.g.dart';

@JsonSerializable()
class Target {
  final String id;
  final String memberId;
  String image;
  String name;
  String relationship;

  Target({
    required this.id,
    required this.memberId,
    required this.image,
    required this.name,
    required this.relationship,
  });

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  factory Target.defaultTarget({required String id, required String memberId, required String image}) {
    return Target(id: id, memberId: memberId, image: image, name: "상대방", relationship: "단절된 대상");
  }

  Map<String, dynamic> toJson() => _$TargetToJson(this);

  void updateImage(String image) {
    this.image = image;
  }

  void updateName(String name) {
    this.name = name;
  }

  void updateRelationship(String relationship) {
    this.relationship = relationship;
  }

  @override
  String toString() {
    return 'Target{id: $id, memberId: $memberId, image: $image, name: $name, relationship: $relationship}';
  }
}

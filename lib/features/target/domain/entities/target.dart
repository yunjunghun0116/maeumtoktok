import 'package:json_annotation/json_annotation.dart';

part 'target.g.dart';

@JsonSerializable()
class Target {
  final String id;
  String image;
  String name;
  String relationship;
  String personality;
  String conversationStyle;
  String additionalDescription;

  Target({
    required this.id,
    required this.image,
    required this.name,
    required this.relationship,
    required this.personality,
    required this.conversationStyle,
    required this.additionalDescription,
  });

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  factory Target.defaultTarget(String id, String image) {
    return Target(
      id: id,
      image: image,
      name: "상대방",
      relationship: "단절된 대상",
      personality: "",
      conversationStyle: "",
      additionalDescription: "",
    );
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

  void updatePersonality(String personality) {
    this.personality = personality;
  }

  void updateConversationStyle(String conversationStyle) {
    this.conversationStyle = conversationStyle;
  }

  void updateAdditionalDescription(String additionalDescription) {
    this.additionalDescription = additionalDescription;
  }

  @override
  String toString() {
    return 'Target{id: $id, image: $image, name: $name, relationship: $relationship, personality: $personality, conversationStyle: $conversationStyle, additionalDescription: $additionalDescription}';
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'target.g.dart';

@JsonSerializable()
class Target {
  final String id;
  String image;
  String name;
  String job;
  int age;

  Target({required this.id, required this.image, required this.name, required this.job, required this.age});

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  factory Target.defaultTarget(String id, String image) {
    return Target(id: id, image: image, name: "상대방", job: "", age: 0);
  }

  Map<String, dynamic> toJson() => _$TargetToJson(this);

  void updateImage(String image) {
    this.image = image;
  }

  void updateName(String name) {
    this.name = name;
  }

  void updateJob(String job) {
    this.job = job;
  }

  void updateAge(int age) {
    this.age = age;
  }
}

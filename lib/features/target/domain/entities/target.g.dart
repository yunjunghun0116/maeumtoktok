// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) => Target(
  id: json['id'] as String,
  image: json['image'] as String,
  name: json['name'] as String,
  job: json['job'] as String,
  age: (json['age'] as num).toInt(),
);

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'job': instance.job,
  'age': instance.age,
};

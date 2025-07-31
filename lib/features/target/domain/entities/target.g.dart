// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) => Target(
  id: json['id'] as String,
  memberId: json['memberId'] as String,
  image: json['image'] as String,
  name: json['name'] as String,
  relationship: json['relationship'] as String,
);

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
  'id': instance.id,
  'memberId': instance.memberId,
  'image': instance.image,
  'name': instance.name,
  'relationship': instance.relationship,
};

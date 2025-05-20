// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  id: json['id'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  name: json['name'] as String,
  lastLoginDate: DateTime.parse(json['lastLoginDate'] as String),
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'lastLoginDate': instance.lastLoginDate.toIso8601String(),
};

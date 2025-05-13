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
  age: (json['age'] as num).toInt(),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  role: $enumDecode(_$RoleEnumMap, json['role']),
  lastLoginDate: DateTime.parse(json['lastLoginDate'] as String),
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'age': instance.age,
  'gender': _$GenderEnumMap[instance.gender]!,
  'role': _$RoleEnumMap[instance.role]!,
  'lastLoginDate': instance.lastLoginDate.toIso8601String(),
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$RoleEnumMap = {Role.manager: 'manager', Role.member: 'member'};

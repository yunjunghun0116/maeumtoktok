// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
  email: json['email'] as String,
  password: json['password'] as String,
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
);

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'age': instance.age,
  'gender': _$GenderEnumMap[instance.gender]!,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

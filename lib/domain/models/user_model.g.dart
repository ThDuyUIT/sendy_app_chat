// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      idUser: json['idUser'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as int?,
      urlAvatar: json['urlAvatar'] as String?,
      activeStatus: json['activeStatus'] as bool?,
      //password: json['password'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'idUser': instance.idUser,
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      //'password': instance.password,
      'gender': instance.gender,
      'urlAvatar': instance.urlAvatar,
      'activeStatus': instance.activeStatus,
    };

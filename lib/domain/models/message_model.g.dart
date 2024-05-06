// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      idMessage: json['idMessage'] as String,
      status: json['status'] as int,
      idSender: json['idSender'] as String,
      idConversation: json['idConversation'] as String,
      timestamp: json['timestamp'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'idMessage': instance.idMessage,
      'idSender': instance.idSender,
      'idConversation': instance.idConversation,
      'timestamp': instance.timestamp,
      'content': instance.content,
      'status': instance.status,
    };

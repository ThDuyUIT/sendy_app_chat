import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
part 'conversation_model.g.dart';

@JsonSerializable()
class Conversation {
  late String idConversation;
  List<String>? members;
  late String timestamp;
  Message? lastMessage;

  Conversation({
    required this.idConversation,
    required this.timestamp,
    this.members = const [],
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  @override
  String toString() {
    return 'Conversation{idConversation: $idConversation, members: $members, timestamp: $timestamp, lastMessage: ${lastMessage.toString()}}';
  }
}

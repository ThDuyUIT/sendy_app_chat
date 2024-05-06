import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
part 'message_model.g.dart';

@JsonSerializable()
//@Entity()

class Message {
 
  late String idMessage;
  late String idSender;
  late String idConversation;
  late String timestamp;
  late String content;
  late int status;

  Message({
    required this.idMessage,
    required this.status,
    required this.idSender,
    required this.idConversation,
    required this.timestamp,
    required this.content,
  });
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'Message{idMessage: $idMessage, status: $status, idSender: $idSender, idConversation: $idConversation, timestamp: $timestamp, content: $content}';
  }

}



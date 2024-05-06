import 'package:sendy_app_chat/domain/models/conversation_model.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';

class ChatEvent {
  Conversation? conversation;
}

class SendMessage extends ChatEvent {
  late Message message;

  SendMessage({required this.message});
}

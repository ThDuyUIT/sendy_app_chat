import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/bloc/events/chat_event.dart';
import 'package:sendy_app_chat/bloc/states/chat_state.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final chatController = Get.find<ChatController>();
  ChatBloc() : super(ChatState.initial()) {
    on<SendMessage>((event, emit) => _sendMessage(event.message, emit));
  }

  _sendMessage(Message message, emit) async {
    if (ChatPage.idConversation == null) {
      await chatController.createConversation();
    }
    await chatController.sendMessage2(message);
  }
}

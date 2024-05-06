import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/services/authentication_service.dart';
import 'package:sendy_app_chat/domain/services/chat_service.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';

class ConnectivityController {
  ValueNotifier<bool> isConnected = ValueNotifier(false);
  final chatService = ChatService();
  final chatController = Get.find<ChatController>();
  final authentication = Get.find<AuthenticationController>();
  final authenticationServices = AuthenticationService();

  Future<void> init() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    isInternetConnected(result);

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isInternetConnected(result);
    });
  }

  bool isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      //MyApp.socket.dispose();
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      //joint again conversation
      if (ChatPage.idConversation != null) {
        chatService.joinConversation(ChatPage.idConversation);
      }

      //sync queue messages from local
      chatController.syncQueueMessages();

      // if(authentication.user.idUser == ''){
      //   authenticationServices.onLogout();
      // }


      isConnected.value = true;
      return true;
    }
    return false;
  }
}

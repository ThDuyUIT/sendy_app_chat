import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:sendy_app_chat/bloc/events/chat_event.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/bloc/states/chat_state.dart' as CustomChatState;
import 'package:sendy_app_chat/bloc/chat_bloc.dart';
import 'package:sendy_app_chat/bloc/chat_provider.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart'
    as MessageModel;
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';

class ChatPage extends StatefulWidget {
  static String? idConversation;
  static List<String> listIdMessage = [];

  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return StateChatPage();
  }
}

class StateChatPage extends State<ChatPage> {
  bool isLoading = true;
  late bool isSending;
  late bool isSent;
  final authenticationController = Get.find<AuthenticationController>();
  final chatController = Get.find<ChatController>();
  List<types.Message> _messages = [];
  late types.User _user;
  late Timer _fetchMessagesTimer;

  StateChatPage() {
    _user = types.User(
        id: authenticationController.user.idUser.toString(),
        imageUrl: authenticationController.user.urlAvatar);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // bool checkListMessage(List<types.Message> list1, List<types.Message> list2) {
  //   print('check list message');
  //   if (list1.length != list2.length) {
  //     return true;
  //   }

  //   for (final message in list1) {
  //     if (!list2.contains(message)) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  bool listsAreEqual(List<types.Message> list1, List<types.Message> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  void _fetchMessages() async {
    List<types.Message> listMessages = await chatController.fetchMessage();

    if (!listsAreEqual(_messages, listMessages)) {
      print('new list message');
      if (mounted) {
        setState(() {
          _messages = listMessages;
        });
      }
    }
  }

  void _joinConversation() async {
    //  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if(result == ConnectivityResult.wifi) {
    //     print('connected again');
    //   }
    // });
    await chatController.joinConversation(
        authenticationController.user.idUser.toString(),
        chatController.user.idUser.toString());
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      if (mounted) {
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    _joinConversation();
    _fetchMessagesTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchMessages();
    });
    super.initState();
  }

  @override
  void dispose() {
    ChatPage.idConversation = null;
    _fetchMessagesTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatProvider(
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                backgroundColor: ColorApp.mainColor,
                foregroundColor: Colors.white,
                leadingWidth: double.infinity,
                leading: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: chatController.user.urlAvatar != null
                              ? NetworkImage(chatController.user.urlAvatar!)
                              : const AssetImage(
                                      'assets/images/empty-avatar.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatController.user.name,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            chatController.user.activeStatus == true
                                ? "Online"
                                : "Offline",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              body: BlocBuilder<ChatBloc, CustomChatState.ChatState>(
                  builder: (context, state) {
                return isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Chat(
                        messages: _messages,
                        onSendPressed: (types.PartialText message) {
                          final textMessage = types.TextMessage(
                            author: _user,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                            id: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            text: message.text,
                            status: types.Status.sending,
                          );

                          _addMessage(textMessage);

                          final messageData = MessageModel.Message(
                              idMessage: textMessage.id,
                              status: 0,
                              idSender: authenticationController.user.idUser
                                  .toString(),
                              idConversation: '',
                              timestamp: textMessage.createdAt.toString(),
                              content: textMessage.text);

                          context
                              .read<ChatBloc>()
                              .add(SendMessage(message: messageData));
                        },
                        user: _user);
              }))),
    );
  }
}

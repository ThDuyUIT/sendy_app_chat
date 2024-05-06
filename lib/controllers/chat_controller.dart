import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';

import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/data/localdata_helper.dart';
import 'package:sendy_app_chat/domain/models/conversation_model.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/authentication_service.dart';
import 'package:sendy_app_chat/domain/services/chat_service.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:sendy_app_chat/presentations/widgets/item_chats_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/list_chats_widget.dart';

class ChatController {
  final authenticationController = Get.find<AuthenticationController>();
  final localDataHelper = LocalDataHelper();
  final chatService = ChatService();
  final authenticationService = AuthenticationService();

  bool get isInternet => MyApp.connectivityController.isConnected.value;
  User user = User.init();

  Future createConversation() async {
    final chatController = Get.find<ChatController>();
    List<String> members = [];
    members.add(authenticationController.user.idUser.toString());
    members.add(chatController.user.idUser.toString());
    final newConversation = Conversation(
        idConversation: DateTime.now().millisecondsSinceEpoch.toString(),
        members: members,
        timestamp: DateTime.now().toString());
    final result = await chatService.createConversation(newConversation);
    if (result) {
      ChatPage.idConversation = newConversation.idConversation.toString();
      await chatService.joinConversation(ChatPage.idConversation);
    }
  }

  Future sendMessage2(Message message) async {
    message.idConversation = ChatPage.idConversation!;
    if (!isInternet) {
      localDataHelper.saveQueueMessages(message);
      return;
    }

    await chatService.sendMessage2(message);
  }

  // Future getAllConversationsById(String idUser) async {
  //   final result = await chatService.getAllConversationsById(idUser);
  //   List<Conversation> dataConversations = (result as List)
  //       .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
  //       .toList();
  //   List<String> listId = [];
  //   dataConversations.forEach((element) {
  //     final id = element.members?.where(
  //         (id) => id != authenticationController.user.idUser.toString());
  //     listId.add(id!.first.toString());
  //   });

  //   await Future.forEach(listId, (element) async {
  //     final user = await authenticationService.getUserById(element);
  //     ListChatWidget.listItemChat
  //         .add(ItemChatWidget(user: User.fromJson(user)));
  //   });
  // }

  Future<void> joinConversation(String id1, String id2) async {
    if (!isInternet) return;
    List<String> listId = [];
    listId.add(id1);
    listId.add(id2);

    ChatPage.idConversation = await chatService.getConversation(listId);
    await chatService.joinConversation(ChatPage.idConversation);
  }

  Future fetchMessage() async {
    final chatController = Get.find<ChatController>();
    List<Message> localMessages = [];
    List<types.Message> messages = [];
    List<Message> dataMessages = [];

    if (ChatPage.idConversation == null) return messages;

    String idConversation = ChatPage.idConversation!;
    String idUser = authenticationController.user.idUser;

    if (isInternet) {
      final result = await chatService.fetchMessage(idConversation, idUser);
      dataMessages = (result as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    //get local data message
    localMessages =
        localDataHelper.loadMessageFromLocal(idConversation, dataMessages);

    await Future.forEach(localMessages, (element) {
      types.TextMessage textMessage = types.TextMessage(
        author: element.idSender == authenticationController.user.idUser
            ? types.User(
                id: authenticationController.user.idUser,
              )
            : types.User(
                id: chatController.user.idUser,
              ),
        id: element.idMessage.toString(),
        text: element.content,
        status: element.status == 0
            ? types.Status.sending
            : element.status == 1
                ? types.Status.sent
                : types.Status.seen,
        createdAt: int.parse(element.timestamp),
      );
      messages.insert(0, textMessage);
    });

    return messages;
  }

  Future fetchConversation(String idUser, int timesForUpdate) async {
    List<ItemChatWidget> listItemChat = [];
    List<Conversation> localDataConversations = [];
    List<Conversation> dataConversations = [];
    print('fetchConversation');

    if (isInternet) {
      final result = await chatService.fetchConversation(idUser);
      dataConversations = (result as List)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    //get local data conversations
    localDataConversations =
        localDataHelper.loadConversationFromLocal(dataConversations);

    await Future.forEach(localDataConversations, (element) async {
      final idUser = element.members?.where(
          (idMember) => idMember != authenticationController.user.idUser);

      late User user;

      // if (MyApp.prefs.containsKey(idUser!.first) && timesForUpdate != 20) {
      //   user = User.fromJson(json.decode(MyApp.prefs.getString(idUser.first)!));
      // } else {
      //   print('1 minutes 1 time');
      //   if (isInternet) {
      //     final dataUser =
      //         await authenticationService.getUserById(idUser.first.toString());
      //     user = User.fromJson(dataUser);
      //     MyApp.prefs
      //         .setString(idUser.first.toString(), json.encode(user.toJson()));
      //   } else {
      //     user = User.fromJson(authenticationController.user.toJson());
      //   }
      // }

      if (!MyApp.prefs.containsKey(idUser!.first)) {
        //if(isInternet){
        final dataUser =
            await authenticationService.getUserById(idUser.first.toString());
        user = User.fromJson(dataUser);
        MyApp.prefs
            .setString(idUser.first.toString(), json.encode(user.toJson()));
        //}
      } else {
        if (timesForUpdate != 20) {
          user =
              User.fromJson(json.decode(MyApp.prefs.getString(idUser.first)!));
        } else {
          print('1 minutes 1 time');
          if (isInternet) {
            final dataUser = await authenticationService
                .getUserById(idUser.first.toString());
            user = User.fromJson(dataUser);
            MyApp.prefs
                .setString(idUser.first.toString(), json.encode(user.toJson()));
          } else {
            user = User.fromJson(
                json.decode(MyApp.prefs.getString(idUser.first)!));
          }
        }
      }

      ItemChatWidget itemChat =
          ItemChatWidget(user: user, conversation: element);
      listItemChat.add(itemChat);
    });
    return listItemChat;
  }

  Future fetchLastMessage(String idMessage) async {
    if (!isInternet) {
      if (MyApp.prefs.containsKey('QUEUEMESSAGES')) {
        return localDataHelper.loadQueueMessages().last;
      }
      return;
    } else {
      final result = await chatService.fetchLastMessage(idMessage);
      return Message.fromJson(result);
    }
  }

  Future syncQueueMessages() async {
    if (!MyApp.prefs.containsKey('QUEUEMESSAGES')) return;
    List<Message> queueMessages = localDataHelper.loadQueueMessages();
    final result = await chatService.syncQueueMessages(queueMessages);
    if (result) {
      MyApp.prefs.remove('QUEUEMESSAGES');
    }
  }
}

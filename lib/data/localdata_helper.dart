// import 'package:get/get.dart';
// import 'package:sendy_app_chat/domain/models/conversation_model.dart';
// import 'package:sendy_app_chat/domain/models/user_model.dart';
// import 'package:sendy_app_chat/main.dart';
// import 'package:sendy_app_chat/objectbox.g.dart';
// import 'package:sendy_app_chat/objectbox_helper.dart';

// class DatabaseHelper {
//   //-----------------------Information account----------------------------------
//   void insertUser(User user) {
//     print('inserted User');
//     try {
//       final dataJson = user.toJson();
//       final userLoggedIn = User.fromJson(dataJson);
//       MyApp.objectBox.userBox.put(userLoggedIn);
//     } on Exception catch (e) {
//       print('Failed to insert user');
//     }
//   }

//   Future<User> getUser() async {
//     final user = await MyApp.objectBox.userBox.getAll().first;
//     return user;
//   }

//   Future<User> getUserById(String? id) async {
//     final user = await MyApp.objectBox.userBox
//         .query(User_.idUser.equals(int.parse(id!)))
//         .build()
//         .find()
//         .last;
//     print('ID ' + user.idUser.toString());
//     return user;
//   }

//   Future updateUser(User user) async {
//     var dataUser = MyApp.objectBox.userBox.get(user.idUser);
//     //print(dataUser.id.toString());
//     dataUser = User.fromJson(user.toJson());
//     print(dataUser.gender.toString());
//     MyApp.objectBox.userBox.put(dataUser);
//   }

//   Future<bool> isUserExist(int idUser) async {
//     final count = await MyApp.objectBox.userBox
//         .query(User_.idUser.equals(idUser))
//         .build()
//         .count();
//     print("Count: " + count.toString());

//     if (count > 0) {
//       return true;
//     }
//     return false;
//   }

//   void deleteUser() {
//     MyApp.objectBox.userBox.removeAll();
//   }

//   //-----------------------Conversations----------------------------------

//   void insertConversation(Conversation conversation) {
//     try {
//       final dataJson = conversation.toJson();
//       final activeConversation = Conversation.fromJson(dataJson);
//       MyApp.objectBox.conversationBox.put(activeConversation);
//     } on Exception catch (e) {
//       print('Failed to insert conversation');
//     }
//   }

//   Future<bool> isConversationExist(Conversation conversation) async {
//     final count = await MyApp.objectBox.conversationBox
//         .query(Conversation_.idConversation.equals(conversation.idConversation)
//         &  Conversation_.members.containsElement(conversation.members!.join(','))
//         &  Conversation_.timestamp.equals(conversation.timestamp)

//         )
//         .build()
//         .count();
//     if (count > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<Conversation> getConversationById(int id) async {
//     final conversation = await MyApp.objectBox.conversationBox
//         .query(Conversation_.idConversation.equals(id))
//         .build()
//         .find()
//         .last;
//     return conversation;
//   }

//   Future<List<Conversation>> getAllConversation() async {
//     final conversation = await MyApp.objectBox.conversationBox
//         .query()
//         .build()
//         .find();
//     return conversation;
//   }
// }

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/conversation_model.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';

class LocalDataHelper {
  static List<Message> queuMessage = [];
  final authenticationController = Get.find<AuthenticationController>();
  List<Conversation> loadConversationFromLocal(
      List<Conversation> dataConversations) {
    List<Conversation> localDataConversations = [];
    if (MyApp.prefs.containsKey('CONVERSATIONS')) {
      localDataConversations = List<Conversation>.from(json
          .decode(MyApp.prefs.getString('CONVERSATIONS')!)
          .map((item) => Conversation.fromJson(item))
          .toList());

      if (localDataConversations != dataConversations &&
          dataConversations.isNotEmpty) {
        MyApp.prefs.setString('CONVERSATIONS', json.encode(dataConversations));
        localDataConversations = dataConversations;
      }
    } else {
      MyApp.prefs.setString('CONVERSATIONS', json.encode(dataConversations));
    }
    return localDataConversations;
  }

  List<Message> loadMessageFromLocal(
      String idConversation, List<Message> dataMessages) {
    List<Message> localMessages = [];
    //List<Message> queueMessages = loadQueueMessages();
    List<Message> queueMessages = loadQueueMessagesGroupByIdConversation(
        idConversation, loadQueueMessages());
    if (MyApp.prefs.containsKey(idConversation)) {
      localMessages = List<Message>.from(json
          .decode(MyApp.prefs.getString(idConversation)!)
          .map((item) => Message.fromJson(item))
          .toList());
      if (localMessages != dataMessages && dataMessages.isNotEmpty) {
        MyApp.prefs.setString(idConversation, json.encode(dataMessages));
        localMessages = dataMessages;
      }
    } else {
      MyApp.prefs.setString(idConversation, json.encode(dataMessages));
    }

    if (!localMessages.contains(queueMessages) && queueMessages.isNotEmpty) {
      localMessages = localMessages + queueMessages;
    }
    return localMessages;
  }

  void saveQueueMessages(Message message) {
    List<Message> queueMessages = [];
    String key = 'QUEUEMESSAGES';
    if (MyApp.prefs.containsKey(key)) {
      queueMessages = List<Message>.from(json
          .decode(MyApp.prefs.getString(key)!)
          .map((item) => Message.fromJson(item))
          .toList());
      queueMessages.add(message);
      //MyApp.prefs.setString(key, json.encode(queueMessages));
    } else {
      queueMessages.add(message);
      //MyApp.prefs.setString(key, json.encode(queueMessages));
    }
    MyApp.prefs.setString(key, json.encode(queueMessages));
  }

  List<Message> loadQueueMessages() {
    List<Message> queueMessages = [];
    String key = 'QUEUEMESSAGES';
    if (MyApp.prefs.containsKey(key)) {
      queueMessages = List<Message>.from(json
          .decode(MyApp.prefs.getString(key)!)
          .map((item) => Message.fromJson(item))
          .toList());
    }

    return queueMessages;
  }

  List<Message> loadQueueMessagesGroupByIdConversation(
      String idConversation, List<Message> queueMessages) {
    List<Message> messagesGroup = [];
    if (queueMessages.isNotEmpty) {
      for (var message in queueMessages) {
        if (message.idConversation == idConversation) {
          messagesGroup.add(message);
        }
      }
    }
    //print('messagesGroup: ${messagesGroup.toString()}');
    return messagesGroup;
  }

  // List<User> loadUserFromLocalByName(String name) {
  //   List<User> localUsers = [];
  //   if (!MyApp.prefs.containsKey('CONVERSATIONS')) {
  //     return localUsers;
  //   }
  //   List<Conversation> dataConversations = List<Conversation>.from(json
  //       .decode(MyApp.prefs.getString('CONVERSATIONS')!)
  //       .map((item) => Conversation.fromJson(item))
  //       .toList());
  //   List<String> idUser = [];
  //   dataConversations.forEach((element) {
  //     final id = element.members!.where(
  //         (idMember) => idMember != authenticationController.user.idUser);
  //     idUser.add(id.first);
  //   });

  //   idUser.forEach((element) {
  //     if (MyApp.prefs.containsKey(element)) {
  //       final user = User.fromJson(
  //           json.decode(MyApp.prefs.getString(element)!) as Map<String, dynamic>);
  //       if (user.name!.contains(name)) {
  //         localUsers.add(user);
  //       }
  //     }
  //   });
  // }
}

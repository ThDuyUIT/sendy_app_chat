import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sendy_app_chat/domain/models/conversation_model.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/dio_option.dart';
import 'package:sendy_app_chat/domain/services/socket_service.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';

class ChatService {
  final Dio _dio = DioOption().createDio();
  //final socket = SocketService();
  ChatService() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (MyApp.prefs.containsKey('TOKEN')) {
        MyApp.socket.initSocket();
      }
    });
    //socket.initSocket();
  }

  Future<String?> getConversation(List<String> listId) async {
    String? idConversation;
    final result = await _dio.request('/conversation/get',
        data: {'listId': listId},
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    if (result.statusCode == 200) {
      idConversation = result.data['idConversation'];
    }
    return idConversation;
  }

  Future createConversation(Conversation newConversation) async {
    final result = await _dio.request('/conversation/create',
        data: newConversation.toJson(),
        options: Options(method: 'POST', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));

    if (result.statusCode == 200 && result.data['success'] == true) {
      return true;
    }
    return false;
  }

  Future sendMessage2(Message message) async {
    MyApp.socket.emitEvent('SendMessage', message.toJson());
  }

  Future getAllConversationsById(String idUser) async {
    final result = await _dio.request('/conversation/getallbyid',
        data: {'id': idUser},
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    if (result.statusCode == 200) {
      return result.data['listConversation'];
    }
  }

  Future joinConversation(String? id) async {
    MyApp.socket.emitEvent('JoinConversation', {'idConversation': id});
  }

  Future fetchMessage(String idConversation, String idUser) async {
    final Completer<List<dynamic>> completer = Completer<List<dynamic>>();
    MyApp.socket.onListen('FetchMessagesSuccessfully', (data) async {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    });

    MyApp.socket.emitEvent(
        'FetchMessages', {'idConversation': idConversation, 'idUser': idUser});
    return await completer.future;
  }

  Future fetchConversation(String idUser) async {
    final Completer<List<dynamic>> completer = Completer<List<dynamic>>();
    MyApp.socket.onListen('FetchConversationsSuccessfully', (data) async {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    });
    MyApp.socket.emitEvent('FetchConversations', {'idUser': idUser});
    return await completer.future;
  }

  Future fetchLastMessage(String idMessage) async {
    final result = await _dio.request('/message/getLastMessage',
        data: {'idMessage': idMessage},
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));

    if (result.statusCode == 200) {
      return result.data['message'];
    }
  }

  Future syncQueueMessages(List<Message> queueMessages) async {
    final result = await _dio.request(
      '/message/syncQueueMessages',
      data: {'queueMessages': queueMessages},
      options: Options(method: 'POST', headers: {
        'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
      }),
    );

    if (result.statusCode == 200) {
      return result.data['message'];
    }
  }
}

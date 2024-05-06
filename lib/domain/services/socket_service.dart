import 'dart:convert';
import 'dart:io';

import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket socket;

  void initSocket() {
    // print('init socket');
     //print('idUser ${MyApp.prefs.getString('ID')}');
    User user = User.fromJson(json.decode(MyApp.prefs.getString('USER')!));
    socket = io("http://192.168.100.244:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "extraHeaders": {
      "bearer": "${MyApp.prefs.getString('TOKEN')}",
      "iduser": user.idUser
      }
    });
    socket.on('connect', (_) {
      print('Connected');
    });
    socket.connect();
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }

  void onListen(String event, Function callback) {
    socket.on(event, (data) => callback(data));
  }

  void dispose() {
    socket.disconnect();
  }
}

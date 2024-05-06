import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Add 'as firebase_auth' to create a prefix for the import
import 'package:get/get.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/data/localdata_helper.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/dio_option.dart';
import 'package:sendy_app_chat/domain/services/socket_service.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'dart:async'; // import this at the top of your file

class AuthenticationService {
  //static User user = User.init();
  final Dio _dio = DioOption().createDio();
  //final databaseHelper = DatabaseHelper();
  //final socket = SocketService();
  late firebase_auth.UserCredential
      userCredential; // Use the prefix 'firebase_auth' to refer to the UserCredential class
  Future<bool> registerOnFirebase(User newUser) async {
    userCredential = await firebase_auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: newUser.email, password: newUser.password!);
    if (userCredential.user != null) {
      return true;
    }
    return false;
  }

  // Future<bool> register(User newUser) async {
  //   final Completer<bool> completer = Completer<bool>();
  //   socket.initSocket();
  //   socket.emitEvent("register", newUser.toJson());

  //   socket.onListen("status_register", (data) {
  //     //print(data);
  //     completer.complete(data);
  //   });

  //   //try {
  //   return await completer.future;
  //   // } finally {
  //   //   socket.dispose();
  //   // }
  // }

  Future<bool> onRegister(User user) async {
    final result = await _dio.request('/user/signup',
        data: user.toJson(), options: Options(method: 'POST'));

    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }

  //****Old code login function */

  // Future onLogin(String email, String password) async {
  //   //databaseHelper.deleteUser();
  //   String uid = "";

  //   try {
  //     userCredential = await firebase_auth.FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //   } on Exception catch (e) {
  //     print(e.toString());
  //     return false;
  //   }

  //   uid = userCredential.user!.uid;

  //   // try {
  //   //   socket.initSocket();
  //   //   socket.emitEvent("login", uid);
  //   //   socket.onListen("info_user", (data) async {
  //   //     final isExistedData =
  //   //         await databaseHelper.isUserExist(User.fromJson(data));
  //   //     print("status data: " + isExistedData.toString());
  //   //     if (!isExistedData) {
  //   //       databaseHelper.insertUser(User.fromJson(data));
  //   //     }
  //   //   });
  //   //   return true;
  //   // } catch (e) {
  //   //   return false;
  //   // }

  //   final result = await _dio.request('/user/signin',
  //       data: {'uid': uid, 'email': email}, options: Options(method: 'GET'));

  //   if (result.statusCode == 200) {
  //     print(result.data['user'].toString());
  //     MyApp.prefs.setString("UID", uid);

  //     final savedUser = User.fromJson(result.data['user']);

  //     //print(savedUser.toString());
  //     savedUser.uid = uid;
  //     final isExistedData = await databaseHelper.isUserExist(savedUser);
  //     print("status data: " + isExistedData.toString());
  //     if (!isExistedData) {
  //       databaseHelper.insertUser(User.fromJson(savedUser.toJson()));
  //     }
  //     return true;
  //   }
  //   return false;
  // }

  Future onLogin(String email, String uid) async {
    User? logedinUser;
    final result = await _dio.request('/user/signin',
        data: {'uid': uid, 'email': email}, options: Options(method: 'GET'));

    if (result.statusCode == 200) {
      logedinUser = User.fromJson(result.data['user']);
      MyApp.prefs.setString('TOKEN', result.data['token']);
    }
    return logedinUser;
  }

  Future onLogout() async {
    final result = await _dio.request('/user/signout',
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    if (result.statusCode == 200 && result.data['signout'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future searchUser(String name) async {
    List<User> users = [];
    final result = await _dio.request('/search/$name',
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    users = (result.data['listUsers'] as List)
        .map((user) => User.fromJson(user))
        .toList();
    return users;
  }

  Future updateOnlineState(User user) async {
    print('update online state');
    await _dio.request('/user/online',
        data: user.toJson(),
        options: Options(method: 'PATCH', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    // if (result.statusCode == 200) {
    //   return;
    // }
  }

  Future getUserById(String id) async {
    final result = await _dio.request('/user/$id',
        options: Options(method: 'GET', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    if (result.statusCode == 200) {
      return result.data['user'];
    }
  }

  Future resetPassword(String email) async {
    
    await firebase_auth.FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);
  }
}

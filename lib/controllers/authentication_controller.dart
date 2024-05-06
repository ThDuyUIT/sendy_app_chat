import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/authentication_service.dart';
import 'package:sendy_app_chat/main.dart';
// import 'package:sendy_app_chat/objectbox.g.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/item_chats_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/list_chats_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/snackbar_widget.dart';

class AuthenticationController {
  User user = User.init();
  final authenticationServices = AuthenticationService();
  late firebase_auth.UserCredential userCredential;
  bool get isInternet => MyApp.connectivityController.isConnected.value;
  Future<bool> registerOnFirebase(User newUser) async {
    try {
      final registerOnFirebase =
          await authenticationServices.registerOnFirebase(newUser);
      if (registerOnFirebase) {
        await firebase_auth.FirebaseAuth.instance.currentUser!
            .sendEmailVerification();
        //newUser.id = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> onRegister(User newUser) async {
    bool isVerified =
        firebase_auth.FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      Completer<bool> completer = Completer<bool>();
      Timer.periodic(Duration(seconds: 3), (timer) async {
        await firebase_auth.FirebaseAuth.instance.currentUser!.reload();
        isVerified =
            firebase_auth.FirebaseAuth.instance.currentUser!.emailVerified;
        print(isVerified.toString());
        if (isVerified) {
          timer.cancel();
          bool isSuccess = await authenticationServices.onRegister(newUser);
          completer.complete(isSuccess);
        }
      });
      return completer.future;
    }
    return true;
  }

  //****Old code login function */

  // Future onLogin(String email, String password) async {
  //   //databaseHelper.deleteUser();
  //   final isSucess = await authenticationServices.onLogin(email, password);
  //   if (isSucess) {
  //     final authenticationController = Get.find<AuthenticationController>();

  //     authenticationController.user =
  //         await databaseHelper.getUserByUid(MyApp.prefs.getString('UID'));

  //   }
  //   return isSucess;
  // }

  Future onLogin(String email, String password) async {
    String uid = "";
    User? logedinUser;
    try {
      userCredential = await firebase_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        uid = userCredential.user!.uid;
        logedinUser = await authenticationServices.onLogin(email, uid);

        //print(logedinUser.toString());
        if (logedinUser != null) {
          MyApp.prefs.setString('USER', json.encode(logedinUser));
          MyApp.socket.initSocket();
          logedinUser.uid = uid;
          // final isExistedData =
          //     await databaseHelper.isUserExist(logedinUser.idUser);
          // if (!isExistedData) {
          //   databaseHelper.insertUser(logedinUser);
          final authenticationController = Get.find<AuthenticationController>();

          authenticationController.user = logedinUser;
          // }
          return true;
        }
        return false;
      } else {
        return false;
      }
    } on Exception catch (e) {
      return false;
    }
  }

  Future onLogout() async {
    if (isInternet) {
      final result = await authenticationServices.onLogout();
      if (result) {
        MyApp.prefs.clear();
        MyApp.socket.dispose();
      }
      return;
    }

    MyApp.prefs.clear();
    MyApp.socket.dispose();
  }

  // Future getAccountData() async {
  //   final authenticationController = Get.find<AuthenticationController>();
  //   authenticationController.user =
  //       await databaseHelper.getUserById(MyApp.prefs.getString('ID'));
  //   print(authenticationController.user.name);
  // }

  Future searchUser(String name) async {
    List<User> searchedUsers = [];
    final authenticationController = Get.find<AuthenticationController>();
    ListChatWidget.listSearhedItemChat.clear();
    if (name.isEmpty) {
      return;
    }
    if (isInternet) {
      searchedUsers = await authenticationServices.searchUser(name);
      if (searchedUsers.isNotEmpty &&
          ListChatWidget.listSearhedItemChat.isEmpty) {
        searchedUsers.forEach((element) {
          if (element.idUser != authenticationController.user.idUser) {
            ItemChatWidget item = ItemChatWidget(user: element);

            ListChatWidget.listSearhedItemChat.add(item);
          }
        });
      }
    }
    // Set<ItemChatWidget> setItemChat =
    //     Set<ItemChatWidget>.from(ListChatWidget.listItemChat);
    // ListChatWidget.listItemChat = setItemChat.toList();
  }

  Future resetPassword(BuildContext context, String email) async {
    List<String> methods = await firebase_auth.FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email);
    if (methods.isEmpty) {
      AppSnackbar().buildSnackbar(
          context, 'Email not register!', ColorApp.failedColor, Colors.white);
      return;
    }

    try {
      await authenticationServices.resetPassword(email);
      AppSnackbar().buildSnackbar(
          context,
          'Sent a password reset link to your email!',
          ColorApp.successColor,
          Colors.white);
    } on Exception catch (e) {
      AppSnackbar().buildSnackbar(
          context, e.toString(), ColorApp.failedColor, Colors.white);
    }
  }
}

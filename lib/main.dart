import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendy_app_chat/app_bindings.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/connectivity_controller.dart';
import 'package:sendy_app_chat/data/localdata_helper.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/authentication_service.dart';
import 'package:sendy_app_chat/domain/services/socket_service.dart';
import 'package:sendy_app_chat/objectbox_helper.dart';
import 'package:sendy_app_chat/presentations/pages/register_page.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/routes/app_pages.dart';
import 'package:sendy_app_chat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

//late ObjectBox objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppBindings().dependencies();
  MyApp.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //static late ObjectBox objectBox;
  static late SharedPreferences prefs;
  static final socket = SocketService();
  final authenticationController = Get.find<AuthenticationController>();
  static ConnectivityController connectivityController = ConnectivityController();
  //final databaseHelper = DatabaseHelper();
  MyApp({super.key}) {
    connectivityController.init();
    initSharePreferences();
  }

  // Future initObjectBox() async {
  //   try {
  //     objectBox = await ObjectBox.create();
  //     //authenticationController.user = await databaseHelper.getUser();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future initSharePreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('USER')) {
      // authenticationController.user =
      //     await databaseHelper.getUserById(prefs.getString('ID'));
      authenticationController.user =
          User.fromJson(json.decode(prefs.getString('USER')!));
    }
  }

  @override
  State<StatefulWidget> createState() {
    return StateMyApp();
  }
}

class StateMyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final authenticationService = AuthenticationService();
  //   if (state == AppLifecycleState.resumed) {
  //     widget.authenticationController.user.activeStatus = true;
  //     authenticationService.updateOnlineState(widget.authenticationController.user);
  //   } else {
  //     widget.authenticationController.user.activeStatus = false;
  //     authenticationService.updateOnlineState(widget.authenticationController.user);
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.bottomStart,
        textDirection: TextDirection.ltr,
        children: [
          GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: AppPage.INITIAL,
            getPages: AppPage.routes,
          ),
          //const ConnectionAlert()
        ]);
  }
}

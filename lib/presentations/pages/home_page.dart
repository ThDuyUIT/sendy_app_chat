import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
//import 'package:sendy_app_chat/objectbox.g.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/account_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/list_chats_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  late int indexPage;

  HomePage({required this.indexPage, super.key});
  @override
  State<StatefulWidget> createState() {
    return StateHomePage();
  }
}

class StateHomePage extends State<HomePage> {
  final authenticationController = Get.find<AuthenticationController>();
  //int indexPage = 0;

  final List<Widget> kindOfTab = [ListChatWidget(), AccountWidget()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorApp.mainColor,
      //   centerTitle: true,
      //   title: Text(widget.indexPage == 0 ? 'Conversations' : 'Account', style: const TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 23
      //   ),),
      // ),
      body: kindOfTab[widget.indexPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorApp.mainColor,
        items: const [
          BottomNavigationBarItem(
              label: 'Chats', icon: Icon(Icons.chat_outlined)),
          BottomNavigationBarItem(
              label: 'Account', icon: Icon(Icons.account_circle_outlined))
        ],
        currentIndex: widget.indexPage,
        onTap: (index) {
          setState(() {
            widget.indexPage = index;
          });
        },
      ),
    ));
  }
}

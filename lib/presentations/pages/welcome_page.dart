import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateWelcomePage();
  }
}

class StateWelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sendy',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: ColorApp.mainColor),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.mainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
              ),
              onPressed: () {
                Get.toNamed('/login');
              },
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorApp.mainColor),
                foregroundColor: ColorApp.mainColor,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
              ),
              onPressed: () {
                Get.toNamed('/register');
              },
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}

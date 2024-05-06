import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/input_text_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateResetPasswordPage();
  }
}

class StateResetPasswordPage extends State<ResetPasswordPage> {
  final authentication = AuthenticationController();
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: KeyboardDismisser(
            gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection

        ],
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: ColorApp.mainColor,
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter your email and we will send you a password reset link:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWidget(
                        hintText: 'Enter your registered email',
                        labelText: 'Email',
                        controller: controller,
                        focusNode: focusNode),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp.mainColor,
                                foregroundColor: Color(Colors.white.value),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10)),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              authentication.resetPassword(context, controller.text);
                            },
                            child: const Text('Send',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ))))
                  ],
                ),
              ),
            )));
  }
}

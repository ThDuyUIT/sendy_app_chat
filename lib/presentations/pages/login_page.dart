import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/bloc/authentication_provider.dart';
import 'package:sendy_app_chat/bloc/events/authetication_event.dart';
import 'package:sendy_app_chat/bloc/states/authentication_state.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/input_text_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/snackbar_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateLoginPage();
  }
}

class StateLoginPage extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool emptyEmail = false;
  bool emptyPassword = false;

  bool? isLogin;

  @override
  void initState() {
    emailFocus.addListener(() {
      setState(() {
        emptyEmail = checkEmptyField(emailFocus, emailController, emptyEmail);
      });
    });

    passwordFocus.addListener(() {
      setState(() {
        emptyPassword =
            checkEmptyField(passwordFocus, passwordController, emptyPassword);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool checkEmptyField(
      FocusNode focusNode, TextEditingController controller, bool empty) {
    if (!focusNode.hasFocus) {
      if (controller.text.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationProvier(
      child: SafeArea(
          child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: ColorApp.mainColor,
          ),
          body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state.isLogin != null) {
              isLogin = state.isLogin!;
            }
            //print('isLoading: ' + state.isLoading.toString() + ' isLogin: ' + state.isLogin!.toString());
            return state.isLoading || state.isLogin!
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorApp.mainColor,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 30,
                              color: ColorApp.mainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InputWidget(
                                hintText: 'Please input your email',
                                labelText: 'Email',
                                controller: emailController,
                                focusNode: emailFocus),
                            emptyEmail
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Your email is empty!',
                                      style: TextStyle(
                                          color: ColorApp.failedColor,
                                          fontSize: 15),
                                    ))
                                : const SizedBox(
                                    height: 10,
                                  ),
                            InputWidget(
                              hintText: 'Please input your password',
                              labelText: 'Password',
                              controller: passwordController,
                              focusNode: passwordFocus,
                              coverSuffixIcon: true,
                            ),
                            emptyPassword
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Your password is empty!',
                                      style: TextStyle(
                                          color: ColorApp.failedColor,
                                          fontSize: 15),
                                    ))
                                : const SizedBox(
                                    height: 15,
                                  ),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorApp.mainColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                    ),
                                    onPressed: () {
                                      if (emailController.text.isEmpty) {
                                        setState(() {
                                          emptyEmail = true;
                                        });
                                        return;
                                      }

                                      if (passwordController.text.isEmpty) {
                                        setState(() {
                                          emptyPassword = true;
                                        });
                                        return;
                                      }

                                      context
                                          .read<AuthenticationBloc>()
                                          .add(Login(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ));

                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        if (isLogin!) {
                                          Get.offAllNamed('/home');
                                          AppSnackbar().buildSnackbar(
                                              context,
                                              'Sign in successfully!',
                                              ColorApp.successColor,
                                              Colors.white);
                                        } else {
                                          AppSnackbar().buildSnackbar(
                                              context,
                                              'Sign in failed!',
                                              ColorApp.failedColor,
                                              Colors.white);
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ))),
                            const SizedBox(
                              height: 50,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () {
                                    Get.toNamed('/reset');
                                  },
                                  child: Text(
                                    'Forgot/Change Password?',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ColorApp.mainColor,
                                        decoration: TextDecoration.underline),
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
          }),
        ),
      )),
    );
  }
}

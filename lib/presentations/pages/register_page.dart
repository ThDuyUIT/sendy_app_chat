import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/bloc/authentication_provider.dart';
import 'package:sendy_app_chat/bloc/events/authetication_event.dart';
import 'package:sendy_app_chat/bloc/states/authentication_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
//import 'package:sendy_app_chat/objectbox.g.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/input_text_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:path/path.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateLoginPage();
  }
}

class StateLoginPage extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  //final authenticationController = AuthenticationController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode mailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode verifyFocusNode = FocusNode();

  bool isLoading = false;
  bool isSignUp = false;
  bool usedEmail = false;

  bool isEmptyName = false;
  bool isEmptyEmail = false;
  bool isEmptyPassword = false;
  bool valideEmail = true;
  bool notVerified = false;

  //late Store store;

  @override
  void initState() {
    // getApplicationDocumentsDirectory().then((dir) {
    //   store = Store(
    //     // This method is from the generated file
    //     getObjectBoxModel(),
    //     directory: join(dir.path, 'objectbox'),
    //   );
    // });
    nameFocusNode.addListener(() {
      setState(() {
        isEmptyName =
            checkEmptyField(nameFocusNode, nameController, isEmptyName);
      });
      //isEmptyName = checkEmptyField(nameFocusNode, nameController, isEmptyName);
    });

    mailFocusNode.addListener(() {
      setState(() {
        isEmptyEmail =
            checkEmptyField(mailFocusNode, mailcontroller, isEmptyEmail);
      });

      if (!isEmptyEmail && mailcontroller.text.isNotEmpty) {
        setState(() {
          valideEmail = checkValidEmail(mailcontroller.text);
        });
      }
    });

    passwordFocusNode.addListener(() {
      setState(() {
        isEmptyPassword = checkEmptyField(
            passwordFocusNode, passwordController, isEmptyPassword);
      });
    });

    verifyFocusNode.addListener(() {
      setState(() {
        notVerified = verifyPassword(verifyFocusNode, passwordController.text,
            verifyController.text, notVerified);
      });
    });
    super.initState();
  }

  // void onChange(String field) {

  //     if (nameController.text.isEmpty) {
  //       setState(() {
  //         isEmptyName = true;
  //       });
  //     } else {
  //       setState(() {
  //         isEmptyName = false;
  //       });
  //     }
  //   }

  void onChange(String field) {
    switch (field) {
      case 'name':
        if (nameController.text.isEmpty) {
          setState(() {
            isEmptyName = true;
          });
        } else {
          setState(() {
            isEmptyName = false;
          });
        }
        break;
      case 'email':
        if (mailcontroller.text.isEmpty) {
          setState(() {
            isEmptyEmail = true;
          });
        } else {
          setState(() {
            isEmptyEmail = false;
          });

          setState(() {
            valideEmail = checkValidEmail(mailcontroller.text);
          });
        }
        break;

      case 'password':
        if (passwordController.text.isEmpty) {
          setState(() {
            isEmptyPassword = true;
          });
        } else {
          setState(() {
            isEmptyPassword = false;
          });
        }
        break;

      default:
        if (verifyController.text != passwordController.text) {
          setState(() {
            notVerified = true;
          });
        } else {
          setState(() {
            notVerified = false;
          });
        }
        break;
    }
  }

  bool checkValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
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

  bool verifyPassword(
      FocusNode focusNode, String password, String verify, bool isMatch) {
    if (!focusNode.hasFocus) {
      if (password != verify) {
        return true;
      }
      return false;
    }
    return isMatch;
  }

  @override
  void dispose() {
    nameController.dispose();
    mailcontroller.dispose();
    passwordController.dispose();

    nameFocusNode.dispose();
    mailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationProvier(
      child: SafeArea(
        child:
            KeyboardDismisser(
              gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
              child: Scaffold(
                appBar: AppBar(
                  foregroundColor: ColorApp.mainColor,
                ),
                body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
              usedEmail = state.usedEmail!;
              if (state.isSuccessSignUp != null) {
                isSignUp = state.isSuccessSignUp!;
              }
              isLoading = state.isLoading;
              return Column(
                children: [
                  const ConnectionAlert(),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 30,
                              color: ColorApp.mainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        !state.isLoading && !state.isSuccessSignUp!
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InputWidget(
                                      hintText: 'Please input your name!',
                                      labelText: 'Full name',
                                      controller: nameController,
                                      focusNode: nameFocusNode,
                                      onChange: (text) => onChange('name')),
                                  isEmptyName == true
                                      ? Container(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Your name is empty!',
                                            style: TextStyle(
                                                color: ColorApp.failedColor,
                                                fontSize: 15),
                                          ))
                                      : const SizedBox(
                                          height: 10,
                                        ),
                                  InputWidget(
                                    hintText: 'Please input your email!',
                                    labelText: 'Email',
                                    controller: mailcontroller,
                                    focusNode: mailFocusNode,
                                    onChange: (text) => onChange('email'),
                                  ),
                                  isEmptyEmail == true
                                      ? Container(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Your email is empty!',
                                            style: TextStyle(
                                                color: ColorApp.failedColor,
                                                fontSize: 15),
                                          ))
                                      : !valideEmail
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'Format your email is wrong!',
                                                style: TextStyle(
                                                    color: ColorApp.failedColor,
                                                    fontSize: 15),
                                              ))
                                          : const SizedBox(
                                              height: 10,
                                            ),
                                  InputWidget(
                                      hintText: 'Please input your password!',
                                      labelText: 'Password',
                                      controller: passwordController,
                                      focusNode: passwordFocusNode,
                                      onChange: (text) => onChange('password')),
                                  isEmptyPassword
                                      ? Container(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Your password is empty!',
                                            style: TextStyle(
                                                color: ColorApp.failedColor,
                                                fontSize: 15),
                                          ))
                                      : const SizedBox(
                                          height: 10,
                                        ),
                                  InputWidget(
                                    hintText: 'Please input again your password!',
                                    labelText: 'Verify password',
                                    controller: verifyController,
                                    focusNode: verifyFocusNode,
                                    onChange: (text) => onChange('verify'),
                                  ),
                                  notVerified
                                      ? Container(
                                          //padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                          'Verify password are not match!',
                                          style: TextStyle(
                                              color: ColorApp.failedColor,
                                              fontSize: 15),
                                        ))
                                      : const SizedBox(
                                          height: 10,
                                        )
                                ],
                              )
                            : Column(
                                children: [
                                  const Center(child: CircularProgressIndicator()),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Please active your account by email!',
                                    style: TextStyle(
                                        fontSize: 20, color: ColorApp.failedColor),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isLoading) {
                                await firebase_auth.FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                return;
                              }
            
                              if (nameController.text.isEmpty) {
                                setState(() {
                                  isEmptyName = true;
                                });
                                return;
                              }
            
                              if (mailcontroller.text.isEmpty) {
                                setState(() {
                                  isEmptyEmail = true;
                                });
                                return;
                              }
            
                              if (!valideEmail) {
                                return;
                              }
            
                              if (passwordController.text.isEmpty) {
                                setState(() {
                                  isEmptyPassword = true;
                                });
                              }
            
                              if (verifyController.text != passwordController.text) {
                                setState(() {
                                  notVerified = true;
                                });
                                return;
                              }
            
                              User user = User(
                                  idUser: DateTime.now().millisecondsSinceEpoch.toString(),
                                  uid: '',
                                  name: nameController.text,
                                  email: mailcontroller.text,
                                  password: passwordController.text,
                                  gender: -1,
                                  );
            
                              context
                                  .read<AuthenticationBloc>()
                                  .add(SignUp(user: user));
            
                              Timer.periodic(Duration(seconds: 3), (timer) async {
                                if (isSignUp) {
                                  timer.cancel();
                                  Get.offNamed('/login');
                                  AppSnackbar().buildSnackbar(
                                      context,
                                      'Sign up successfully!',
                                      ColorApp.successColor,
                                      Colors.white);
                                } else {
                                  if (usedEmail) {
                                    timer.cancel();
                                    AppSnackbar().buildSnackbar(
                                        context,
                                        'Email already in use!',
                                        ColorApp.failedColor,
                                        Colors.white);
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp.mainColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.only(top: 10, bottom: 10)),
                            child: !isLoading
                                ? const Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 20),
                                  )
                                : const Text(
                                    'Send verification email again!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
                      },
                    )),
            ),
      ),
    );
  }
}

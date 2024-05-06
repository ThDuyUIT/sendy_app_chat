import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/bloc/authentication_provider.dart';
import 'package:sendy_app_chat/bloc/events/authetication_event.dart';
import 'package:sendy_app_chat/bloc/states/authentication_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
// import 'package:sendy_app_chat/objectbox.g.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/individual_info_widget.dart';

class AccountWidget extends StatefulWidget {
  bool? isProfile = false;
  AccountWidget({this.isProfile, super.key});

  @override
  State<StatefulWidget> createState() {
    return StateAccountWidget();
  }
}

class StateAccountWidget extends State<AccountWidget> {
  bool? isLogout;
  final authenticationController = Get.find<AuthenticationController>();
  final chatController = Get.find<ChatController>();
  late User user;

  @override
  void initState() {
    if (widget.isProfile == true) {
      user = chatController.user;
    } else {
      user = authenticationController.user;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorApp.mainColor,
          centerTitle: true,
          title: const Text(
            'Account',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        body: AuthenticationProvier(child:
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
          isLogout = state.isLogout;
          return state.isLoading || state.isLogout!
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorApp.mainColor,
                  ),
                )
              : Container(
                  //height: double.infinity,
                  width: double.infinity,
                  //padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      const ConnectionAlert(),
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        color: ColorApp.basicColor)
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: user.urlAvatar != null
                                      ? NetworkImage(user.urlAvatar!)
                                      : const AssetImage(
                                              'assets/images/empty-avatar.jpg')
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 40),
                              IndidualInfoWidget(
                                  title: 'Name', content: user.name),
                              IndidualInfoWidget(
                                  title: 'Email', content: user.email),
                              IndidualInfoWidget(
                                  title: 'Gender',
                                  content: user.gender == -1
                                      ? 'None'
                                      : user.gender == 0
                                          ? 'Female'
                                          : 'Male'),
                              const SizedBox(
                                height: 30,
                              ),
                              widget.isProfile == true
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextButton.icon(
                                              onPressed: () {
                                                Get.toNamed('/edit');
                                              },
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            ColorApp.mainColor),
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.white),
                                              ),
                                              icon: const Icon(
                                                Icons.edit_document,
                                                size: 30,
                                              ),
                                              label: const Text(
                                                'Edit Profile',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextButton.icon(
                                              onPressed: () {
                                                context
                                                    .read<AuthenticationBloc>()
                                                    .add(Logout());
                                                Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () {
                                                  if (isLogout!) {
                                                    Get.offAllNamed('/welcome');
                                                  }
                                                });
                                              },
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            ColorApp
                                                                .failedColor),
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.white),
                                              ),
                                              icon: const Icon(
                                                Icons.logout_outlined,
                                                size: 30,
                                              ),
                                              label: const Text(
                                                'Log out',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                      //Expanded(child: SizedBox())
                    ],
                  ),
                );
        })),
      ),
    );
  }
}

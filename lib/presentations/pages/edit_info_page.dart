// import 'dart:html';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sendy_app_chat/bloc/edit_info_bloc.dart';
import 'package:sendy_app_chat/bloc/edit_info_provider.dart';
import 'package:sendy_app_chat/bloc/events/edit_event.dart';
import 'package:sendy_app_chat/bloc/states/edit_info_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/input_text_widget.dart';

class EditInfoPage extends StatefulWidget {
  static XFile? imageFile;

  const EditInfoPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return StateEditInfoPage();
  }
}

class StateEditInfoPage extends State<EditInfoPage> {
  final authenticationController = Get.find<AuthenticationController>();
  bool get isInternet => MyApp.connectivityController.isConnected.value;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  final ImagePicker picker = ImagePicker();

  bool? isPickedAvatar;

  bool? isSaved;

  List<int> kindsOfGender = [-1, 0, 1];

  late int? _selectedGender = authenticationController.user.gender;

  @override
  Widget build(BuildContext context) {
    return EditInfoProvider(
      child: SafeArea(
        child: KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateDownDirection
          ],
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorApp.mainColor,
              foregroundColor: Colors.white,
            ),
            body: BlocBuilder<EditInfoBloc, EditInfoState>(
                builder: (context, state) {
              print(state.isUploadAvatar);
              try {
                isPickedAvatar = state.isUploadAvatar;
                isSaved = state.isSaved;
              } on Exception catch (e) {
                print(e.toString());
              }
              return state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const ConnectionAlert(),
                          const Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
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
                                              foregroundColor:
                                                  ColorApp.basicColor,
                                              backgroundImage: isPickedAvatar ==
                                                      true
                                                  ? FileImage(File(EditInfoPage
                                                      .imageFile!.path))
                                                  : authenticationController
                                                              .user.urlAvatar ==
                                                          null
                                                      ? const AssetImage(
                                                              "assets/images/empty-avatar.jpg")
                                                          as ImageProvider
                                                      : NetworkImage(
                                                          authenticationController
                                                              .user.urlAvatar!),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              right: -15,
                                              child: RawMaterialButton(
                                                onPressed: () async {
                                                  context
                                                      .read<EditInfoBloc>()
                                                      .add(UploadAvatar(
                                                          user:
                                                              authenticationController
                                                                  .user));
                                                },
                                                elevation: 2.0,
                                                fillColor: Color(0xFFF5F6F9),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                shape: const CircleBorder(),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: ColorApp.mainColor,
                                                  size: 30,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    InputWidget(
                                      hintText:
                                          authenticationController.user.name,
                                      labelText: 'Full name',
                                      controller: fullNameController,
                                      focusNode: fullNameFocusNode,
                                      defaultValue:
                                          authenticationController.user.name,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InputWidget(
                                      hintText:
                                          authenticationController.user.email,
                                      labelText: 'Email',
                                      controller: emailController,
                                      focusNode: emailFocusNode,
                                      defaultValue:
                                          authenticationController.user.email,
                                      readOnlyTextField: true,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          border: Border.all(
                                              width: 2,
                                              color: ColorApp.mainColor)),
                                      child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          isExpanded: true,
                                          value: _selectedGender,
                                          items: kindsOfGender
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(e == -1
                                                          ? 'None'
                                                          : e == 0
                                                              ? 'Female'
                                                              : 'Male'),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isInternet
                                              ? ColorApp.mainColor
                                              : Colors.grey,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                        ),
                                        onPressed: !isInternet
                                            ? null
                                            : () {
                                                User editedUser = User(
                                                    idUser:
                                                        authenticationController
                                                            .user.idUser,
                                                    name:
                                                        fullNameController.text,
                                                    email: emailController.text,
                                                    gender: _selectedGender,
                                                    urlAvatar:
                                                        authenticationController
                                                            .user.urlAvatar,
                                                    uid:
                                                        authenticationController
                                                            .user.uid);

                                                context
                                                    .read<EditInfoBloc>()
                                                    .add(Saved(
                                                        user: editedUser));
                                              },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}

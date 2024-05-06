import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/data/localdata_helper.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/edit_info_service.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/edit_info_page.dart';

class EditInfoController {
  EditInfoService editInfoService = EditInfoService();
  final authenticationController = Get.find<AuthenticationController>();
  //final databaseHelper = DatabaseHelper();
  Future pickAvatar() async {
    XFile? imageFile;
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  Future savedInfo(User user) async {
    late bool result;
    if (EditInfoPage.imageFile != null) {
      final uploadedImage = File(EditInfoPage.imageFile!.path);
      final urlDownloadImage =
          await editInfoService.uploadAvatar(uploadedImage);
      if (urlDownloadImage != null) {
        user.urlAvatar = urlDownloadImage;
        result = await editInfoService.updateUser(user);

        if (result) {
          //databaseHelper.updateUser(user);
          MyApp.prefs.setString('USER', json.encode(user.toJson()));
          authenticationController.user = user;
        }
        return result;

        // authenticationController.user.id_avatar = urlDownloadImage;
        // databaseHelper.updateUser(authenticationController.user);
      }
    } else {
      result = await editInfoService.updateUser(user);
      if (result) {
        // databaseHelper.updateUser(user).then((value) {
        //   authenticationController.user = user;
        // });
        MyApp.prefs.setString('USER', json.encode(user.toJson()));
        authenticationController.user = user;

        //print(authenticationController.user.name);
      }
      return result;
    }
  }
}

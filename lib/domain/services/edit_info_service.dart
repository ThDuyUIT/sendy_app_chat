import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/domain/services/dio_option.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/edit_info_page.dart';

class EditInfoService {
  final Dio _dio = DioOption().createDio();
  final authenticationController = Get.find<AuthenticationController>();
  Future uploadAvatar(File imageFile) async {
    String? downloadUrl;
    final storageRef = FirebaseStorage.instance.ref('Avatar');

    final uploadAvatar = await storageRef
        .child('img${authenticationController.user.idUser}')
        .putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
    downloadUrl = await uploadAvatar.ref.getDownloadURL();
    return downloadUrl;
  }

  Future updateUser(User user) async {
    final result = await _dio.request('/user/update',
        data: user.toJson(),
        options: Options(method: 'PUT', headers: {
          'Authorization': 'Bearer ${MyApp.prefs.getString('TOKEN')}'
        }));
    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }
}

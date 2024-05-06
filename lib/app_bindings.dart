import 'package:get/get.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';

class AppBindings {
  Future dependencies() async {
    Get.put(AuthenticationController());
    Get.put(ChatController());
  }
}

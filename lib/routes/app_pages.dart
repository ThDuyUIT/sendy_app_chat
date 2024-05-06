import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';
import 'package:sendy_app_chat/presentations/pages/edit_info_page.dart';
import 'package:sendy_app_chat/presentations/pages/home_page.dart';
import 'package:sendy_app_chat/presentations/pages/login_page.dart';
import 'package:sendy_app_chat/presentations/pages/register_page.dart';
import 'package:sendy_app_chat/presentations/pages/reset_password_page.dart';
import 'package:sendy_app_chat/presentations/pages/welcome_page.dart';
import 'package:sendy_app_chat/presentations/widgets/account_widget.dart';
import 'package:sendy_app_chat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPage {
  final authenticationController = Get.find<AuthenticationController>();
  static var INITIAL = MyApp.prefs.containsKey('USER')
      ? AppRoutes.HOME
      : AppRoutes.WELCOME;
  static var WELCOME = AppRoutes.WELCOME;
  static final routes = [
    GetPage(name: AppRoutes.WELCOME, page: () => WelcomePage()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterPage()),
    GetPage(name: AppRoutes.LOGIN, page: () => LoginPage()),
    GetPage(name: AppRoutes.HOME, page: () => HomePage(indexPage: 0)),
    GetPage(name: AppRoutes.EDIT, page: () => EditInfoPage()),
    GetPage(name: AppRoutes.CHAT, page: () => ChatPage()),
    GetPage(name: AppRoutes.RESET, page: () => ResetPasswordPage()),
    GetPage(name: AppRoutes.PROFILE, page: () => AccountWidget(isProfile: true,)),
  ];
}

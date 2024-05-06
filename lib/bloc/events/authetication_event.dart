import 'package:sendy_app_chat/domain/models/user_model.dart';

class AuthenticationEvent {
  late User user;
}

class Login extends AuthenticationEvent {
  late String email;
  late String password;
  Login({required String email, required String password}) {
    this.email = email;
    this.password = password;
  }
}

class SignUp extends AuthenticationEvent {
  SignUp({required User user}) {
    this.user = user;
  }
}

class Logout extends AuthenticationEvent {}

class SearchUser extends AuthenticationEvent {
  late String name;
  SearchUser({required String name}) {
    this.name = name;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendy_app_chat/bloc/events/authetication_event.dart';
import 'package:sendy_app_chat/bloc/states/authentication_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/presentations/widgets/list_chats_widget.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authenticationController = AuthenticationController();
  AuthenticationBloc() : super(AuthenticationState.initial()) {
    on<SignUp>((event, emit) => _signUp(event.user, emit));
    on<Login>((event, emit) => _login(event.email, event.password, emit));
    on<Logout>((event, emit) => _logout(emit));
    on<SearchUser>((event, emit) => _search(event.name, emit));
  }

  _signUp(User user, Emitter emit) async {
    final resultFromFirebase =
        await authenticationController.registerOnFirebase(user);
    if (resultFromFirebase) {
      emit(AuthenticationState.loading());
      user.uid = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
      final isSuccess = await authenticationController.onRegister(user);
      if (isSuccess) {
        emit(AuthenticationState.successSignUp());
      } else {
        emit(AuthenticationState.initial());
      }
    } else {
      List<String> signInMethods = await firebase_auth.FirebaseAuth.instance
          .fetchSignInMethodsForEmail(user.email);
      //print(signInMethods.isEmpty);
      for (var item in signInMethods) {
        print(item);
      }
      if (signInMethods.isNotEmpty) {
        print('email already exist');
        emit(AuthenticationState.usedEmail());
      } else {
        print('new email');
        emit(AuthenticationState.initial());
      }
    }
  }

  _login(String email, String password, Emitter emit) async {
    emit(AuthenticationState.loading());
    final isSuccess = await authenticationController.onLogin(email, password);
    if (isSuccess) {
      emit(AuthenticationState.login());
    } else {
      print('Login failed');
      emit(AuthenticationState.initial());
    }
  }

  _logout(Emitter emit) async {
    emit(AuthenticationState.loading());
    await authenticationController.onLogout();
    //await Future.delayed(const Duration(seconds: 3));
    emit(AuthenticationState.logout());
  }

  _search(String name, Emitter emit) async {
    //final authenticationService = AuthenticationService();
    if (name.isEmpty) {
      return;
    }
    emit(AuthenticationState.searching());
    await Future.delayed(Duration(seconds: 2));
    await authenticationController.searchUser(name);
    if (ListChatWidget.listSearhedItemChat.isNotEmpty) {
      emit(AuthenticationState.Found());
    } else {
      emit(AuthenticationState.notFound());
    }
    //await authenticationService.searchUser(name);
  }
}

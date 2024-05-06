import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';

class AuthenticationProvier extends StatelessWidget {
  const AuthenticationProvier({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
      child: child,
    );
  }
}

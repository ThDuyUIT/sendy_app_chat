import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendy_app_chat/bloc/edit_info_bloc.dart';

class EditInfoProvider extends StatelessWidget {
  const EditInfoProvider({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditInfoBloc>(
      create: (context) => EditInfoBloc(),
      child: child,
    );
  }
}

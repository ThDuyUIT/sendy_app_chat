import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendy_app_chat/bloc/chat_bloc.dart';

class ChatProvider extends StatelessWidget {
  const ChatProvider({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(), 
        child: child
    );
  }
}

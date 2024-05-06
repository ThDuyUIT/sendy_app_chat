import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sendy_app_chat/bloc/authentication_bloc.dart';
import 'package:sendy_app_chat/bloc/authentication_provider.dart';
import 'package:sendy_app_chat/bloc/events/authetication_event.dart';
import 'package:sendy_app_chat/bloc/states/authentication_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
// import 'package:sendy_app_chat/objectbox.g.dart';
import 'package:sendy_app_chat/presentations/pages/chat_page.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';
import 'package:sendy_app_chat/presentations/widgets/connection_alert_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/input_text_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/item_chats_widget.dart';
import 'package:sendy_app_chat/presentations/widgets/item_circle_avatar_widget.dart';

class ListChatWidget extends StatefulWidget {
  static List<ItemChatWidget> listSearhedItemChat = [];
  //static List<ItemChatWidget> listItemChat = [];
  @override
  State<StatefulWidget> createState() {
    return StateListChatWidget();
  }
}

class StateListChatWidget extends State<ListChatWidget> {
  List<ItemChatWidget> listItemChat = [];
  late Timer _fetchConversationsTimer;
  final authenticationController = Get.find<AuthenticationController>();
  final chatController = Get.find<ChatController>();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  late bool isSearching;
  bool? notFound;
  bool? emptySearch;
  bool existedConversation = false;
  int timesForUpdate = 0;

  List<ItemCircleAvatarWidget> listItemCircleAvatar = [];

  // Future<void> _initializeData() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   await chatController
  //       .getAllConversationsById(
  //           authenticationController.user.idUser.toString())
  //       .then((_) {
  //     setState(() {
  //       ListChatWidget.listItemChat = ListChatWidget.listItemChat;
  //     });
  //   });
  // }

  bool listsAreEqual(List<ItemChatWidget> list1, List<ItemChatWidget> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  Future fetchConversation() async {
    timesForUpdate = timesForUpdate + 1;
    List<ItemChatWidget> fetchedItemChat =
        await chatController.fetchConversation(
            authenticationController.user.idUser, timesForUpdate);

    if (fetchedItemChat.isNotEmpty) {
      fetchedItemChat.sort((a, b) =>
          int.parse(a.conversation!.lastMessage!.timestamp)
              .compareTo(int.parse(b.conversation!.lastMessage!.timestamp)));
    }

    if (!listsAreEqual(listItemChat, fetchedItemChat.reversed.toList())) {
      if (mounted) {
        setState(() {
          listItemChat = fetchedItemChat.reversed.toList();
        });
      }
    }
    if (timesForUpdate == 20) {
      timesForUpdate = 0;
    }
  }

  // Future fetchConversation() async {
  //   List<ItemChatWidget> fetchedItemChat = await chatController
  //       .fetchConversation(authenticationController.user.idUser.toString());
  //   if(listItemChat.isEmpty){
  //     listItemChat = fetchedItemChat;
  //   }
  // }

  @override
  void initState() {
    _fetchConversationsTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      await fetchConversation();
    });
    super.initState();
  }

  @override
  void dispose() {
    _fetchConversationsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
        GestureType.onVerticalDragDown
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorApp.mainColor,
          centerTitle: true,
          title: const Text(
            'Conversations',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        body: AuthenticationProvier(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            isSearching = state.isLoading;

            notFound = state.notFound;

            return Column(children: [
              ConnectionAlert(),
              Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorApp.basicColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        emptySearch = true;
                      } else {
                        emptySearch = false;
                      }
                      context
                          .read<AuthenticationBloc>()
                          .add(SearchUser(name: value));
                    },
                    controller: searchController,
                    focusNode: searchFocusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  )),
              // const SizedBox(
              //   height: 20,
              // ),
              (!isSearching && notFound == null) || emptySearch == true
                  ? Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await Future.delayed(
                                  const Duration(seconds: 3),
                                );
                                await fetchConversation();
                              },
                              child: ListView.builder(
                                  itemCount: listItemChat.length,
                                  itemBuilder: (context, index) {
                                    ItemChatWidget itemChat =
                                        listItemChat[index];
                                    return GestureDetector(
                                        onTap: () {
                                          final chatController =
                                              Get.find<ChatController>();
                                          chatController.user =
                                              itemChat.getUser();
                                          print(itemChat.conversation!.idConversation);
                                          ChatPage.idConversation = itemChat
                                              .conversation?.idConversation;
                                          Get.toNamed('/chat');
                                        },
                                        child: itemChat);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                  : notFound == null
                      ? const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : notFound == false
                          ? Expanded(
                              child: KeyboardDismisser(
                                gestures: const [
                                  GestureType.onVerticalDragDown,
                                ],
                                child: ListView.builder(
                                    itemCount: ListChatWidget
                                        .listSearhedItemChat.length,
                                    itemBuilder: (context, index) {
                                      ItemChatWidget itemChat = ListChatWidget
                                          .listSearhedItemChat[index];
                                      return GestureDetector(
                                        onTap: () {
                                          final chatController =
                                              Get.find<ChatController>();
                                          chatController.user =
                                              itemChat.getUser();
                                          Get.toNamed('/chat');
                                        },
                                        child: itemChat,
                                      );
                                    }),
                              ),
                            )
                          : const Expanded(
                              child: Center(
                                child: Text(
                                  'Not Found',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
            ]);
          }),
        ),
      ),
    );
  }
}

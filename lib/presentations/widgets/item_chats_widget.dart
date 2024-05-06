import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/chat_controller.dart';
import 'package:sendy_app_chat/domain/models/conversation_model.dart';
import 'package:sendy_app_chat/domain/models/message_model.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';

class ItemChatWidget extends StatefulWidget {
  late User user;
  Conversation? conversation;

  User getUser() {
    return user;
  }

  ItemChatWidget({required this.user, this.conversation, super.key});

  @override
  State<StatefulWidget> createState() {
    return StateItemChatWidget();
  }
}

class StateItemChatWidget extends State<ItemChatWidget> {
  Message? lastMessage;
  final authenticationController = Get.find<AuthenticationController>();
  final chatController = Get.find<ChatController>();
  late Timer _fetchConversationsTimer;

  Future fetchLastMessage() async {
    //if (!MyApp.connectivityController.isConnected.value) return;
    Message? fetchLastMessage = await chatController.fetchLastMessage(
        widget.conversation!.lastMessage!.idMessage.toString());

    if (fetchLastMessage != lastMessage) {
      if (mounted) {
        setState(() {
          lastMessage = fetchLastMessage;
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.conversation != null) {
      lastMessage = widget.conversation!.lastMessage;
      print(lastMessage.toString());
      _fetchConversationsTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        await fetchLastMessage();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.conversation != null) {
      _fetchConversationsTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorApp.basicColor)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: ColorApp.basicColor)
                        ],
                      ),
                      child: CircleAvatar(
                          foregroundColor: ColorApp.basicColor,
                          backgroundImage: widget.user.urlAvatar != null
                              ? NetworkImage(widget.user.urlAvatar!)
                              : const AssetImage(
                                      "assets/images/empty-avatar.jpg")
                                  as ImageProvider),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      lastMessage == null
                          ? SizedBox()
                          : Text(
                              lastMessage!.idSender ==
                                      authenticationController.user.idUser
                                  ? "You: ${lastMessage!.content}"
                                  : lastMessage!.content,
                              style: lastMessage!.idSender ==
                                      authenticationController.user.idUser
                                  ? const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey)
                                  : lastMessage!.status == 2
                                      ? const TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey)
                                      : const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),

                      // : lastMessage!.idSender ==
                      //         authenticationController.user.idUser
                      //             .toString()
                      //     ? Row(
                      //         children: [
                      //           Expanded(
                      //             //width: 100,
                      //             child: Text(
                      //               "You: ${lastMessage!.content}",
                      //               style: const TextStyle(
                      //                   fontSize: 16,
                      //                   fontStyle: FontStyle.italic,
                      //                   color: Colors.grey),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ),
                      //           // const SizedBox(
                      //           //   width: 10,
                      //           // ),

                      //         ],
                      //       )
                      //     : Expanded(
                      //         child: Text(
                      //           lastMessage!.content,
                      //           style: lastMessage!.status == 2
                      //               ? const TextStyle(
                      //                   fontSize: 16,
                      //                   fontStyle: FontStyle.italic,
                      //                   color: Colors.grey)
                      //               : const TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.bold),
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                lastMessage != null && lastMessage!.idSender == authenticationController.user.idUser &&
                        lastMessage!.status == 2
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: ColorApp.basicColor)
                          ],
                        ),
                        child: CircleAvatar(
                            foregroundColor: ColorApp.basicColor,
                            backgroundImage: widget.user.urlAvatar != null
                                ? NetworkImage(widget.user.urlAvatar!)
                                : const AssetImage(
                                        "assets/images/empty-avatar.jpg")
                                    as ImageProvider),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 15,
                ),
                Icon(Icons.circle_rounded,
                    size: 18,
                    color: widget.user.activeStatus == true
                        ? ColorApp.successColor
                        : ColorApp.failedColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

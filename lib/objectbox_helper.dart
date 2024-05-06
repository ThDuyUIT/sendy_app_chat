// import 'dart:io';

// import 'package:sendy_app_chat/domain/models/conversation_model.dart';
// import 'package:sendy_app_chat/domain/models/user_model.dart';
// import 'package:sendy_app_chat/objectbox.g.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

// class ObjectBox {
//   late final Store store;

//   late final Box<User> userBox;
//   late final Box<Conversation> conversationBox;

//   ObjectBox._create(this.store) {
//     userBox = Box<User>(store);
//     conversationBox = Box<Conversation>(store);
//   }

//   void onClear() {
//     userBox.removeAll();
//   }

//   static Future<ObjectBox> create() async {
//     final store = await openStore();
//     return ObjectBox._create(store);
//   }
// }

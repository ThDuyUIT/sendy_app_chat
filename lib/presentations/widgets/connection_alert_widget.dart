import 'package:flutter/material.dart';
import 'package:sendy_app_chat/controllers/connectivity_controller.dart';
import 'package:sendy_app_chat/main.dart';
import 'package:sendy_app_chat/presentations/widgets/network_alern_bar.dart';



class ConnectionAlert extends StatefulWidget {
  const ConnectionAlert({super.key});

  @override
  State<ConnectionAlert> createState() => _ConnectionAlertState();
}

class _ConnectionAlertState extends State<ConnectionAlert> {
  //ConnectivityController connectivityController = ConnectivityController();

  @override
  void initState() {
    //MyApp.connectivityController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MyApp.connectivityController.isConnected,
        builder: (context, value, child) {
          if (value) {
            return const SizedBox();
          } else {
            return const NetWorkAlertBar();
          }
        });
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';

class ItemCircleAvatarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateItemCircleAvatarWidget();
  }
}

class StateItemCircleAvatarWidget extends State<ItemCircleAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 80,
            width: 80,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: ColorApp.basicColor)
                    ],
                  ),
                  child: CircleAvatar(
                      foregroundColor: ColorApp.basicColor,
                      backgroundImage:
                          const AssetImage("assets/images/empty-avatar.jpg")
                              as ImageProvider),
                ),
                Positioned(
                    bottom: 0,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorApp.successColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 10,
                      height: 10,
                    )),
              ],
            ),
          ),
          Text('Duy')
        ],
      ),
    );
  }
}

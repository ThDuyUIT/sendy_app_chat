import 'package:flutter/material.dart';

class NetWorkAlertBar extends StatelessWidget {
  const NetWorkAlertBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 50,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "No Internet connection!!",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

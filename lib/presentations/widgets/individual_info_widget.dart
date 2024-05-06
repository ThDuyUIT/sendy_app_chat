import 'package:flutter/material.dart';

class IndidualInfoWidget extends StatefulWidget {
  late String title;
  late String content;

  IndidualInfoWidget({required this.title, required this.content,super.key});
  

  @override
  State<StatefulWidget> createState() {
    return StateIndidualInfoWidget();
  }
}

class StateIndidualInfoWidget extends State<IndidualInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only( bottom: 20),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${widget.title}: ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ]),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.content, style: const TextStyle(fontSize: 18),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

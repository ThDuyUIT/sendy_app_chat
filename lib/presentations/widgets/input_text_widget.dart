import 'package:flutter/material.dart';
import 'package:sendy_app_chat/presentations/styles/color_app.dart';

class InputWidget extends StatefulWidget {
  late String hintText;
  late String labelText;
  late TextEditingController controller;
  late FocusNode focusNode;
  String? defaultValue;
  void Function(String)? onChange;
  bool? coverSuffixIcon;
  bool? readOnlyTextField;

  InputWidget(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      required this.focusNode,
      this.onChange,
      this.defaultValue,
      this.coverSuffixIcon = false,
      this.readOnlyTextField});

  @override
  State<StatefulWidget> createState() {
    return StateInputWidget();
  }
}

class StateInputWidget extends State<InputWidget> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    //widget.controller.text = widget.defaultValue ?? '';
    if (widget.defaultValue != null) {
      widget.controller.text = widget.defaultValue!;
    }

    return TextField(
      readOnly: widget.readOnlyTextField ?? false,
      onChanged: widget.onChange,
      focusNode: widget.focusNode,
      controller: widget.controller,
      obscureText: widget.coverSuffixIcon == true ? !isVisible : isVisible,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: ColorApp.basicColor),
        suffix: widget.coverSuffixIcon == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    if (isVisible) {
                      isVisible = false;
                    } else {
                      isVisible = true;
                    }
                  });
                },
                child: Icon(
                  isVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 30,
                  color: ColorApp.mainColor,
                ),
              )
            : const SizedBox(),
        label: Text(
          widget.labelText,
          style: TextStyle(color: ColorApp.mainColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          // Change the default border color
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: ColorApp.mainColor, width: 2), // Change color and width
        ),
      ),
    );
  }
}

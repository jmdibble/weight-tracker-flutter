import 'package:flutter/material.dart';

class PrimaryFormField extends StatelessWidget {
  FocusNode myFocusNode = new FocusNode();

  TextEditingController controller;
  InputDecoration decoration;
  String Function(String) validator;
  String labelText;
  bool obscureText;
  TextInputType keyboardType;
  String initialValue;
  void Function() onTap;

  PrimaryFormField({
    Key key,
    this.controller,
    this.decoration,
    this.validator,
    this.labelText,
    this.obscureText,
    this.keyboardType,
    this.initialValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      initialValue: initialValue,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: (decoration ?? InputDecoration()).copyWith(
        labelText: labelText,
        labelStyle: TextStyle(
            color: myFocusNode.hasFocus
                ? Theme.of(context).primaryColor
                : Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}

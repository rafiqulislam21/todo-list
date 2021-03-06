import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  CustomTextfield({@required this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelText: labelText),
    );
  }
}

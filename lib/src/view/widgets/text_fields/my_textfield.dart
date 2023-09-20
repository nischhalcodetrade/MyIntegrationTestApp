import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validator,
      this.onTap});
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      keyboardType: onTap != null ? TextInputType.none : null,
    );
  }
}

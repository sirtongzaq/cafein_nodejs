// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: GlobalVariable.secondaryColor,
              width: 2,
            )),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${hintText}';
        }
        return null;
      },
    );
  }
}

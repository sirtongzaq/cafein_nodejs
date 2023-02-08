// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/common/widgets/custom_button.dart';
import 'package:cafein_nodejs/common/widgets/custom_textfield.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalVariable.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlobalVariable.imgLogo),
            SizedBox(height: 100),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomTextField(
                  controller: _emailController,
                  hintText: "",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  obscureText: false,
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomTextField(
                  controller: _passwordController,
                  hintText: "",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  obscureText: true,
                ),
              ),
            ),
            SizedBox(height: 50),
            CustomButton(text: "LOGIN", onTap: () {}, isLoading: isLoading),
            SizedBox(
              height: 20,
            ),
            Container(
              // msg
              padding: (EdgeInsets.symmetric(horizontal: 50)),
              child: Row(
                children: [
                  Text(
                    "Don‘t have an account?".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Signup here".toUpperCase(),
                      style: TextStyle(
                        color: GlobalVariable.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

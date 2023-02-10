// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:cafein_nodejs/common/widgets/custom_button.dart';
import 'package:cafein_nodejs/common/widgets/custom_textfield.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void sendPostRequest() async {
    final uri = "http://192.168.1.54:3000";
    final path = "/api/signup";
    final url = Uri.parse(uri+path);
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': 'example',
        'email': 'example@kindacode.com',
        'password': '123456'
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
                  hintText: "Email",
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
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  obscureText: true,
                ),
              ),
            ),
            SizedBox(height: 50),
            CustomButton(
              text: "LOGIN",
              onTap: () {
                print("testAPI");
                sendPostRequest();
              },
            ),
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
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) {
                            return const SignupScreen();
                          },
                        ),
                      );
                    },
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

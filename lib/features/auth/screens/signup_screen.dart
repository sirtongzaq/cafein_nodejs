// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/common/widgets/custom_button.dart';
import 'package:cafein_nodejs/common/widgets/custom_textfield.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signupUser() {
    authService.signupUser(
      context: context,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalVariable.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                    controller: _usernameController,
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.person,
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
                text: "SIGNUP",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signupUser();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // msg
                padding: (EdgeInsets.symmetric(horizontal: 40)),
                child: Row(
                  children: [
                    Text(
                      "You already have account?".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Loign here".toUpperCase(),
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
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors
import 'package:cafein_nodejs/common/widgets/custom_button.dart';
import 'package:cafein_nodejs/common/widgets/custom_textfield.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/screens/signup_screen.dart';
import 'package:cafein_nodejs/features/auth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signInUser() {
    authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text);
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
              text: "Login",
              onTap: () {
                signInUser();
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

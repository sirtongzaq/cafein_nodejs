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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: GlobalVariable.greybackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
              _isLoading
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        // login btn
                        child: Container(
                          width: 300,
                          height: 55,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 10.0),
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(1, 0),
                                  blurRadius: 10.0)
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : CustomButton(
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
                          color: Colors.black,
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

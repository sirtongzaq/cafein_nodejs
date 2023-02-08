// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/screens/auth_screen.dart';
import 'package:cafein_nodejs/route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CAFEIN',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariable.backgroundColor,
          colorScheme: ColorScheme.light(
            primary: GlobalVariable.secondaryColor,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
        onGenerateRoute: ((settings) => generateRoute(settings)),
        home: const AuthScreen());
  }
}

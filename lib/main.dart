// ignore_for_file: prefer_const_constructors
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/api_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/screens/home_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/login_screen.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => MongodbProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAFEIN',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.mitrTextTheme(),
          scaffoldBackgroundColor: GlobalVariable.backgroundColor,
          colorScheme: ColorScheme.light(
            primary: GlobalVariable.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
      home: Provider.of<UserProvider>(context).user.token.isEmpty ? const LoginScreen() : const HomeScreen(),
    );
  }
}
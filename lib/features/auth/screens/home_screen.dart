import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GlobalVariable.imgLogo,
        elevation: 0,
        toolbarHeight: 40,
      ),
      body: Center(child: Text("HOMESCREEN")),
    );
  }
}

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("ACCOUNT"),
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: Center(
          child: SafeArea(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: GlobalVariable.containerColor,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: GlobalVariable.thirdColor,
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  user.username.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              color: GlobalVariable.thirdColor,
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                title: Text(
                  user.email.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              color: GlobalVariable.thirdColor,
              child: ListTile(
                leading: Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
                title: Text(
                  user.age.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              color: GlobalVariable.thirdColor,
              child: ListTile(
                leading: Icon(
                  Icons.male,
                  color: Colors.white,
                ),
                title: Text(
                  user.gender.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              color: GlobalVariable.thirdColor,
              child: ListTile(
                leading: Icon(
                  Icons.coffee,
                  color: Colors.white,
                ),
                title: Text(
                  user.uid.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}

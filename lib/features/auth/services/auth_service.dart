import 'dart:io';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/constants/utils.dart';
import 'package:cafein_nodejs/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService {
  void signupUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: "",
        username: username,
        email: email,
        password: password,
        type: "",
        token: "",
      );
      final url = Uri.parse('http://192.168.1.54:3000/api/signup');
      http.Response res = await http.post(
        url,
        body: user.toJson(),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      if (res.statusCode == 200) {
        showSnackBar(context, "Account has been successfully created");
        
      }
      if (res.statusCode == 500) {
        showSnackBar(context, "Please enter a valid email address");
      }
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:ffi';

class User {
  final String username;
  final String email;
  final String password;
  final int age;
  final String gender;
  final String type;
  final String token;
  User({
    required this.username,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.type,
    required this.token,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'age': age,
      'gender': gender,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      type: map['type'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cafein_nodejs/common/widgets/custom_button.dart';
import 'package:cafein_nodejs/common/widgets/custom_emailfield.dart';
import 'package:cafein_nodejs/common/widgets/custom_numberfield.dart';
import 'package:cafein_nodejs/common/widgets/custom_textfield.dart';
import 'package:cafein_nodejs/common/widgets/gender.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/api_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/services/auth_service.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  final _confirmpasswordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _genderController = TextEditingController();
  late String defualtGender = "Male";
  List<Gender> genders = <Gender>[];
  File? _image;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", Icons.male, false));
    genders.add(new Gender("Female", Icons.female, false));
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageBytes = _image!.readAsBytesSync();
        print(pickedFile.path);
      } else {
        print("no img seleted");
      }
    });
  }

  void signupUser() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String cpassword = _confirmpasswordController.text;
    String age = _ageController.text;
    setState(() {
      _isLoading = false;
    });
    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        cpassword.isEmpty &&
        age.isEmpty &&
        _imageBytes!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete the information'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      if (passwordConfrimed()) {
        final cloudinary = CloudinaryPublic("dm9o8zskz", "cbnrtd8l");
        CloudinaryResponse resimg = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(_image!.path, folder: "ImgProfile"));
        print(resimg.secureUrl);
        var uuid = Uuid();
        authService.signUpUser(
          context: context,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          age: _ageController.text,
          gender: defualtGender,
          uid: uuid.v5(Uuid.NAMESPACE_URL, _usernameController.text),
          img: resimg.secureUrl,
        );
        ApiProvider().postuserData({
          "name": _usernameController.text,
          "gender": defualtGender,
          "age": int.parse(_ageController.text),
          "uid": uuid.v5(Uuid.NAMESPACE_URL, _usernameController.text),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Enter the same password'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
    }
  }

  bool passwordConfrimed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: GlobalVariable.greybackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlobalVariable.imgLogo),
              SizedBox(height: 25),
              _image == null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ).image,
                      backgroundColor: Colors.white,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 150),
                child: GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Padding(
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
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomEmailField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  obscureText: false,
                ),
              ),
              SizedBox(height: 15),
              Padding(
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
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomTextField(
                  controller: _confirmpasswordController,
                  hintText: "Confirm Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomNumberField(
                  controller: _ageController,
                  hintText: "Age",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  obscureText: false,
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: genders.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          setState(() {
                            genders
                                .forEach((gender) => gender.isSelected = false);
                            genders[index].isSelected = true;
                            defualtGender = genders[index].name.toString();
                          });
                        },
                        child: CustomRadio(genders[index]),
                      );
                    }),
              ),
              SizedBox(height: 25),
              _isLoading
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        child: Container(
                          width: 300,
                          height: 55,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 10.0),
                              BoxShadow(
                                  color: Colors.grey,
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
                      text: "Signup",
                      onTap: () {
                        signupUser();
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

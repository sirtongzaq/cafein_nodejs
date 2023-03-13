import 'dart:io';
import 'dart:typed_data';

import 'package:cafein_nodejs/common/widgets/category.dart';
import 'package:cafein_nodejs/common/widgets/category_header.dart';
import 'package:cafein_nodejs/common/widgets/gender.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CommunityPostScreen extends StatefulWidget {
  const CommunityPostScreen({super.key});

  @override
  State<CommunityPostScreen> createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  TextEditingController message = TextEditingController();
  TextEditingController title = TextEditingController();
  double? ratings;
  String datetimenow = DateTime.now().toString().substring(0, 16);
  File? _image;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  late String defualtGender = "knowledge".toUpperCase();
  List<Gender> genders = <Gender>[];
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

  @override
  void initState() {
    genders.add(new Gender("knowledge".toUpperCase(), Icons.light, false));
    genders.add(new Gender("coffee beans".toUpperCase(), Icons.coffee, false));
    genders.add(
        new Gender("drink recipes".toUpperCase(), Icons.coffee_maker, false));
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<MongodbProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("COMMUNITY POST"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _image == null
                ? InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/4886/4886318.png",
                          fit: BoxFit.contain,
                          width: 342,
                          height: 230),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!,
                            fit: BoxFit.cover, width: 342, height: 230)),
                  ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: 350,
                height: 50,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  controller: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        )),
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: 350,
                height: 250,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  controller: message,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        )),
                    hintText: "Type some thing about article",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
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
                          defualtGender =
                              genders[index].name.toString().toLowerCase();
                        });
                      },
                      child: CustomRadio(genders[index]),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                child: Card(
                  elevation: 0,
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        datetimenow,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 180,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _isLoading = false;
                          });
                          if (_image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please upload image'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(30),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final cloudinary =
                                CloudinaryPublic("dm9o8zskz", "cbnrtd8l");
                            CloudinaryResponse resimg =
                                await cloudinary.uploadFile(
                                    CloudinaryFile.fromFile(_image!.path,
                                        folder: "PostCommunity"));
                            apiProvider.postCommunity({
                              "uid": user.uid,
                              "email": user.email,
                              "title": title.text.trim(),
                              "message": message.text.trim(),
                              "image": resimg.secureUrl,
                              "type": defualtGender,
                              "date": datetimenow,
                            });
                            message.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Post community has been successfully'),
                                backgroundColor: GlobalVariable.secondaryColor,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(30),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: _isLoading
                            ? SizedBox(
                                child: CircularProgressIndicator(),
                                height: 10.0,
                                width: 10.0,
                              )
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

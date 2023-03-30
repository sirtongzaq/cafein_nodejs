import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/api_provider.dart';

class ReviewStore extends StatefulWidget {
  final String storename;
  ReviewStore({required this.storename});

  @override
  _ReviewStoreState createState() => _ReviewStoreState();
}

class _ReviewStoreState extends State<ReviewStore> {
  TextEditingController message = TextEditingController();
  double? ratings;
  String datetimenow = DateTime.now().toString().substring(0, 16);
  File? _image;
  Uint8List? _imageBytes;
  bool _isLoading = false;

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
        title: Text("${widget.storename} Review"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                width: 400,
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
                      Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        user.email.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                    hintText: "What do you think about this store",
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
                        "RATING",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => GlobalVariable.ratingImg,
                        onRatingUpdate: (rating) {
                          ratings = rating.toDouble();
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: 185,
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
                                        folder: "ImgReview"));
                            apiProvider.reviewStore({
                              "uid": user.uid,
                              "email": user.email,
                              "storename": widget.storename,
                              "message": message.text.trim(),
                              "rating": ratings,
                              "image": resimg.secureUrl,
                              "date": datetimenow,
                            });
                            ApiProvider().postuserReview({
                              "uid": user.uid,
                              "rating": ratings,
                              "store": widget.storename,
                              "message": message.text.trim(),
                              "date": datetimenow,
                            });
                            message.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Store review  has been successfully'),
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

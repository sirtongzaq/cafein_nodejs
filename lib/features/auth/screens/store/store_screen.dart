import 'dart:convert';
import 'dart:io';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/api_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/screens/store/map_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/store/review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  final String storename;
  StoreScreen({required this.storename});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<dynamic> _dataStore = [];
  List<dynamic> get dataStore => _dataStore;
  List<dynamic> result = [];
  List<dynamic> _foundData = [];
  Future<void> fetchDataStore() async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/postStore');
      http.Response res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        final jsonData = jsonDecode(res.body);
        _dataStore = jsonData;
        result = dataStore
            .where((user) =>
                user["string_name"].toString().contains(widget.storename))
            .toList();
        setState(() {
          _foundData = result;
        });
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> resultdataReivewStore = [];
  List<dynamic> _dataReivewStore = [];
  List<dynamic> get dataReivewStore => _dataReivewStore;
  List<dynamic> _foundDataReivewStore = [];
  Future<void> fetchDataReviewStore() async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/reviewStore');
      http.Response res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        final jsonData = jsonDecode(res.body);
        _dataReivewStore = jsonData;
        resultdataReivewStore = dataReivewStore
            .where((user) =>
                user["storename"].toString().contains(widget.storename))
            .toList();
        setState(() {
          _foundDataReivewStore = resultdataReivewStore;
        });
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    fetchDataStore();
    fetchDataReviewStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<MongodbProvider>(context, listen: false);
    final apiProvider2 = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ReviewStore(storename: widget.storename),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(widget.storename),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: fetchDataStore(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _foundData.length,
                      itemBuilder: (context, index) {
                        var data = _foundData[index];
                        var rt = data["rating"];
                        var tel = data["contact"];
                        int count_like = data["likes"].length;
                        String _ulr = data['facebook'];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ImageSlideshow(
                                //Img slide
                                width: double.infinity,
                                height: 400,
                                initialPage: 0,
                                indicatorColor: Colors.black,
                                indicatorBackgroundColor: Colors.grey,
                                // ignore: sort_child_properties_last
                                children: [
                                  Image.asset(
                                    'assets/coffee01.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/coffee02.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/coffee03.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ],
                                isLoop: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                // detail body
                                elevation: 0,
                                color: Colors.white,
                                margin: EdgeInsets.all(15),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DETAIL",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            data["address"],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "PRICE",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "${data["price"]}",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 100),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "OPEN DAILY",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  data["open_daily"],
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "CONTACT",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                data["contact"],
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "TYPE",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  data["type"]
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                launch('tel:$tel');
                                                print(tel);
                                              },
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                launchUrl(Uri.parse(_ulr));
                                                print(_ulr);
                                              },
                                              child: Icon(
                                                Icons.facebook,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        MapStore(
                                                            storename: widget
                                                                .storename,
                                                            latitude: result[0]
                                                                ["map"][0],
                                                            longitude: result[0]
                                                                ["map"][1]),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.near_me,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "RATTING",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: double.parse(rt),
                                            itemBuilder: (context, index) =>
                                                GlobalVariable.ratingImg,
                                            itemCount: 5,
                                            itemSize: 15,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(
                                            width: 75,
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: (data["likes"]
                                                          .contains(user.uid))
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                                onTap: () {
                                                  apiProvider.likeStore({
                                                    "string_name":
                                                        widget.storename,
                                                    "uid": user.uid
                                                  });
                                                  apiProvider2.postuserEvent({
                                                    "uid": user.uid,
                                                    "event": "like",
                                                    "Content": widget.storename,
                                                  });
                                                },
                                              ),
                                              Text(
                                                count_like.toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
            Padding(
              // CONTENT header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "MENU",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ),
            Container(
              width: 1000,
              height: 150,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: <Widget>[
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU1",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.containerColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU2",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU3",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU4",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU5",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU6",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU7",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU8",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU9",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: GlobalVariable.greybackgroundColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: GlobalVariable.greybackgroundColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU10",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ])),
            ),
            Padding(
              // CONTENT header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "REVIEW",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ),
            FutureBuilder(
                future: fetchDataReviewStore(),
                builder: (context, snapshot) {
                  return Container(
                    height: 450,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _foundDataReivewStore.length,
                        itemBuilder: (context, index) {
                          var data = _foundDataReivewStore[index];
                          var storename = data["storename"];
                          var email = data["email"];
                          var message = data["message"];
                          var image = data["image"];
                          var date = data["date"];
                          var rt = data["rating"];
                          int count_like = data["likes"].length;
                          return Card(
                            // detail review
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            color: Colors.white,
                            margin: EdgeInsets.all(15),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(image,
                                        fit: BoxFit.cover,
                                        width: 342,
                                        height: 230),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "EMAIL",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        email.toString().toUpperCase(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 340,
                                    height: 100,
                                    child: Text(
                                      message,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "DATE",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "RATING",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(rt),
                                        itemBuilder: (context, index) =>
                                            GlobalVariable.ratingImg,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.favorite,
                                          color:
                                              (data["likes"].contains(user.uid))
                                                  ? Colors.black
                                                  : Colors.grey,
                                        ),
                                        onTap: () {
                                          apiProvider.likeReviewStore({
                                            "review_id": data["_id"],
                                            "uid": user.uid
                                          });
                                          apiProvider.postNotification({
                                            "email": user.email,
                                            "title": "${storename} review",
                                            "own_email": email,
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        count_like.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

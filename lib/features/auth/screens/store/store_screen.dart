import 'dart:convert';
import 'dart:io';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/screens/store/map_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/store/napwarinmap_page.dart';
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

  @override
  void initState() {
    fetchDataStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<MongodbProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => MapStore(storename: widget.storename),
            ),
          );
        },
        backgroundColor: GlobalVariable.secondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(widget.storename),
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return FutureBuilder(
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
                                      indicatorColor:
                                          GlobalVariable.secondaryColor,
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
                                      color: GlobalVariable.containerColor,
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
                                                  style: TextStyle(
                                                      color: GlobalVariable
                                                          .secondaryColor),
                                                ),
                                                Text(
                                                  data["address"],
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                          color: GlobalVariable
                                                              .secondaryColor),
                                                    ),
                                                    Text(
                                                      "${data["price"]}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 100),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "OPEN DAILY",
                                                        style: TextStyle(
                                                            color: GlobalVariable
                                                                .secondaryColor),
                                                      ),
                                                      Text(
                                                        data["open_daily"],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                                          color: GlobalVariable
                                                              .secondaryColor),
                                                    ),
                                                    Text(
                                                      data["contact"],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "TYPE",
                                                        style: TextStyle(
                                                            color: GlobalVariable
                                                                .secondaryColor),
                                                      ),
                                                      Text(
                                                        data["type"]
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      launch('tel:$tel');
                                                      print(tel);
                                                    },
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      launchUrl(
                                                          Uri.parse(_ulr));
                                                      print(_ulr);
                                                    },
                                                    child: Icon(
                                                      Icons.facebook,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      print(
                                                          data["string_name"]);
                                                      Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                             const NapswarinMapPage()
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.near_me,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                "RATTING",
                                                style: TextStyle(
                                                    color: GlobalVariable
                                                        .secondaryColor),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                RatingBarIndicator(
                                                  rating: double.parse(rt),
                                                  itemBuilder: (context,
                                                          index) =>
                                                      GlobalVariable.ratingImg,
                                                  itemCount: 5,
                                                  itemSize: 15,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
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
                                                                .contains(
                                                                    user.uid))
                                                            ? GlobalVariable
                                                                .secondaryColor
                                                            : Colors.white,
                                                      ),
                                                      onTap: () {
                                                        apiProvider.likeStore({
                                                          "string_name":
                                                              widget.storename,
                                                          "uid": user.uid
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      count_like.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
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
                                    Padding(
                                      // CONTENT header
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "MENU",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
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
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalVariable
                                                    .containerColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 10.0),
                                                  BoxShadow(
                                                      color: GlobalVariable
                                                          .containerColor,
                                                      offset: Offset(4, 0),
                                                      blurRadius: 10.0)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.black,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ])),
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                }),
          ],
        ),
      ),
    );
  }
}

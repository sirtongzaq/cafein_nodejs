import 'dart:convert';
import 'dart:io';
import 'package:cafein_nodejs/common/widgets/category_header.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TestAPI extends StatefulWidget {
  final String user_uid;
  TestAPI({required this.user_uid});

  @override
  State<TestAPI> createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
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
            .where((user) => user["likes"].toString().contains(widget.user_uid))
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

  List<dynamic> _dataReview = [];
  List<dynamic> get dataReview => _dataReview;
  List<dynamic> resultReview = [];
  List<dynamic> _foundDataReview = [];
  Future<void> fetchDataReview() async {
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
        _dataReview = jsonData;
        resultReview = dataReview
            .where((user) => user["likes"].toString().contains(widget.user_uid))
            .toList();
        setState(() {
          _foundDataReview = resultReview;
        });
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> _dataCommunity = [];
  List<dynamic> get dataCommunity => _dataCommunity;
  List<dynamic> resultCommunity = [];
  List<dynamic> _foundDataCommunity = [];
  Future<void> fetchDataCommunity() async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/postCommunity');
      http.Response res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        final jsonData = jsonDecode(res.body);
        _dataCommunity = jsonData;
        resultCommunity = dataCommunity
            .where((user) => user["likes"].toString().contains(widget.user_uid))
            .toList();
        setState(() {
          _foundDataCommunity = resultCommunity;
        });
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    duration() async* {
      while (true) {
        await Future.delayed(Duration(milliseconds: 500));
        yield "";
      }
    }

    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<MongodbProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("FAVORITE"),
        backgroundColor: Colors.black,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 14),
            CustomHeader(text: "STORE LIKED"),
            SizedBox(height: 14),
            FutureBuilder(
              future: fetchDataStore(),
              builder: (context, snapshot) {
                return Container(
                  height: 300,
                  child: ListView.builder(
                      itemCount: _foundData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final data_info = _foundData[index];
                        final name = data_info['string_name'];
                        final rating = data_info['rating'];
                        final address = data_info['address'];
                        final review = data_info['count_rating'];
                        int count_like = data_info["likes"].length;
                        var rt = double.parse(rating);
                        return InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                // img
                                height: 300,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/coffee01.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                // body
                                height: 300,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      // title store
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        name.toString().toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      // address store
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        address,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      // distance store
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            "REVIEW ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            width: 120,
                                            child: Text(
                                              "${review}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Padding(
                                      // ratting store
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: RatingBarIndicator(
                                        rating: rt,
                                        itemBuilder: (context, index) =>
                                            GlobalVariable.ratingImg,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            child: Icon(
                                              Icons.favorite,
                                              color: (data_info["likes"]
                                                      .contains(user.uid))
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                            onTap: () {
                                              apiProvider.likeStore({
                                                "string_name": name,
                                                "uid": user.uid
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
            SizedBox(height: 14),
            CustomHeader(text: "REVIEW LIKED"),
            FutureBuilder(
                future: fetchDataReview(),
                builder: (context, snapshot) {
                  return Container(
                    height: 495,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _foundDataReview.length,
                        itemBuilder: (context, index) {
                          var data = _foundDataReview[index];
                          var storename = data["storename"];
                          var email = data["email"];
                          var message = data["message"];
                          var image = data["image"];
                          var date = data["date"];
                          var rt = data["rating"];
                          int count_like = data["likes"].length;
                          return Card(
                            // detail review
                            elevation: 0,
                            color: Colors.white,
                            margin: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                        "STORE",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        storename.toString().toUpperCase(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
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
                                    ],
                                  ),
                                  Row(
                                    children: [
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
            CustomHeader(text: "COMMUNITY LIKED"),
            FutureBuilder(
                future: fetchDataCommunity(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _foundDataCommunity.length,
                      itemBuilder: (context, index) {
                        var data = _foundDataCommunity[index];
                        var title = data["title"];
                        var email = data["email"];
                        var message = data["message"];
                        var image = data["image"];
                        var type = data["type"];
                        var date = data["date"];
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
                                      "TITLE",
                                      style: TextStyle(
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      title.toString().toUpperCase(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 340,
                                  child: Text(
                                    message,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "POST",
                                      style: TextStyle(
                                          color: Colors.black),
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
                                Row(
                                  children: [
                                    Text(
                                      "TYPE",
                                      style: TextStyle(
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      type.toString().toUpperCase(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "DATE",
                                      style: TextStyle(
                                          color: Colors.black),
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
                                    InkWell(
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                            (data["likes"].contains(user.uid))
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                      onTap: () {
                                        apiProvider.likePostCummnity({
                                          "post_id": data["_id"],
                                          "uid": user.uid
                                        });
                                        apiProvider.postNotification({
                                          "email": user.email,
                                          "title": "${title} post",
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
                      });
                }),
          ],
        ),
      ),
    );
  }
}

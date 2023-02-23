import 'dart:convert';
import 'dart:io';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'store/store_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> _foundData = [];
  List<dynamic> _dataStore = [];
  List<dynamic> get dataStore => _dataStore;
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
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void Search(String value) {
    List<dynamic> result = [];
    if (value.isEmpty) {
      result = dataStore;
    } else {
      result = dataStore
          .where((user) => user["string_name"]
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundData = result;
    });
  }

  @override
  void initState() {
    fetchDataStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: TextField(
          onChanged: (value) => Search(value),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: InputDecoration(
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
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: GlobalVariable.containerColor,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            prefixIconColor: Colors.white,
          ),
        ),
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _foundData.length,
                itemBuilder: (context, index) {
                  var rt = _foundData[index]["rating"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Card(
                      color: Color.fromRGBO(183, 194, 255, 1),
                      semanticContainer: false,
                      elevation: 0,
                      child: ListTile(
                        leading: FittedBox(
                            child: Image(
                                image: AssetImage('assets/coffee01.jpg'),
                                fit: BoxFit.fill)),
                        title: Text(
                          _foundData[index]["string_name"]
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                              color: Color.fromRGBO(141, 158, 255, 1)),
                        ),
                        subtitle: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address : ${_foundData[index]["address"]}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Type : ${_foundData[index]["type"]}',
                                style: TextStyle(color: Colors.white),
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
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => StoreScreen(
                                  storename: _foundData[index]["string_name"]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

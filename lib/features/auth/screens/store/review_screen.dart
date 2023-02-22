import 'dart:convert';
import 'dart:io';

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewStore extends StatefulWidget {
  final String storename;
  ReviewStore({required this.storename});
  
  @override
  _ReviewStoreState createState() => _ReviewStoreState();
}

class _ReviewStoreState extends State<ReviewStore> {
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
            .where((user) => user["string_name"].toString().contains(widget.storename))
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
  Widget build(BuildContext context) {
    return Text(widget.storename);
  }
}

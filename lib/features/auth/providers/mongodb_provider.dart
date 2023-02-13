import 'dart:io';

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MongodbProvider with ChangeNotifier {
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
        print(jsonData);
        _dataStore = jsonData;
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

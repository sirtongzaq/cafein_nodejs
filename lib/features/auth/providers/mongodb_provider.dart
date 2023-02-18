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
        _dataStore = jsonData;
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<dynamic>> fetchDataStoreRealtime(Duration refreshRate) async* {
  while (true) {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/postStore');
      http.Response res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        _dataStore = jsonData;
        yield _dataStore;
      } else {
        throw Exception("Connection failed with status code: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
      yield [];
    }
    await Future.delayed(refreshRate);
  }
}

  Future<void> likeStore(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/likeStore');
      http.Response res = await http.put(
        url,
        body: jsonEncode(body),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      if (res.statusCode == 200) {
        print('Request successful!');
        print(res.body);
      } else {
        print('Request failed with status: ${res.statusCode}.');
        print(res.body);
      }
    } catch (e) {
      print('Error occurred: ${e.toString()}');
    }
  }
}

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

  List<dynamic> _dataReivewStore = [];
  List<dynamic> get dataReivewStore => _dataReivewStore.reversed.take(10).toList();
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
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
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

  Future<void> reviewStore(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/reviewStore');
      http.Response res = await http.post(
        url,
        body: json.encode(body),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        print(res.body);
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeReviewStore(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/likeReviewStore');
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

  List<dynamic> _dataCommunity = [];
  List<dynamic> get dataCommunity => _dataCommunity.reversed.take(10).toList();
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
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postCommunity(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/postCommunity');
      http.Response res = await http.post(
        url,
        body: json.encode(body),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        print(res.body);
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likePostCummnity(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/likePostCommunity');
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

  Future<void> postNotification(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/notification');
      http.Response res = await http.post(
        url,
        body: json.encode(body),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        print(res.body);
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

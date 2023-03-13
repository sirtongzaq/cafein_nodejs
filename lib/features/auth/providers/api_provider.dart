import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String X = "3ee8-2001-fb1-148-7898-84d7-14ac-a931-997a.ap.ngrok.io";
String apiKey = "";

class ApiProvider with ChangeNotifier {
  late String _dataEvent;
  String get dataEvent => _dataEvent;
  void setuserEventData(String newData) {
    _dataEvent = newData;
    notifyListeners();
  }

  late String _dataReview;
  String get dataReview => _dataReview;
  void setUserReview(String newData) {
    _dataUser = newData;
    notifyListeners();
  }

  late String _dataUser;
  String get dataUser => _dataUser;
  void setUserData(String newData) {
    _dataUser = newData;
    notifyListeners();
  }

  Future<void> postuserEvent(Map<String, dynamic> body) async {
    var url = Uri.https(X, '/take2');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json', "apikey": apiKey},
      );
      if (response.statusCode == 201) {
        print(response.body);
        setuserEventData(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postuserReview(Map<String, dynamic> body) async {
    var url = Uri.https(X, '/review');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        print(response.body);
        setUserReview(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postuserData(Map<String, dynamic> body) async {
    var url = Uri.https(X, '/take');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        print(response.body);
        setUserData(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> _dataRec = [];
  List<dynamic> get dataRec => _dataRec;
  Future<void> fetchDataRec(Map<String, dynamic> queryParams) async {
    try {
      var url = Uri.https(X, '/recommend', queryParams);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData["data"]);
        _dataRec = jsonData["data"];
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> _dataPop = [];
  List<dynamic> get dataPop => _dataPop;
  Future<void> fetchDataPop() async {
    try {
      var url = Uri.https(X, '/recommend_populations');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _dataPop = jsonData["data"];
        print(jsonData["data"]);
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> _dataNear = [];
  List<dynamic> get dataNear => _dataNear;
  Future<void> fetchDataNear() async {
    Position position = await Geolocator.getCurrentPosition();
    final lat_user = position.latitude;
    final long_user = position.longitude;
    final latlong_user = {
      'latitude': '${lat_user}',
      'longitude': '${long_user}'
    };
    try {
      var url = Uri.https(X, '/recomnear', latlong_user);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _dataNear = jsonData;
        print(jsonData);
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

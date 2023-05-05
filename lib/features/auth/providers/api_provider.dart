import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    var url = Uri.https(GlobalVariable.urlRec, '/take2');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
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
    var url = Uri.https(GlobalVariable.urlRec, '/review');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
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
    var url = Uri.https(GlobalVariable.urlRec, '/take');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
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
  Future<void> fetchDataRec(Map<String, dynamic> body) async {
    try {
      var url = Uri.https(GlobalVariable.urlRec, '/recommend_test');
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData["data"]);
        _dataRec = jsonData["data"];
        print(_dataRec.length);
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
      var url = Uri.https(GlobalVariable.urlRec, '/recommend_populations');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
      );
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
      var url = Uri.https(GlobalVariable.urlRec, '/recomnear', latlong_user);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'Lp0sJNLUiREPno2Rtv2GMFNukpdtDxsC'
        },
      );
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

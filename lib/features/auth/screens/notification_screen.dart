import 'dart:convert';
import 'dart:io';

import 'package:cafein_nodejs/common/widgets/category_header.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  final String email; 
  NotificationScreen({required this.email});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> _dataNotification = [];
  List<dynamic> get dataNotification => _dataNotification;
  List<dynamic> result = [];
  List<dynamic> _foundData = [];
  Future<void> fetchDataNotification() async {
    try {
      final url = Uri.parse('${GlobalVariable.url}/api/notification');
      http.Response res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.statusCode);
        final jsonData = jsonDecode(res.body);
        _dataNotification = jsonData;
        result = dataNotification
            .where((user) =>
                user["own_email"].toString().contains(widget.email))
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
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTIFICATION"),
        toolbarHeight: 100,
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: fetchDataNotification(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _foundData.length,
                      itemBuilder: (context, index) {
                        var data = _foundData[index];
                        return Card(
                          elevation: 0,
                          color: GlobalVariable.containerColor,
                          margin: EdgeInsets.all(15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["email"].toString().toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      " Like ".toString().toUpperCase(),
                                      style: TextStyle(
                                          color: GlobalVariable.secondaryColor),
                                    ),
                                    Container(
                                      width: 150,
                                      child: Text(
                                        data["title"].toString().toUpperCase(),
                                        style: TextStyle(color: Colors.white),
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

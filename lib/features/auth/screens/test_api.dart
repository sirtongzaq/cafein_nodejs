import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/api_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TestAPI extends StatefulWidget {
  const TestAPI({super.key});

  @override
  State<TestAPI> createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<MongodbProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("TEST API"),
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: FutureBuilder(
        // recommend
        future: apiProvider.fetchDataStore(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              // recommend
              itemCount: apiProvider.dataStore.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final data_info = apiProvider.dataStore[index];
                final name = data_info['string_name'];
                final rating = data_info['rating'];
                final address = data_info['address'];
                final review = data_info['count_rating'];
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
                          color: GlobalVariable.containerColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              // title store
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                name.toString().toUpperCase(),
                                style: TextStyle(
                                  color: GlobalVariable.secondaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              // address store
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                address,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              // distance store
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "REVIEW ",
                                    style: TextStyle(
                                      color: GlobalVariable.secondaryColor,
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    child: Text(
                                      "${review}",
                                      style: TextStyle(
                                        color:
                                            Colors.white,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}

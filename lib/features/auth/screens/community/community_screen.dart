import 'package:cafein_nodejs/common/widgets/category_community.dart';
import 'package:cafein_nodejs/common/widgets/category_header.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/screens/community/communitypost_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/community/communitytype_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
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
        toolbarHeight: 100,
        title: Text("COMMUNITY"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const CommunityPostScreen()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            CustomHeader(text: "CATEGORY"),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  CustomCategoryCommunity(
                    name: "knowledge".toUpperCase(),
                    onTap: (() {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                CommunityTypeScreen(type: "knowledge")),
                      );
                    }),
                    icon: Icons.light,
                  ),
                  CustomCategoryCommunity(
                    name: "coffee beans".toUpperCase(),
                    onTap: (() {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                CommunityTypeScreen(type: "coffee beans")),
                      );
                    }),
                    icon: Icons.coffee,
                  ),
                  CustomCategoryCommunity(
                    name: "drink recipes".toUpperCase(),
                    onTap: (() {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                CommunityTypeScreen(type: "drink recipes")),
                      );
                    }),
                    icon: Icons.coffee_maker,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomHeader(text: "LATEST POST"),
            SizedBox(height: 10),
            StreamBuilder<Object>(
                stream: duration(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                      future: apiProvider.fetchDataCommunity(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: apiProvider.dataCommunity.length,
                            itemBuilder: (context, index) {
                              var data = apiProvider.dataCommunity[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            title.toString().toUpperCase(),
                                            style:
                                                TextStyle(color: Colors.grey),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            email.toString().toUpperCase(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "TYPE",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            type.toString().toUpperCase(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "DATE",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            date,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: Icon(
                                              Icons.favorite,
                                              color: (data["likes"]
                                                      .contains(user.uid))
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
                      });
                }),
          ],
        ),
      ),
    );
  }
}

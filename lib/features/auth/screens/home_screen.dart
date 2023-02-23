import 'dart:async';

import 'package:cafein_nodejs/common/widgets/category.dart';
import 'package:cafein_nodejs/common/widgets/category_header.dart';
import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:cafein_nodejs/features/auth/providers/api_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/mongodb_provider.dart';
import 'package:cafein_nodejs/features/auth/providers/user_provider.dart';
import 'package:cafein_nodejs/features/auth/screens/category/bakery.dart';
import 'package:cafein_nodejs/features/auth/screens/category/coffee.dart';
import 'package:cafein_nodejs/features/auth/screens/category/hybridbar.dart';
import 'package:cafein_nodejs/features/auth/screens/category/slowbar.dart';
import 'package:cafein_nodejs/features/auth/screens/category/speedbar.dart';
import 'package:cafein_nodejs/features/auth/screens/profile_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/search_screen.dart';
import 'package:cafein_nodejs/features/auth/screens/favorite_screen.dart';
import 'package:cafein_nodejs/features/auth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void signOutUser(BuildContext context) {
  AuthService().signOut(context);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late StreamSubscription<Position> streamSubscription;
  var latitude = '';
  var longitude = '';
  var address = '';

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address =
        'Address : ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LocationData? currentLocation;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude = 'Latitude : ${position.latitude}';
      longitude = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    duration() async* {
      while (true) {
        await Future.delayed(Duration(milliseconds: 1000));
        yield "";
      }
    }

    final user = Provider.of<UserProvider>(context).user;
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final apiProviderDB = Provider.of<MongodbProvider>(context, listen: false);
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      backgroundColor: GlobalVariable.backgroundColor,
      drawer: Drawer(
        //drawer
        child: Column(
          children: [
            Material(
              color: GlobalVariable.backgroundColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Container(
                    width: 500,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage(user.image),
                          backgroundColor: GlobalVariable.containerColor,
                        ),
                        Text(
                          user.username.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          user.email.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                color: GlobalVariable.backgroundColor,
                height: 563,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Home".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Search".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const SearchScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Favorite".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const TestAPI()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Notification".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Logout".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        signOutUser(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          AppBar(
            title: GlobalVariable.imgLogo,
            elevation: 0,
            toolbarHeight: 120,
            centerTitle: true,
            backgroundColor: GlobalVariable.backgroundColor,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    // tab hearder
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: GlobalVariable.secondaryColor,
                        isScrollable: false,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        labelColor: GlobalVariable.secondaryColor,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(
                            text: "RECOMMEND",
                          ),
                          Tab(
                            text: "POPULAR",
                          ),
                          Tab(
                            text: "NEARBY",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // tab body
                    width: double.maxFinite,
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FutureBuilder(
                          // recommend
                          future: apiProvider.fetchDataRec({
                            'name': user.uid,
                          }),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                // recommend
                                itemCount: apiProvider.dataRec.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final data_info = apiProvider.dataRec[index];
                                  final name = data_info['store'];
                                  final rating = data_info['rating'];
                                  final address = data_info['address\t'];
                                  final review = data_info['count_rating']
                                      .toStringAsFixed(0);
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
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                // title store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  name.toString().toUpperCase(),
                                                  style: TextStyle(
                                                    color: GlobalVariable
                                                        .secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // address store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Card(
                                                  elevation: 0,
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                      color: GlobalVariable
                                                          .greybackgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // distance store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "REVIEW ",
                                                      style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 120,
                                                      child: Text(
                                                        "${review}",
                                                        style: TextStyle(
                                                          color: GlobalVariable
                                                              .greybackgroundColor,
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
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: RatingBarIndicator(
                                                  rating: rating,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      GlobalVariable.ratingImg,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 0),
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
                        FutureBuilder(
                          // popular
                          future: apiProvider.fetchDataPop(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                // popular
                                itemCount: apiProvider.dataPop.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  var data = apiProvider.dataPop[i];
                                  var name = data["Store_name"];
                                  var address = data["addr"];
                                  var rating = data["rating"];
                                  var cont_rating =
                                      data["count_rating"].toStringAsFixed(0);
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
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                // title store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  name.toString().toUpperCase(),
                                                  style: TextStyle(
                                                    color: GlobalVariable
                                                        .secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // address store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Card(
                                                  elevation: 0,
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                      color: GlobalVariable
                                                          .greybackgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // distance store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "REVIEW ",
                                                      style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      cont_rating,
                                                      style: TextStyle(
                                                        color: GlobalVariable
                                                            .greybackgroundColor,
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
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: RatingBarIndicator(
                                                  rating: rating,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      GlobalVariable.ratingImg,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 0),
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
                        FutureBuilder(
                          // nearby
                          future: apiProvider.fetchDataNear(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                // nearby
                                itemCount: apiProvider.dataNear.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final latlong_info =
                                      apiProvider.dataNear[index];
                                  final name = latlong_info['store'];
                                  final distance = latlong_info['distance']
                                      .toStringAsFixed(2);
                                  final rating = latlong_info['rating'];
                                  final address = latlong_info['address\t'];
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
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                // title store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  name.toString().toUpperCase(),
                                                  style: TextStyle(
                                                    color: GlobalVariable
                                                        .secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // address store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Card(
                                                  elevation: 0,
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                      color: GlobalVariable
                                                          .greybackgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                // distance store
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "DISTANCE ",
                                                      style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${distance} Km",
                                                      style: TextStyle(
                                                        color: GlobalVariable
                                                            .greybackgroundColor,
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
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: RatingBarIndicator(
                                                  rating: rating,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      GlobalVariable.ratingImg,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 0),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomHeader(text: "CATEGORY"),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CustomCategory(
                          name: "SLOWBAR",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SlowbarScreen()),
                            );
                          }),
                          imgPath: "assets/slowbar.png",
                        ),
                        CustomCategory(
                          name: "SPEEDBAR",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SpeedbarScreen()),
                            );
                          }),
                          imgPath: "assets/speedbar.png",
                        ),
                        CustomCategory(
                          name: "HYBRIDBAR",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const HybridbarScreen()),
                            );
                          }),
                          imgPath: "assets/hybridbar.png",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CustomCategory(
                          name: "COFFEE",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const CoffeeScreen()),
                            );
                          }),
                          imgPath: "assets/coffee.png",
                        ),
                        CustomCategory(
                          name: "BAKERY",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const BakeryScreen()),
                            );
                          }),
                          imgPath: "assets/bakery.png",
                        ),
                        CustomCategory(
                          name: "COMMUNITY",
                          onTap: (() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }),
                          imgPath: "assets/community.png",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomHeader(text: "LATEST REVIEW"),
                  StreamBuilder<Object>(
                      stream: duration(),
                      builder: (context, snapshot) {
                        return FutureBuilder(
                            future: apiProviderDB.fetchDataReviewStore(),
                            builder: (context, snapshot) {
                              return Container(
                                height: 500,
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        apiProviderDB.dataReivewStore.length,
                                    itemBuilder: (context, index) {
                                      var data =
                                          apiProviderDB.dataReivewStore[index];
                                      var storename = data["storename"];
                                      var email = data["email"];
                                      var message = data["message"];
                                      var image = data["image"];
                                      var date = data["date"];
                                      var rt = data["rating"];
                                      int count_like = data["likes"].length;
                                      return Card(
                                        // detail review
                                        elevation: 0,
                                        color: GlobalVariable.containerColor,
                                        margin: EdgeInsets.all(15),

                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(image,
                                                    fit: BoxFit.cover,
                                                    width: 342,
                                                    height: 230),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "STORE",
                                                    style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    storename
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "EMAIL",
                                                    style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    email
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 340,
                                                height: 130,
                                                child: Text(
                                                  message,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "DATE",
                                                    style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    date,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "RATING",
                                                    style: TextStyle(
                                                        color: GlobalVariable
                                                            .secondaryColor),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  RatingBarIndicator(
                                                    rating: double.parse(rt),
                                                    itemBuilder: (context,
                                                            index) =>
                                                        GlobalVariable
                                                            .ratingImg,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0),
                                                    direction: Axis.horizontal,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: (data["likes"]
                                                              .contains(
                                                                  user.uid))
                                                          ? GlobalVariable
                                                              .secondaryColor
                                                          : Colors.white,
                                                    ),
                                                    onTap: () {
                                                      apiProviderDB
                                                          .likeReviewStore({
                                                        "review_id":
                                                            data["_id"],
                                                        "uid": user.uid
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    count_like.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            });
                      }),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class MapStore extends StatefulWidget {
  final String storename;
  MapStore({required this.storename});

  @override
  _MapStoreState createState() => _MapStoreState();
}

class _MapStoreState extends State<MapStore> {
  List<dynamic> _dataStore = [];
  List<dynamic> get dataStore => _dataStore;
  List<dynamic> result = [];
  List<dynamic> _foundData = [];
  Completer<GoogleMapController> _controller = Completer();
  double _latitude = 0.0;
  double _longitude = 0.0;
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        setState(() {});
      },
    );
  }

  void getPolyPoints() async {
    var currentPosition = await Geolocator.getCurrentPosition();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalVariable.googleAPiKey,
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(_latitude, _longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

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
            .where((user) =>
                user["string_name"].toString().contains(widget.storename))
            .toList();
        setState(() {
          _foundData = result;
          _latitude = result[0]["map"][0];
          _longitude = result[0]["map"][1];
        });
      } else {
        print("Conection fail");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    fetchDataStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("${widget.storename} Map"),
        backgroundColor: GlobalVariable.backgroundColor,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.deepPurpleAccent,
            width: 5,
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            icon: currentLocationIcon,
            position:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
          Marker(
            markerId: MarkerId("destination"),
            icon: destinationIcon,
            position: LatLng(_latitude, _longitude),
          ),
        },
      ),
    );
  }
}

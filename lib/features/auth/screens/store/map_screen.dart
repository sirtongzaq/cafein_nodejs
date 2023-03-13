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
import 'package:geolocator/geolocator.dart';

class MapStore extends StatefulWidget {
  final String storename;
  final double latitude;
  final double longitude;
  MapStore(
      {required this.storename,
      required this.latitude,
      required this.longitude});

  @override
  _MapStoreState createState() => _MapStoreState();
}

class _MapStoreState extends State<MapStore> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  void setMakerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pin_me.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

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
      PointLatLng(widget.latitude, widget.longitude),
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

  @override
  void initState() {
    getCurrentLocation();
    setMakerIcon();
    getPolyPoints();
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("${widget.storename} Map"),
        backgroundColor: Colors.black,
      ),
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.black,
                  width: 5,
                ),
              },
              markers: {
                Marker(
                  markerId: MarkerId("currentLocation"),
                  icon: currentLocationIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  icon: destinationIcon,
                  position: LatLng(widget.latitude, widget.longitude),
                ),
              },
            ),
    );
  }
}

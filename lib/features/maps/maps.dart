/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_flutter/features/Home/maps_function.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

class MapSampleState extends State<MapSample> {
  static late Position currentLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.74008263112021
, 32.60118436629702
),
    zoom: 13.4746,
  );

  Future getLocation() async {
    //get user current position
    currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  @override
  void initState() {
            MapFunction.getPermission(context);
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          setState(
            () {
              _controller.complete(controller);
            },
          );
        },
      ),
    );
  }
}
*/

import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';

class MapFunction {
  //To get Location Permission and requested it if Permission denied
  static Future getPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    //to check if the location is enable or not
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    //if the location is not active show that
    if (serviceEnabled == false) {
      Login.showSnackBar(context, "Location services are disabled.");
      permission = await Geolocator.requestPermission();
    }
    //if it is enable check the permission
    permission = await Geolocator.checkPermission();

    //if it is denied request Permission and show what ever you want her
    if (permission == LocationPermission.denied) {
      Login.showSnackBar(context, "Location permissions are denied");
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Login.showSnackBar(context, "Location permissions are denied");
      permission = await Geolocator.requestPermission();
    }
  }
}


double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const p = 0.017453292519943295; // Math.PI / 180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

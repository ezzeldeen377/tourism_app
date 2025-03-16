import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/get_data.dart';
import 'package:new_flutter/features/Home/maps_function.dart';

class SearchMaps extends StatefulWidget {
  const SearchMaps({Key? key}) : super(key: key);

  @override
  State<SearchMaps> createState() => _SearchMapsState();
}

final TextEditingController _numberController =
    TextEditingController(text: "3");
int number = 3;

Set<Marker> markers = {};
Marker? previousMarker;

Polyline? previousPolyline;
Set<Polyline> polylines = {};

Completer<GoogleMapController> mapscontroller = Completer();
Position? currentLocation;
var distances = <QueryDocumentSnapshot, double>{};
late LatLng distanationPlace;

class _SearchMapsState extends State<SearchMaps> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
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
    final GoogleMapController controller = await mapscontroller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  Future<LatLng?> findShortestRoute(
    double userLat,
    double userLng,
    String place,
  ) async {
    final places = FirebaseFirestore.instance.collection('places');

    // Query all blood banks
    final snapshot = await places.get();

    // Calculate the distance between the user's location and each blood bank's location
    for (final doc in snapshot.docs) {
      final palceLat = doc['latitude'] as double?;
      final palceLng = doc['longitude'] as double?;
      if (palceLat == null || palceLng == null) {
        continue; // Skip blood banks with missing location data
      }

      final distance = calculateDistance(userLat, userLng, palceLat, palceLng);
      distances[doc] = distance;
      distanationPlace = LatLng(palceLat, palceLng);
    }
    final newMarker = Marker(
      markerId: const MarkerId('YourDistanation'),
      position: distanationPlace,
      infoWindow: InfoWindow(title: userName),
    );
    setState(() {
      markers.add(newMarker);
      previousMarker = newMarker;
    });

    // Add polyline to the nearest blood bank
    final polylineCoordinates = [LatLng(userLat, userLng), distanationPlace];
    final polyline = Polyline(
      polylineId: const PolylineId('places'),
      points: polylineCoordinates,
      color: kMainColor,
      width: 6,
    );
    setState(() {
      polylines.add(polyline);
      previousPolyline = polyline;
    });

    try {
      User user = FirebaseAuth.instance.currentUser!;
      //add user details
      Future addUserRequest() async {
        await FirebaseFirestore.instance.collection('places').add(
          {
            //'requiredBloodType': MapsDropDown.selectedValue,
            'amountofBlood': int.parse(_numberController.text),
            'From': userName,
            'userID': user.uid,
            'userName': userName,
          },
        );
      }

      await addUserRequest();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String? errorType;
      switch (e.message) {
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = "Network error. Check your internet connection";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorType = "Server error, please try again later.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorType = "Too many requests in this account.";
          break;
        case 'Given String is empty or null':
          errorType = "Please fill fields ";
          break;
        default:
          errorType = "${e.message}. Please try again.";
      }
      if (mounted) {
        Login.showSnackBar(context, errorType);
      }
    }
    return distanationPlace;
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
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kMainColor
                  ),
                )
              : SizedBox(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        mapscontroller.complete(controller);
                      });
                    },
                  ),
                ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.fromLTRB(0, 0, 15, 35),
            child: FloatingActionButton(
              backgroundColor: kMainColor,
              onPressed: _goToMyLocation,
              child: const Icon(
                IconlyLight.location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

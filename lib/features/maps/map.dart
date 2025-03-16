import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class TransportationMap extends StatefulWidget {
  const TransportationMap({Key? key, required this.transport}) : super(key: key);

  final String transport;

  @override
  _TransportationMapState createState() => _TransportationMapState();
}

class _TransportationMapState extends State<TransportationMap> {
  late GoogleMapController mapController;
  List<Marker> allMarkers = [];
  LatLng? userLocation;
  LatLng? nearestStation;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    determineUserLocation();
  }

  Future<void> determineUserLocation() async {
    // Determine the user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
    fetchMetroStations();
  }

  Future<void> fetchMetroStations() async {
    // Fetch all metro stations from the Google Places API
    if (userLocation == null) return;

    String apiKey = 'AIzaSyA_0nbY9TWX-TxtJOyUxTTQFbkz7Ef1uak';
    String endpoint =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userLocation!.latitude},${userLocation!.longitude}&radius=50000&type=${widget.transport}&key=$apiKey';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic>? results = data['results'];

      if (results != null && results.isNotEmpty) {
        setState(() {
          allMarkers = results!.map((result) {
            Map<String, dynamic> location = result['geometry']['location'];
            LatLng latLng = LatLng(location['lat'], location['lng']);
            return Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              infoWindow: InfoWindow(title: result['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            );
          }).toList();

          // Find nearest station
          nearestStation = findNearestStation();
        });
      } else {
        throw Exception('No stations found');
      }
    } else {
      throw Exception('Failed to fetch stations');
    }
  }

  LatLng? findNearestStation() {
    // Find the nearest metro station to the user's location
    if (userLocation == null) return null;

    double minDistance = double.infinity;
    LatLng? nearestStation;

    for (Marker marker in allMarkers) {
      double distance = Geolocator.distanceBetween(
        userLocation!.latitude,
        userLocation!.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearestStation = marker.position;
      }
    }

    return nearestStation;
  }

  Future<void> fetchDirections(LatLng destination) async {
    // Fetch directions from the user's location to the nearest metro station
    String apiKey = 'AIzaSyA_0nbY9TWX-TxtJOyUxTTQFbkz7Ef1uak';
    String endpoint =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation!.latitude},${userLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic>? routes = data['routes'];

      if (routes != null && routes.isNotEmpty) {
        setState(() {
          // Decode polyline points
          String points = routes![0]['overview_polyline']['points'];
          polylineCoordinates = _decodePoly(points);
        });
      } else {
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> _decodePoly(String encoded) {
    // Decode polyline points
    List<LatLng> points = [];
    for (var point in decodeEncodedPolyline(encoded)) {
      points.add(LatLng(point[0], point[1]));
    }
    return points;
  }

  List<List<double>> decodeEncodedPolyline(String encoded) {
    // Decode encoded polyline points
    List<List<double>> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add([lat / 1E5, lng / 1E5]);
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.transport} map')),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 13.4,
              ),
              markers: Set<Marker>.of(allMarkers),
              polylines: <Polyline>{
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.red,
                  points: polylineCoordinates,
                  width: 5,
                ),
              },
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (nearestStation != null) {
            fetchDirections(nearestStation!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not find nearest station')),
            );
          }
        },
        child: const Icon(Icons.near_me),
      ),
    );
  }
}



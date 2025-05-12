// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/core/widgets/custom_drawer.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Componants/image_stack.dart';
import 'package:new_flutter/features/Data/hotels/booking_screen.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/maps/testmap.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class viewdata extends StatefulWidget {
  const viewdata({
    super.key,
    required this.hotelsName,
    required this.hotelsDescription,
    required this.imag,
    required this.hotelsPrice, required this.lat, required this.lng, required this.data,
  });
  final String hotelsName;
  final List<dynamic> imag;
  final String hotelsDescription;
  final String hotelsPrice;
  final double lat;
  final double lng;
  final Map<String, dynamic> data;
  @override
  State<viewdata> createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<viewdata> {
  final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> id = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              color: kMainColor,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              "Egypt.io",
              style: TextStyle(
                color: kMainColor1,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: kMainColor),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          // Image stack with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageStack(imgList: widget.imag),
          ),
          const SizedBox(height: 24),
          // Main content card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel name with icon
                  Row(
                    children: [
                      const Icon(Icons.hotel, color: kMainColor, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.hotelsName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Price tag with better styling
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: kMainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kMainColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, color: kMainColor, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "${widget.hotelsPrice} EGP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kMainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // Description section with heading
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.hotelsDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Actions section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hotel Options",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Location button with icon
                  ActionButton(
                    width: double.infinity,
                    color: kMainColor.withOpacity(0.8),
                    text: "Get Location",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailPage(
                            placesName: widget.hotelsName,
                            placeLat: widget.lat,
                            placeLng: widget.lng,
                          ),
                        ),
                      );
                    },
                    isBold: true,
                    isGradient: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Book Now button
                  ActionButton(
                    width: double.infinity,
                    color: Colors.green,
                    text: "Book Now",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(
                            reservationData: widget.data,
                          ),
                        ),
                      );
                    },
                    isBold: true,
                    isGradient: true,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

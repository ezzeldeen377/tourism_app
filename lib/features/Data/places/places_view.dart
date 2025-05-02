// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/core/widgets/custom_drawer.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Componants/example_screen_1.dart';
import 'package:new_flutter/features/Componants/image_stack.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/maps/testmap.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class viewplaces extends StatefulWidget {
  const viewplaces({
    super.key,
    required this.placesName,
    required this.placesDescription,
    required this.images,
    required this.placesPrice,
    required this.lat,
    required this.lng,
    this.fullImage,
  });
  final String placesName;
  final List<dynamic> images;
  final double lat;
  final double lng;
  final String placesDescription;
  final String placesPrice;
  final String? fullImage;

  @override
  State<viewplaces> createState() => _viewplacesState();
}

class _viewplacesState extends State<viewplaces> {
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
            Icon(Icons.explore, color: kMainColor, size: 28),
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
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          ImageStack(imgList: widget.images),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.placesName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kMainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${widget.placesPrice} EGP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kMainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.placesDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ActionButton(
                  width: double.infinity,
                  color: kMainColor,
                  text: "Get Location",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailPage(
                          placesName: widget.placesName,
                          placeLat: widget.lat,
                          placeLng: widget.lng,
                        ),
                      ),
                    );
                  },
                  isBold: true,
                  isGradient: true,
                ),
                if (widget.fullImage != null) ...[
                  const SizedBox(height: 16),
                  ActionButton(
                    width: double.infinity,
                    color: kMainColor.withOpacity(0.9),
                    text: "View Full Image",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullView(
                            title: widget.placesName,
                            url: widget.fullImage ?? "",
                          ),
                        ),
                      );
                    },
                    isBold: true,
                    isGradient: true,
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, int index, VoidCallback onTap) {
    return ListTile(
      leading:
          Icon(icon, color: _selectedIndex == index ? kMainColor : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? kMainColor : Colors.black87,
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: onTap,
    );
  }
}

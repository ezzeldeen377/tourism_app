// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/maps/testmap.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class viewplaces extends StatefulWidget {
  const viewplaces({
    super.key,
    required this.placesName,
    required this.placesDescription,
    required this.imag,
    required this.placesPrice,
    required this.lat,
    required this.lng,
  });
  final String placesName;
  final String imag;
  final double lat;
  final double lng;
  final String placesDescription;
  final String placesPrice;

  @override
  State<viewplaces> createState() => _viewplacesState();
}

class _viewplacesState extends State<viewplaces> {
  final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> id = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: 200,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kMainColor,
              ),
              child: UserAccountsDrawerHeader(
                  accountName: Text("Name"), accountEmail: Text("Mina helal")),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const StartApp()),
                    (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              title: const Text('ProfilePage'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text('About us'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Aboutus()));
              },
            ),
            ListTile(
              title: const Text('Log out'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              color: kMainColor,
            ),
            Text(
              "Egypt.io",
              style: TextStyle(color: kMainColor1),
            ),
          ],
        ),
        iconTheme: const IconThemeData(),
        backgroundColor: Colors.grey[200],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.imag,
                  width: 400,
                  height: 200, 
                  fit: BoxFit.cover
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              widget.placesName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(widget.placesDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 15),
          Center(
            child: Text(widget.placesPrice.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: kMainColor)),
          ),
          //location
          Container(
            padding: const EdgeInsets.all(50),
            child: ActionButton(
              width: 20,
              color: Colors.black,
              text: "Get Location",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlaceDetailPage(
                            placesName: widget.placesName,
                            placeLat: widget.lat,
                            placeLng: widget.lng)));
              },
              isBold: true,
              isGradient: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/places/places_view.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class packageview1 extends StatefulWidget {
  const packageview1({super.key, required this.id});
  final String id;

  @override
  State<packageview1> createState() => _packageview1State();
}

class _packageview1State extends State<packageview1> {
  final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> finaldata = [];

  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("hotels").get().then(
      (value) {
        for (var element in value.docs) {
          if (element['package_id'].toString() == widget.id) {
            finaldata.add(element);
          }
        }
        return value;
      },
    );

    await Future.delayed(const Duration(seconds: 1));

    data.addAll(querySnapshot.docs);

    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kMainColor,
                ),
                child: UserAccountsDrawerHeader(
                    accountName: Text("Name"),
                    accountEmail: Text("Mina helal")),
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
        body: isloading == true
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(color: kMainColor),
                  ),
                  Text("Loading...."),
                ],
              )
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Hotels",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      itemCount: finaldata.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160,
                      ),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              {
                                return viewplaces(
                                    placesName: finaldata[i]['hotel_name'],
                                    placesDescription: finaldata[i]
                                        ['hotel_description'],
                                    imag: finaldata[i]['img'],
                                    lat: finaldata[i]['latitude'],
                                    lng: finaldata[i]['longitude'],
                                    placesPrice: finaldata[i]['hotel_price']);
                              }
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    "${finaldata[i]['img']}",
                                    width: 400,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "${finaldata[i]['hotel_name']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/packages/Places_view_pac.dart';
import 'package:new_flutter/features/Data/places/places_view.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class packageview extends StatefulWidget {
  const packageview({super.key, required this.id});
  final String id;

  @override
  State<packageview> createState() => _packageviewState();
}

class _packageviewState extends State<packageview> {
  final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> finaldata = [];
  bool isloading = true;
  int index = 0;

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("places").get().then(
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
    setState(() {print (data[0].data());});
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
          width: 200,
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
        appBar: AppBar(
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
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.place_sharp)),
              Tab(icon: Icon(Icons.hotel_class_sharp))
            ],
          ),
        ),
        body: Scaffold(
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
                : index == 0
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Places",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      {
                                        return viewplaces(
                                          placesName: finaldata[i]
                                              ['places_name'],
                                          placesDescription: finaldata[i]
                                              ['places_description'],
                                          imag: finaldata[i]['img'],
                                          placesPrice: finaldata[i]
                                              ['places_price'],
                                          lat: finaldata[i]['latitude'],
                                          lng: finaldata[i]['longitude'],
                                        );
                                      }
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "${finaldata[i]['places_name']}",
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
                      )
                    : packageview1(id: widget.id)),
      ),
    );
  }
}

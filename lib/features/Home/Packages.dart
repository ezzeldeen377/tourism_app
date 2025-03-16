// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/Home/details.dart';
import 'package:new_flutter/features/Home/home1.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

import '../../core/widgets/contants.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  final int _selectedIndex = 0;

  final List items = const [
    {
      "image": 'images/TOURISM.jpg',
      "Title": "TOURISM",
      "subtitle":
          " Discover the wonders of Egypt from the Pyramids of Giza to the vibrant bazaars of Cairo and the stunning beaches of the Red Sea. Indulge in luxury with stays in five-star hotels and a scenic Nile cruise.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/CULTURE.jpg',
      "Title": "CULTURE",
      "subtitle":
          "Dive deep into local culture with our immersive cultural package. Experience authentic traditions, historic landmarks, and vibrant community life. Stay in culturally rich hotels and enjoy smooth, thoughtful transportation throughout your journey.",
      "price": "Starting 10 EGP / Ticket",
    },
    {
      "image": 'images/PHOTOSHOOT.jpg',
      "Title": "PHOTOSHOOT",
      "subtitle":
          "APicture Perfect: Exclusive Photoshoot Experience Capture stunning memories with our exclusive photoshoot package, designed for photography enthusiasts and professionals alike. Explore breathtaking landscapes and iconic urban settings all while enjoying luxurious accommodations and convenient transportation.n airline based in Cairo, primarily serving as a subsidiary of EgyptAir, operating flights between Cairo and Tel Aviv, Israel.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/MEDITATION.jpg',
      "Title": "MEDITATION",
      "subtitle":
          "Embrace inner peace with our curated meditation retreat, set in serene locations across the country. Find balance with accommodations that promote relaxation, visits to tranquil places, and thoughtful transportation options.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/HONYMOON.jpg',
      "Title": "HONYMOON",
      "subtitle":
          "Romantic Rendezvous: Ultimate Honeymoon Escape Celebrate your love in the worlds most romantic destinations with our bespoke honeymoon package. Enjoy luxurious accommodations, intimate experiences, and seamless transportation for an unforgettable start to your new life together.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/FOODREVIEW.jpg',
      "Title": "FOODREVIEW",
      "subtitle":
          "Taste the world on our gourmet getaway, designed for food lovers who crave culinary adventures. Experience diverse flavors, exclusive cooking classes, and intimate dining experiences while enjoying comfortable accommodations and smooth transportation.",
      "price": "Starting 5 EGP / Ticket",
    },
  ];

  @override
  void initState() {
    //getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      MaterialPageRoute(builder: (context) => const Home1()),
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
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Packages",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 650,
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                        padding: const EdgeInsets.all(0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            mainAxisSpacing: 5.0,
                            //crossAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int A) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          details(data: items[A])));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          items[A]['image'],
                                          fit: BoxFit.cover,
                                          height: 110,
                                          width: 200,
                                        ),
                                        Text(items[A]['Title'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                height: 1.50)),
                                        Text(items[A]['price'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

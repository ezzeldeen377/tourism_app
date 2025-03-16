// ignore_for_file: dead_code, prefer_const_constructors, camel_case_types
/*import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/Home/details.dart';
import 'package:new_flutter/features/Home/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class hotels extends StatefulWidget {
  const hotels({super.key});

  @override
  State<hotels> createState() => _hotelsState();
}

class _hotelsState extends State<hotels> {
  final int _selectedIndex = 0;

  final List items = const [
    {
      "image": 'images/Four Seasons Resort Sharm El Sheikh.jpg',
      "Title": "Four Seasons Resort Sharm El Sheikh",
      "subtitle":
          "Located on the shores of the Red Sea, this luxurious resort offers world-class amenities including private beach access, multiple swimming pools, and exceptional dining options.",
      "price": "Starting 4000 EGP/Ticket",
    },
    {
      "image": 'images/Hilton Cairo Zamalek Residences.jpg',
      "Title": "Hilton Cairo Zamalek Residences",
      "subtitle":
          "Located on the picturesque Zamalek Island in Cairo, this contemporary hotel offers stylish accommodations, excellent dining options, a rooftop pool with panoramic views, and easy access to the city's attractions.",
      "price": "Starting 10000 EGP/Ticket",
    },
    {
      "image": 'images/Hilton Luxor Resort & Spa.jpg',
      "Title": "Hilton Luxor Resort & Spa",
      "subtitle":
          "Nestled on the banks of the Nile River in Luxor, this upscale resort features elegant rooms and suites, a serene spa, multiple swimming pools, and picturesque views of the surrounding countryside.",
      "price": "Starting 600 EGP/Ticket",
    },
    {
      "image": 'images/Kempinski Hotel Soma Bay, Hurghada.jpg',
      "Title": "Kempinski Hotel Soma Bay, Hurghada",
      "subtitle":
          "Situated on a pristine beach in Soma Bay, this upscale resort offers elegant accommodations, an 18-hole golf course, multiple swimming pools, and a variety of water sports activities.",
      "price": "Starting 5500 EGP/Ticket",
    },
    {
      "image": 'images/Marriott Mena House, Cairo.jpg',
      "Title": "Marriott Mena House, Cairo",
      "subtitle":
          "Nestled in the shadow of the Great Pyramids of Giza, Mena House is a luxurious hotel with breathtaking views and lush gardens. It offers a blend of modern amenities and historic charm.",
      "price": "Starting 6000 EGP/Ticket",
    },
    {
      "image": 'images/Rixos Sharm El Sheikh.jpg',
      "Title": "Rixos Sharm El Sheikh",
      "subtitle":
          "With its own private beach overlooking the Red Sea, Rixos Sharm El Sheikh offers luxurious accommodations, a variety of dining options, a spa, and a range of activities including diving and snorkeling.",
      "price": "Starting 2000 EGP/Ticket",
    },
    {
      "image": 'images/Steigenberger Aqua Magic, Hurghada.jpg',
      "Title": "Steigenberger Aqua Magic, Hurghada",
      "subtitle":
          "Perfect for families and leisure travelers, this all-inclusive resort features spacious rooms, a water park with slides and pools, multiple restaurants, and a range of recreational activities.",
      "price": "Starting 12000 EGP/Ticket",
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
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text("Hotels",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 700,
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                        padding: const EdgeInsets.all(0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            mainAxisSpacing: 4.0,
                            //crossAxisSpacing: 2.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int v) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          details(data: items[v])));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          items[v]['image'],
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        ),
                                        Text(items[v]['Title'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                height: 1.0)),
                                        Text(items[v]['price'],
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
*/
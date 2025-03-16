// ignore_for_file: dead_code, prefer_const_constructors, camel_case_types
import 'package:flutter/material.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/Home/details.dart';
import 'package:new_flutter/features/Home/home1.dart';

import '../../core/widgets/contants.dart';
import '../Profile/profile_page.dart';

class Cars extends StatefulWidget {
  const Cars({super.key});

  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  final int _selectedIndex = 0;

  final List items = const [
    {
      "image": 'images/bus.jpg',
      "Title": "Bus",
      "subtitle":
          " Buses are considered one of the most popular means of transportation in Egypt. You can find them widely within the capital and Giza, and they also travel to a large number of governorates, such as; Alexandria, Port Said, Ismailia, Sharm El-Sheikh, and North and South Sinai. It is not the best way to travel within the capital and Giza, as; It becomes very crowded at most hours of the day, in addition to being slow due to the severe traffic congestion. However, it is one of the cheapest means of transportation in this country, as the ticket price does not exceed five pounds. Each bus is equipped with a sign bearing the names of the areas to which it is heading, along with its own number. You can ask the driver whether he is heading to your destination or not before boarding the bus, but if you want to get off, you can ask the driver to stop.",
      "price": "Starting 10 EGP / Ticket",
    },
    {
      "image": 'images/metro.jpg',
      "Title": "metro",
      "subtitle":
          "The metro is one of the most prominent means of transportation in Egypt, but unfortunately it is limited to Cairo and Giza only, and it is considered the ideal means of transportation in both of them. The first line that was built connected the Helwan and Marj regions, and since then the subway lines have expanded to include many areas of Cairo and Giza,It is considered an inexpensive way to travel, as ticket prices range from three to seven pounds, which is considered very cheap compared to its efficiency. Subway stations and cars become very crowded during peak hours, which is unbearable for many people, so if you intend to travel at this time, it is better to look for another way to go to your destination.",
      "price": "Starting 6 EGP / Ticket",
    },
    {
      "image": 'images/Microbuses.jpg',
      "Title": "Microbuses",
      "subtitle":
          "Small buses are one of the most prominent means of transportation in Egypt. You can find them widely in all governorates, in addition to their transportation between each of them, which facilitates the process of transportation in Egypt. Fare prices vary depending on the destination the bus is heading to. You can find it within certain stations, or you can stop at one of them on the way. Before you get on the bus, make sure to ask the driver whether he is heading to the place you are going or not. The fare is paid on board without tickets. Just give the money to the person next to you and it will be exchanged between the passengers until it reaches the driver.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/taxi.jpg',
      "Title": " Taxi",
      "subtitle":
          "It is one of the means of transportation in Egypt that is preferred by many, due to the severe crowding that public transportation suffers from, in addition to the annoying traffic congestion. The taxi driver can take paths other than the routes specified for other means of transportation. Most cars are not equipped with fare meters, so expect to be scammed. Therefore, it is best to make sure that there is a working meter inside the car, in addition to agreeing with the driver on the fare price. It is considered an expensive means of transportation compared to other means of transportation, but it is definitely effective as it takes you to any destination you want, whether within or outside the city limits. There are no taxi stations. You can only stop one of them on the road. Do not forget to memorize the car number before boarding the car in case of any accident or annoying situation. You can get the driver's phone number; If you find him a suitable and trustworthy person. There are also Uber and Careem services, which provide: Move comfortably and efficiently away from the scams of most taxi drivers. The fare in both of them is calculated based on a specific system, which makes them much cheaper than regular taxis, which is why many locals and tourists now turn to them. All you have to do is download their local application from your mobile phone store.",
      "price": "Starting 20 EGP / Ticket",
    },
    {
      "image": 'images/train.jpg',
      "Title": "Train",
      "subtitle":
          "Trains are an enjoyable way to travel in Egypt, where; It allows you to learn about different aspects of the Egyptian countryside that you may not have the opportunity to visit. An inexpensive means of transportation, as the ticket price starts from two pounds and does not exceed fifty pounds. First class is the most convenient means of transportation within these means of transportation. The other levels seem inhuman and are not suitable for transportation. Trains move within the governorate's borders between its various regions, and also transport you from one governorate to another. Many locals prefer it while traveling due to its low prices and speed, as it takes you to your destination in a short time, away from traffic congestion.",
      "price": "Starting 40 EGP / Ticket",
    },
    {
      "image": 'images/Ferries.jpg',
      "Title": "Ferries",
      "subtitle":
          " One of the most enjoyable means of transportation in Egypt, but it is only available inside Cairo. It allows you to see the city’s waterfront in a stunning view. It is also considered a quick means of transportation. You can take the ferry if you are heading to one of the destinations located on the banks of the Nile River. Just be sure to ask if it transfers to your destination or not. In addition to its many advantages, it is classified as an inexpensive means of transportation, as the fare does not exceed five pounds.",
      "price": "Starting 20 EGP / Ticket",
    },
    {
      "image": 'images/Tuk Tuk.jpg',
      "Title": "Tuk Tuk",
      "subtitle":
          "It is one of the means of transportation in Egypt that was recently added to the transportation system. It is found in many governorates and is common throughout neighborhoods, cities, and small villages. Although it is an inexpensive means of transportation, it is considered unsafe and does not take you to popular destinations, only within the boundaries of small areas.",
      "price": "Starting 10 EGP / Ticket",
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
              onTap: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  Aboutus()));
              },
            ),
            ListTile(
              title: const Text('Log out'),
              selected: _selectedIndex == 2,
              onTap: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Login()));
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
              
                
                  Text("Transportation",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ,
              
              SizedBox(
                height: 720,
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
                            crossAxisSpacing: 10.0,
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
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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

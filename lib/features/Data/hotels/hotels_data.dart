import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/hotels/hotels_view.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class HotelsData extends StatefulWidget {
  const HotelsData({super.key});

  @override
  State<HotelsData> createState() => _HotelsDataState();
}

// ignore: camel_case_types
class _HotelsDataState extends State<HotelsData> {
  final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("hotels").get();
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 160,
                    ),
                    itemBuilder: (context, v) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => viewdata(
                                  hotelsName: data[v]['hotel_name'],
                                  hotelsDescription: data[v]
                                      ['hotel_description'],
                                  imag: data[v]['img'],
                                   lat:  data[v]['latitude'],
                                    lng:  data[v]['longitude'],
                                  hotelsPrice: data[v]['hotel_price'])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network("${data[v]['img']}",
                                    width: 400, height: 200, fit: BoxFit.cover),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "${data[v]['hotel_name']}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

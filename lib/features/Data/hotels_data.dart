import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/viewdata.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/Home/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';


class HotelsData extends StatefulWidget {
  const HotelsData({super.key});

  @override
  State<HotelsData> createState() => _HotelsDatasState();
}

// ignore: camel_case_types
class _HotelsDatasState extends State<HotelsData> {
    final int _selectedIndex = 0;

  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("places").get();
     await Future.delayed(const Duration(seconds: 3));

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainColor,
        onPressed: () {
          Navigator.of(context).pushNamed("places");
        },
        child: const Icon(Icons.add),
      ),
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
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, v) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>  viewdata()));

                    
                  } ,
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(
                            "${data[v]['img']}",
                            fit: BoxFit.cover,
                            height: 90,
                          ),
                          Container(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text("${data[v]['places_name']}",textAlign: TextAlign.center),
                              
                              ),
                               
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Corrected import

import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/auth/presentation/pages/login/widgets/login.dart'; // Corrected import
import 'package:new_flutter/features/data/packages/package_view.dart'; // Corrected import
import 'package:new_flutter/features/home/about.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/profile/profile_page.dart';

class Packages extends StatefulWidget {
  const Packages({Key? key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  final int _selectedIndex = 0;

  List<DocumentSnapshot> data = [];
  bool isLoading = true; // Corrected variable name

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Packages").get();
    data.addAll(querySnapshot.docs);
    isLoading = false; // Corrected variable name
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
                accountName: Text("Name"),
                accountEmail: Text("Mina helal"),
              ),
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
              selected: _selectedIndex == 3,
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
      body: isLoading
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
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Packages",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 160,
                    ),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => packageview(
                              id: data[i]['package_id'],
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  "${data[i]['img']}",
                                  width: 400,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      height: 270,
                                      color: Colors.grey,
                                      child: const Center(
                                        child: Icon(Icons.error,
                                            color: Colors.white),
                                      ),
                                    );
                                  },
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
                                  "${data[i]['package_name']}",
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
    );
  }
}

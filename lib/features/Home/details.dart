// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Data/ussr_data/get_data.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/maps/map.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class details extends StatefulWidget {
  final data;
  const details({super.key, this.data});

  @override
  State<details> createState() => _details();
}

class _details extends State<details> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
                  Icon(
                    Icons.explore,
                    color: kMainColor,
                  ),
              child: UserAccountsDrawerHeader(
                  accountName: const Text("Name"),
                  accountEmail: Text(userName)),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                widget.data["image"],
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.data["Title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            )),
            const SizedBox(height: 8),
            //location
            Container(
              padding: const EdgeInsets.all(50),
              child: ActionButton(
                width: 60,
                color: Colors.black,
                text: "Get Location",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchMaps()));
                },
                isBold: true,
                isGradient: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

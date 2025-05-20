import 'package:flutter/material.dart';
import 'package:new_flutter/features/Screens/Home.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Home/chat.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:new_flutter/features/object_detection/object_detection_screen.dart';

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  static int selectedPage = 0;

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  List<Widget> pages = [
    const CategoriesScreen(),
    const ChatScreen(),
    const ObjectDetectionScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[StartApp.selectedPage],
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 75,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButtomBar(
                  text: "Chat",
                  icon: Icons.chat,
                  selectedIcon: Icons.chat,
                  selected: StartApp.selectedPage == 1,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 1;
                    });
                  },
                ),
                IconButtomBar(
                  text: "Home",
                  icon: Icons.home,
                  selectedIcon: Icons.home,
                  selected: StartApp.selectedPage == 0,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 0;
                    });
                  },
                ),
                IconButtomBar(
                  text: "Detect",
                  icon: Icons.camera_alt,
                  selectedIcon: Icons.camera_alt,
                  selected: StartApp.selectedPage == 2,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 2;
                    });
                  },
                ),
                IconButtomBar(
                  text: "Profile",
                  icon: Icons.person,
                  selectedIcon: Icons.person,
                  selected: StartApp.selectedPage == 3,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

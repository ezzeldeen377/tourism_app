import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Home/chat.dart';
import 'package:new_flutter/features/Home/home1.dart';
import 'package:new_flutter/features/Profile/profile_page.dart';

class IconButtomBar extends StatelessWidget {
  const IconButtomBar(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      required this.selectedIcon});

  final String text;
  final IconData icon, selectedIcon;
  final bool selected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: selected
              ? Icon(
                  selectedIcon,
                  //color: const Color(0xffDE0A1E),
                  color: kMainColor,
                  size: 24,
                )
              : Icon(
                  icon,
                  size: 30,
                ),
        ),
        Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            fontSize: 11,
            height: 0.22,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? kMainColor : Colors.black,
          ),
        )
      ],
    );
  }
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  static int selectedPage = 0;

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  List<Widget> pages = [
    const Home1(),
    const chatbot(),
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
                    icon: IconlyLight.chat,
                    selectedIcon: IconlyBold.chat,
                    selected: StartApp.selectedPage == 1,
                    onPressed: () {
                      setState(() {
                        StartApp.selectedPage = 1;
                      });
                    }),
                IconButtomBar(
                  text: "Home",
                  icon: IconlyLight.home,
                  selectedIcon: IconlyBold.home,
                  selected: StartApp.selectedPage == 0,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 0;
                    });
                  },
                ),
                IconButtomBar(
                  text: "Profile",
                  icon: IconlyLight.profile,
                  selectedIcon: IconlyBold.profile,
                  selected: StartApp.selectedPage == 2,
                  onPressed: () {
                    setState(() {
                      StartApp.selectedPage = 2;
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

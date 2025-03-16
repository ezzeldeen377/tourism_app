// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/app_data.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/core/widgets/models.item.dart';
import 'package:new_flutter/features/Data/transport/transport.dart';
import 'package:new_flutter/features/data/hotels/hotels_data.dart';
import 'package:new_flutter/features/data/packages/packages.dart';
import 'package:new_flutter/features/data/places/places_data.dart';
import 'package:new_flutter/features/data/ussr_data/get_data.dart';
import 'package:new_flutter/features/home/about.dart';
import 'package:new_flutter/features/models/models.dart';
import 'package:new_flutter/features/profile/profile_page.dart';
import 'package:new_flutter/start_app/start_page.dart';
import '../auth/presentation/pages/login/widgets/login.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    Key? key,

  }) : super(key: key);

  // final String title;
  // final String imageurl;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: 250, // Increased drawer width for better readability
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: kMainColor,
              ),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  email,
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: kMainColor),
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const StartApp()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: const Text('ProfilePage'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ));
              },
            ),
            ListTile(
              title: const Text('About us'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Aboutus()),
                );
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2, // Added elevation for better visual hierarchy
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              color: kMainColor,
              size: 28, // Increased icon size
            ),
            SizedBox(width: 8), // Added spacing
            Text(
              "Egypt.io",
              style: TextStyle(
                color: kMainColor1,
                fontWeight: FontWeight.bold,
                fontSize: 22, // Increased font size
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: kMainColor1, // Added color for consistency
                  ),
                ),
              ),
              
              // Single GridView for all categories
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: Categories_data0.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(
                      context,
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Categories_data0[index].goFor,
                        ),
                      ),
                      Categories_data0[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to build category items with consistent styling
  Widget _buildCategoryItem(BuildContext context, VoidCallback onTap, Models data) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: data.imageurl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: kMainColor),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

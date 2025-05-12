import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Data/ussr_data/get_data.dart';
import 'package:new_flutter/features/Home/about.dart';
import 'package:new_flutter/features/Profile/setting_page.dart';

import '../../core/widgets/contants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isloading = true;
  bool isUploading = false;
  String? profileImageUrl;
  
  // ImgBB API key - replace with your own key
  final String imgbbApiKey = "97f289ace0e894cab662370ed9f08f63";

  getUserData() async {
    CollectionReference backinfo =
        FirebaseFirestore.instance.collection('usersAccounts');
    await backinfo
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot docs) {
      final data = docs.data() as Map<dynamic, dynamic>;
      //print("///////////////////////////////////////////////////////////////");
      print(data);
      firstname = data["fisrtName"];
      lastname = data["lastName"];
      userName = data["userName"];
      email = data["email"];
      profileImageUrl = data["profileImageUrl"];
      isloading = false;
      setState(() {});
    });
  }    //print("///////////////////////////////////////////////////////////////");
   
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image == null) return;
      
      setState(() {
        isUploading = true;
      });
      
      // Upload to ImgBB
      final String? imageUrl = await _uploadToImgBB(File(image.path));
      
      if (imageUrl != null) {
        // Update Firestore with the new image URL
        await _updateProfileImage(imageUrl);
        
        setState(() {
          profileImageUrl = imageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
  
  Future<String?> _uploadToImgBB(File imageFile) async {
    try {
      // Read file as bytes
      final bytes = await imageFile.readAsBytes();
      
      // Convert to base64
      final base64Image = base64Encode(bytes);
      
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse('https://api.imgbb.com/1/upload'))
        ..fields['key'] = imgbbApiKey
        ..fields['image'] = base64Image;
      
      // Send request
      final response = await request.send();
      
      // Get response
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      
      if (response.statusCode == 200 && jsonData['success'] == true) {
        // Return the URL of the uploaded image
        return jsonData['data']['url'];
      } else {
        throw Exception('Failed to upload image: ${jsonData['error']['message']}');
      }
    } catch (e) {
      print('Error uploading to ImgBB: $e');
      return null;
    }
  }
  
  Future<void> _updateProfileImage(String imageUrl) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;
      
      await FirebaseFirestore.instance
          .collection('usersAccounts')
          .doc(userId)
          .update({'profileImageUrl': imageUrl});
          
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  // await GoogleSignIn().signOut();
  
  // Terminate Firestore before clearing persistence
  await FirebaseFirestore.instance.terminate();
  await FirebaseFirestore.instance.clearPersistence();
  
  // Restart Firestore to ensure it works after clearing
  await FirebaseFirestore.instance.enableNetwork();
}

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              iconSize: 20,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kMainColor.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                                      ? Image.network(
                                          profileImageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: kMainColor,
                                          ),
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: kMainColor,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: kMainColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          if (isUploading)
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 16,
                            right: MediaQuery.of(context).size.width / 2 - 80,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kMainColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                   
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'First Name',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Last Name',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Text(
                                lastname,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      SizedBox(
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'About Us',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Aboutus()));
                                  },
                                  icon: const Icon(Icons.info))
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            _signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Login()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.logout,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

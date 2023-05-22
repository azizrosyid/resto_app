import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resto_app/data/db/preferences_helper.dart';
import 'package:resto_app/ui/login_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PreferencesHelper preferencesHelper = PreferencesHelper();
  String username = '';
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    preferencesHelper.username.then((value) {
      setState(() {
        username = value;
      });
    });
    preferencesHelper.getImageProfile().then((value) {
      print(value);
      setState(() {
        imageFile = XFile(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    preferencesHelper.getImageProfile().then((value) {});
    Image profileImage = imageFile?.path != null
        ? Image.file(File(imageFile!.path), width: 100, height: 100)
        : Image.asset('assets/images/profile.jpg', width: 100, height: 100);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            // border radius image
            InkWell(
              onTap: () {
                _picker.pickImage(source: ImageSource.camera).then((value) {
                  if (value == null) return;

                  setState(() {
                    imageFile = value;
                  });
                  preferencesHelper.setImageProfile(imageFile!.path);
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: profileImage),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'NIM    : $username',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ]),
          Row(
            children: [
              const Icon(
                Icons.logout_outlined,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  },
                  child: TextButton(
                    onPressed: () {
                      PreferencesHelper preferencesHelper = PreferencesHelper();
                      preferencesHelper.setLoggedIn(false);
                      preferencesHelper.setUsername('');

                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

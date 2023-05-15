import 'package:flutter/material.dart';
import 'package:resto_app/data/db/preferences_helper.dart';
import 'package:resto_app/ui/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PreferencesHelper preferencesHelper = PreferencesHelper();
  String username = '';

  @override
  Widget build(BuildContext context) {
    preferencesHelper.username.then((value) {
      setState(() {
        username = value;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            // border radius image
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset('assets/images/profile.jpg',
                  width: 100, height: 100),
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

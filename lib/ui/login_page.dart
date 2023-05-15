// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/db/preferences_helper.dart';
import 'package:resto_app/ui/home_page.dart';
import 'package:resto_app/ui/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/login_page';
  @override
  Widget build(BuildContext context) {
    var nimController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('assets/images/brand.png', width: 200),
            const Text('Login To Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nimController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your NIM',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: Colors.grey, size: 30),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline,
                          color: Colors.grey, size: 30),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  try {
                    final user = await dbHelper.login(
                        nimController.text, passwordController.text);
                    if (user != null) {
                      PreferencesHelper prefs = PreferencesHelper();
                      prefs.setLoggedIn(true);
                      prefs.setUsername(user.username);
                      Navigator.pushReplacementNamed(
                          context, HomePage.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('NIM or Password is incorrect')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Failed')));
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child: const Text('Sign In',
                    style: TextStyle(fontSize: 16, color: Colors.white))),
            const SizedBox(height: 20),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, RegisterPage.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Don\'t have an account?',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                      Text(
                        ' Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

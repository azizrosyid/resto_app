import 'package:flutter/material.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/model/user.dart';
import 'package:resto_app/ui/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const routeName = '/register_page';

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
            const Text('Create an Account',
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
                onPressed: () {
                  DatabaseHelper db = DatabaseHelper();
                  User user = User(
                      username: nimController.text,
                      password: passwordController.text);
                  db.insertUser(user).then((value) => {
                        if (value)
                          {
                            Navigator.pushReplacementNamed(
                                context, LoginPage.routeName)
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Register Failed')))
                          }
                      });
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child: const Text('Register',
                    style: TextStyle(fontSize: 16, color: Colors.white))),
            const SizedBox(height: 20),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  },
                  child: const Text(
                    'Already have an account? Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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

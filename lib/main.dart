import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management App',
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(), // here check if user login
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // it show loading
          } else if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data!;
            return isLoggedIn
                ? HomePage()
                : LoginPage(); // its show navigate login status
          } else {
            return LoginPage(); //it go defult login page if an error
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // here cjeck login status
  }
}

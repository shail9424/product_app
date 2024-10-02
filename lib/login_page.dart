import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https:reqres.in/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background1.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // header code
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  'Welcome to Product Management App',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Here Main content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.black54,
                      ),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.black54,
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            child: Text('Login'),
                          ),
                  ],
                ),
              ),
              // footer code
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 201, 23, 23),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(66, 231, 74, 7),
                      offset: Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'new to logistics? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your registration navigation logic here
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

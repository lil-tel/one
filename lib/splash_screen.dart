import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one/ThemeManager.dart';
import 'package:one/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(this.theme, {super.key});

  final ThemeNotifier theme;

  @override
  _SplashScreenState createState() => _SplashScreenState(theme);
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState(this.theme);

  final ThemeNotifier theme;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppInitializer(theme: theme)), // Replace 'HomeScreen' with your actual home screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Replace with your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your logo or loading animation widget here
            // For example, you can use an Image widget:
            Image.asset('assets/icons/oneicon.png'), // Replace 'assets/logo.png' with the path to your logo image asset
            SizedBox(height: 16.0),
            CircularProgressIndicator(), // Replace with your own loading animation widget if desired
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/home_screen.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  void _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;

    // Add a delay to simulate the splash screen duration
    Timer(const Duration(seconds: 1), () {
      _navigateToScreen(rememberMe);
    });
  }

  void _navigateToScreen(bool rememberMe) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            rememberMe ? const HomeScreen() : const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          var opacityTween = Tween<double>(begin: begin, end: end);
          var opacityAnimation = opacityTween.animate(animation);
          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/popcorn(2).png',
          fit: BoxFit.cover,
          height: 100,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

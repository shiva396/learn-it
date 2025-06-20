// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnit/auth/auth_functions.dart';
import 'package:learnit/ui/molecules/splash_card.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigateAfterDelay();
  }

  void navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () async {
      final loggedIn = await isLoggedIn();
      if (!context.mounted) return;

      if (!loggedIn) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171617),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            splashCard(context),
            SizedBox(height: 150),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

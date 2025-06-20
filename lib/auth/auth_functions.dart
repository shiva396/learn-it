import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> setLoginState(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', value);
  print("Login state set to: $value");
}


Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final userIn = prefs.getBool('isLogged') ?? false;
  return FirebaseAuth.instance.currentUser != null && userIn;
}


Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  await setLoginState(false);
  print("User logged out");
  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

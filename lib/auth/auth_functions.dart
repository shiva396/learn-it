import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setLoginState(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', value);
  print("Login state set to: $value");
}

Future<bool> isLoggedIn() async {
  return false; // Placeholder for guest mode
}

Future<void> logout(BuildContext context) async {
  // No-op for guest mode
  await setLoginState(false);
  print("User logged out");
  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

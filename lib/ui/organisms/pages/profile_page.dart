import 'package:flutter/material.dart';
import 'package:learnit/auth/auth_functions.dart';
import 'package:learnit/ui/atoms/colors.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logout(context);
          },
          child: Text('Logout'),
        ),
      ),
      backgroundColor: LColors.blueDark,
    );
  }
}

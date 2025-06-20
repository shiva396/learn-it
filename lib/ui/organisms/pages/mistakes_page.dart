import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart'; // Import the colors.dart file

class MistakesPage extends StatelessWidget {
  const MistakesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mistakes')),
      body: Center(child: Text('Mistakes Page')),
      backgroundColor: LColors.blueDark, // Set the background color
    );
  }
}

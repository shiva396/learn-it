import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart'; // Import the colors.dart file

class TensesPage extends StatelessWidget {
  const TensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tenses')),
      body: Center(child: Text('Tenses Page')),
      backgroundColor: LColors.blueDark, // Set the background color
    );
  }
}

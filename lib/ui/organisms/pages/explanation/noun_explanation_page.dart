import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class NounExplanationPage extends StatelessWidget {
  const NounExplanationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noun Explanation'),
        backgroundColor: LColors.blueDark,
        elevation: 0,
      ),
      backgroundColor: LColors.blueDark,
      body: const Center(
        child: Text(
          'Content for Noun Explanation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

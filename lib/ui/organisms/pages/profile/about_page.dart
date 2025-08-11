import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: const Text(
          'About Learn-IT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: LColors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: LColors.blue, width: 3),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/Learn-it.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Learn-IT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: LColors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Grammar Made Simple',
              style: TextStyle(
                fontSize: 18,
                color: LColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Version 2.0.0',
              style: TextStyle(fontSize: 14, color: LColors.grey),
            ),

            const SizedBox(height: 32),

            Card(
              color: LColors.background,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Learn-IT is your personal grammar companion designed to make learning English grammar fun, interactive, and effective. Our app helps you master the fundamentals of English grammar through engaging exercises, practical examples, and personalized learning paths.',
                  style: TextStyle(
                    fontSize: 16,
                    color: LColors.greyDark,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.3),

            Text(
              'Made with Flutter 💙',
              style: TextStyle(fontSize: 12, color: LColors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

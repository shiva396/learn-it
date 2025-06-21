import 'package:flutter/material.dart';

class ImageBasedQuestionsPage extends StatelessWidget {
  const ImageBasedQuestionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image-Based Questions'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(child: Text('Image-Based Questions Content Here')),
    );
  }
}

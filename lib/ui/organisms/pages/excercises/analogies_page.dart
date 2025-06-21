import 'package:flutter/material.dart';

class AnalogiesPage extends StatelessWidget {
  const AnalogiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analogies'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(child: Text('Analogies Content Here')),
    );
  }
}

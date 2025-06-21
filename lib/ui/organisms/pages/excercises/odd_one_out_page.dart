import 'package:flutter/material.dart';

class OddOneOutPage extends StatelessWidget {
  const OddOneOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odd One Out'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Odd One Out Content Here'),
      ),
    );
  }
}

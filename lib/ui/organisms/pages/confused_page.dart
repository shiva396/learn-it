import 'package:flutter/material.dart';

class ConfusedPage extends StatelessWidget {
  const ConfusedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confused')),
      body: Center(child: Text('Confused Page')),
    );
  }
}

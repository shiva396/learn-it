import 'package:flutter/material.dart';

class NumberSeriesPage extends StatelessWidget {
  const NumberSeriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Series'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Number Series Content Here'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VocabularyDefinitionsPage extends StatelessWidget {
  const VocabularyDefinitionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary & Definitions'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Vocabulary & Definitions Content Here'),
      ),
    );
  }
}

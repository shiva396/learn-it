import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrepositionsPage extends StatelessWidget {
  const PrepositionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prepositions')),
      body: Markdown(
        data:
            '# Prepositions\n\nPrepositions are words that show the relationship between a noun or pronoun and other words in a sentence. Examples include in, on, and under.',
      ),
    );
  }
}

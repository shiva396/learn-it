import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PronounsPage extends StatelessWidget {
  const PronounsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pronouns')),
      body: Markdown(
        data:
            '# Pronouns\n\nPronouns are words that replace nouns in a sentence. Examples include he, she, it, they, and we.',
      ),
    );
  }
}

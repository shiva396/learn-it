import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NounsPage extends StatelessWidget {
  const NounsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouns')),
      body: Markdown(
        data:
            '# Nouns\n\nNouns are words that name people, places, things, or ideas. They can be singular or plural, common or proper.',
      ),
    );
  }
}

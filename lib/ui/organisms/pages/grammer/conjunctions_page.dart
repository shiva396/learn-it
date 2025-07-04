import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ConjunctionsPage extends StatelessWidget {
  const ConjunctionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conjunctions')),
      body: Markdown(
        data:
            '# Conjunctions\n\nConjunctions are words that connect clauses or sentences. Examples include and, but, and or.',
      ),
    );
  }
}

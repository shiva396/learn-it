import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class VerbsPage extends StatelessWidget {
  const VerbsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verbs')),
      body: Markdown(
        data:
            '# Verbs\n\nVerbs are action words that describe what the subject is doing. Examples include run, jump, and think.',
      ),
    );
  }
}

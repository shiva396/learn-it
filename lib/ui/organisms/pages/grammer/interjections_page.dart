import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class InterjectionsPage extends StatelessWidget {
  const InterjectionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interjections')),
      body: Markdown(
        data:
            '# Interjections\n\nInterjections are words or phrases that express strong emotion. Examples include wow, ouch, and hooray.',
      ),
    );
  }
}

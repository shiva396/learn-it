import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:learnit/ui/atoms/colors.dart';

class PartsOfSpeechPage extends StatefulWidget {
  final Function(double) onProgressUpdate;

  const PartsOfSpeechPage({Key? key, required this.onProgressUpdate})
    : super(key: key);

  @override
  _PartsOfSpeechPageState createState() => _PartsOfSpeechPageState();
}

class _PartsOfSpeechPageState extends State<PartsOfSpeechPage> {
  double _fontSize = 16;
  ScrollController _scrollController = ScrollController();
  double _progress = 0.0;

  void _updateFontSize(double newSize) {
    setState(() {
      _fontSize = newSize;
    });
  }

  void _updateProgress() {
    setState(() {
      _progress =
          _scrollController.hasClients
              ? _scrollController.offset /
                  (_scrollController.position.maxScrollExtent)
              : 0.0;
    });
    widget.onProgressUpdate(_progress); // Notify parent about progress
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: Text(
          'PARTS OF SPEECH',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: LColors.surface,
            color: LColors.blue,
          ),
          Expanded(
            child: FutureBuilder<String>(
              future: DefaultAssetBundle.of(
                context,
              ).loadString('assets/markdown/adverb.md'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading content: ${snapshot.error}'),
                  );
                } else {
                  return Markdown(
                    data: snapshot.data ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: _fontSize),
                      h1: TextStyle(fontSize: _fontSize + 8),
                      h2: TextStyle(fontSize: _fontSize + 6),
                      h3: TextStyle(fontSize: _fontSize + 4),
                    ),
                    controller: _scrollController,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LColors.blue, // Match button color to page theme
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: LColors.surface, // Match modal background to theme
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Slider(
                          value: _fontSize,
                          min: 12,
                          max: 30,
                          divisions: 18,
                          label: _fontSize.round().toString(),
                          activeColor:
                              LColors.blue, // Match slider active color
                          inactiveColor: LColors.blue.withOpacity(0.3),
                          onChanged: (value) {
                            setState(() {
                              _updateFontSize(value);
                            });
                          },
                        ),
                      ),
                      Text(
                        'Font Size: ${_fontSize.round()}',
                        style: TextStyle(
                          color:
                              Colors.black, // Fallback to black for text color
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.text_fields,
          color: Colors.white,
        ), // White icon for contrast
        tooltip: 'Adjust Font Size',
      ),
    );
  }
}

class AdverbPage extends StatelessWidget {
  const AdverbPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adverbs')),
      body: Markdown(
        data:
            '# Adverbs\n\nAdverbs are words that modify verbs, adjectives, or other adverbs. They often answer questions like how, when, where, and to what extent.',
      ),
    );
  }
}

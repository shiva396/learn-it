import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:learnit/ui/atoms/colors.dart';

class GerundInfinitivePage extends StatefulWidget {
  final Function(double) onProgressUpdate;

  const GerundInfinitivePage({Key? key, required this.onProgressUpdate})
    : super(key: key);

  @override
  _GerundInfinitivePageState createState() => _GerundInfinitivePageState();
}

class _GerundInfinitivePageState extends State<GerundInfinitivePage> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final progress = (currentScroll / maxScrollExtent).clamp(0.0, 1.0);
    widget.onProgressUpdate(progress * 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: Text(
          'GERUND AND INFINITIVE',
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
          Expanded(
            child: FutureBuilder<String>(
              future: DefaultAssetBundle.of(
                context,
              ).loadString('assets/markdown/gerund_and_infinitive.md'),
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
                    controller: _scrollController,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: _fontSize),
                      h1: TextStyle(fontSize: _fontSize + 8),
                      h2: TextStyle(fontSize: _fontSize + 6),
                      h3: TextStyle(fontSize: _fontSize + 4),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LColors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: LColors.surface,
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
                          activeColor: LColors.blue,
                          inactiveColor: LColors.blue.withOpacity(0.3),
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}

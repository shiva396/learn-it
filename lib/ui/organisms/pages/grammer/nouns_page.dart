import 'package:flutter/material.dart';

class NounsPage extends StatefulWidget {
  final Function(double) onProgressUpdate;

  const NounsPage({Key? key, required this.onProgressUpdate}) : super(key: key);

  @override
  _NounsPageState createState() => _NounsPageState();
}

class _NounsPageState extends State<NounsPage> {
  final ScrollController _scrollController = ScrollController();

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
      appBar: AppBar(title: Text('Nouns')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(title: Text('Item #$index')),
      ),
    );
  }
}

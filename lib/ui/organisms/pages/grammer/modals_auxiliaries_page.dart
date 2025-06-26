import 'package:flutter/material.dart';

class ModalsAuxiliariesPage extends StatefulWidget {
  final Function(double) onProgressUpdate;

  const ModalsAuxiliariesPage({Key? key, required this.onProgressUpdate})
    : super(key: key);

  @override
  _ModalsAuxiliariesPageState createState() => _ModalsAuxiliariesPageState();
}

class _ModalsAuxiliariesPageState extends State<ModalsAuxiliariesPage> {
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
      appBar: AppBar(title: Text('Modals and Modal Auxiliaries')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(title: Text('Item #$index')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class PaintTheCatPage extends StatefulWidget {
  const PaintTheCatPage({Key? key}) : super(key: key);

  @override
  _PaintTheCatPageState createState() => _PaintTheCatPageState();
}

class _PaintTheCatPageState extends State<PaintTheCatPage> {
  final List<String> _adjectives = ['black', 'fluffy', 'big', 'happy', 'shiny'];
  final List<String> _appliedAdjectives = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint the Cat'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'This is a cat. But what kind of cat?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/cat_base.png'),
                if (_appliedAdjectives.contains('black'))
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.modulate,
                    ),
                    child: Image.asset('assets/images/cat_base.png'),
                  ),
                if (_appliedAdjectives.contains('fluffy'))
                  Image.asset('assets/images/fur_overlay.png'),
                if (_appliedAdjectives.contains('big'))
                  Transform.scale(
                    scale: 1.5,
                    child: Image.asset('assets/images/cat_base.png'),
                  ),
                if (_appliedAdjectives.contains('happy'))
                  Positioned(
                    top: 50,
                    child: Icon(
                      Icons.tag_faces,
                      size: 100,
                      color: Colors.yellow,
                    ),
                  ),
                if (_appliedAdjectives.contains('shiny'))
                  Positioned(
                    child: Lottie.asset('assets/animations/sparkle.json'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _appliedAdjectives.isEmpty
                  ? 'This is a plain cat.'
                  : 'This is a ${_appliedAdjectives.join(', ')} cat.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children:
                _adjectives.map((adjective) {
                  return Draggable<String>(
                    data: adjective,
                    feedback: Chip(
                      label: Text(adjective),
                      backgroundColor: Colors.pinkAccent,
                    ),
                    child: Chip(
                      label: Text(adjective),
                      backgroundColor: Colors.pinkAccent,
                    ),
                    onDragCompleted: () {
                      setState(() {
                        if (!_appliedAdjectives.contains(adjective)) {
                          _appliedAdjectives.add(adjective);
                        }
                      });
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

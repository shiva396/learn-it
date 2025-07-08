import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaintTheCatPage(),
      ),
    );

// Main screen: Interactive cat painting with adjectives
class PaintTheCatPage extends StatefulWidget {
  const PaintTheCatPage({Key? key}) : super(key: key);

  @override
  State<PaintTheCatPage> createState() => _PaintTheCatPageState();
}

class _PaintTheCatPageState extends State<PaintTheCatPage> {
  final List<String> colors = ['black', 'white', 'orange', 'grey'];
  final List<String> sizes = ['small', 'big', 'tiny', 'huge'];
  final List<String> textures = ['fluffy', 'rough', 'smooth', 'spiky'];
  final List<String> feelings = ['happy', 'sad', 'angry', 'surprised'];

  String? selectedColor;
  String? selectedSize;
  String? selectedTexture;
  String? selectedFeeling;

  // Apply chosen adjective to state
  void _applyAdjective(String category, String value) {
    setState(() {
      if (category == 'color') selectedColor = value;
      if (category == 'size') selectedSize = value;
      if (category == 'texture') selectedTexture = value;
      if (category == 'feeling') selectedFeeling = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build list of applied adjectives for sentence
    final applied = [
      if (selectedColor != null) selectedColor!,
      if (selectedTexture != null) selectedTexture!,
      if (selectedSize != null) selectedSize!,
      if (selectedFeeling != null) selectedFeeling!,
    ];

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Paint the Cat'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Cat display area
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: CatPainter(
                    color: _getColorFromAdjective(selectedColor),
                    texture: selectedTexture,
                    feeling: selectedFeeling,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Dynamic descriptive sentence
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _buildSentence(applied),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            // Adjective categories
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  _buildCategory('Color', colors, 'color'),
                  _buildCategory('Size', sizes, 'size'),
                  _buildCategory('Texture', textures, 'texture'),
                  _buildCategory('Feeling', feelings, 'feeling'),
                ],
              ),
            ),
            // Instruction footer
            Container(
              width: double.infinity,
              color: Colors.deepPurpleAccent,
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Tap an adjective below to transform the cat!',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a horizontal chip list for each category
  Widget _buildCategory(String title, List<String> values, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final value = values[index];
                final isSelected = _isSelected(category, value);
                return ChoiceChip(
                  label: Text(value),
                  selected: isSelected,
                  onSelected: (_) => _applyAdjective(category, value),
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  backgroundColor: Colors.grey[200],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Map color adjective to actual Color
  Color _getColorFromAdjective(String? color) {
    switch (color) {
      case 'black': return Colors.black87;
      case 'white': return Colors.grey[200]!;
      case 'orange': return Colors.orangeAccent;
      case 'grey': return Colors.grey;
      default: return Colors.brown;
    }
  }

  // Determine scale from size adjective
  double _getScaleFromSize(String? size) {
    switch (size) {
      case 'big': return 1.4;
      case 'tiny': return 0.6;
      case 'huge': return 1.8;
      default: return 1.0;
    }
  }

  // Check if an adjective is currently selected
  bool _isSelected(String category, String value) {
    if (category == 'color') return selectedColor == value;
    if (category == 'size') return selectedSize == value;
    if (category == 'texture') return selectedTexture == value;
    if (category == 'feeling') return selectedFeeling == value;
    return false;
  }

  // Construct sentence from selected adjectives
  String _buildSentence(List<String> adjectives) {
    if (adjectives.isEmpty) return 'This is just a plain cat.';
    return 'This is a ${adjectives.join(', ')} cat.';
  }
}

// Custom painter that draws a cat with dynamic attributes
class CatPainter extends CustomPainter {
  final Color color;
  final String? texture;
  final String? feeling;

  CatPainter({required this.color, this.texture, this.feeling});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    final bodyPaint = Paint()..color = color;

    // Draw body
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 180, height: 120),
      bodyPaint,
    );

    // Draw head
    canvas.drawCircle(
      Offset(center.dx, center.dy - 80),
      50,
      bodyPaint,
    );

    // Ears
    _drawEar(canvas, center, true);
    _drawEar(canvas, center, false);

    // Legs
    _drawLeg(canvas, center.translate(-40, 50));
    _drawLeg(canvas, center.translate(40, 50));

    // Tail
    _drawTail(canvas, center);

    // Face (eyes/mouth)
    _drawFace(canvas, center);

    // Whiskers
    _drawWhiskers(canvas, center);

    // Texture overlay
    _drawTexture(canvas, center);
  }

  // Draw an ear at left or right
  void _drawEar(Canvas canvas, Offset c, bool isLeft) {
    final offsetX = isLeft ? -40.0 : 40.0;
    final earPath = Path()
      ..moveTo(c.dx + offsetX, c.dy - 120)
      ..lineTo(c.dx + offsetX * 1.4, c.dy - 160)
      ..lineTo(c.dx + offsetX * 0.2, c.dy - 130)
      ..close();
    canvas.drawPath(earPath, Paint()..color = color);
    // Inner ear
    final innerPath = Path()
      ..moveTo(c.dx + offsetX, c.dy - 125)
      ..lineTo(c.dx + offsetX * 1.2, c.dy - 150)
      ..lineTo(c.dx + offsetX * 0.4, c.dy - 135)
      ..close();
    canvas.drawPath(innerPath, Paint()..color = Colors.pink[100]!);
  }

  // Draw a leg
  void _drawLeg(Canvas canvas, Offset pos) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 30, height: 60),
        const Radius.circular(15),
      ),
      Paint()..color = color,
    );
  }

  // Draw the tail with quadratic curve
  void _drawTail(Canvas canvas, Offset c) {
    final tailPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    final tail = Path()
      ..moveTo(c.dx + 90, c.dy + 10)
      ..quadraticBezierTo(c.dx + 140, c.dy - 20, c.dx + 90, c.dy - 60);
    canvas.drawPath(tail, tailPaint);
  }

  // Draw eyes and mouth based on feeling
  void _drawFace(Canvas canvas, Offset c) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final eyeY = c.dy - 80;
    final dx = 20.0;

    // Eyes always visible
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - dx, eyeY), width: 20, height: 14), eyePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + dx, eyeY), width: 20, height: 14), eyePaint);
    canvas.drawCircle(Offset(c.dx - dx, eyeY), 6, pupilPaint);
    canvas.drawCircle(Offset(c.dx + dx, eyeY), 6, pupilPaint);

    // Mouth variations
    if (feeling == 'happy') {
      final path = Path()
        ..moveTo(c.dx - 15, c.dy - 60)
        ..quadraticBezierTo(c.dx, c.dy - 40, c.dx + 15, c.dy - 60);
      canvas.drawPath(path, mouthPaint);
    } else if (feeling == 'sad') {
      final path = Path()
        ..moveTo(c.dx - 15, c.dy - 50)
        ..quadraticBezierTo(c.dx, c.dy - 70, c.dx + 15, c.dy - 50);
      canvas.drawPath(path, mouthPaint);
    } else if (feeling == 'angry') {
      canvas.drawLine(Offset(c.dx - dx - 10, eyeY - 5), Offset(c.dx - dx + 10, eyeY + 5), mouthPaint);
      canvas.drawLine(Offset(c.dx + dx + 10, eyeY - 5), Offset(c.dx + dx - 10, eyeY + 5), mouthPaint);
    } else if (feeling == 'surprised') {
      canvas.drawCircle(Offset(c.dx, c.dy - 60), 8, pupilPaint);
    }
  }

  // Draw whiskers on both sides
  void _drawWhiskers(Canvas canvas, Offset c) {
    final whiskerPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2;
    for (int sign in [1, -1]) {
      canvas.drawLine(Offset(c.dx + sign*20, c.dy - 50), Offset(c.dx + sign*60, c.dy - 45), whiskerPaint);
      canvas.drawLine(Offset(c.dx + sign*20, c.dy - 40), Offset(c.dx + sign*60, c.dy - 35), whiskerPaint);
    }
  }

  // Render texture overlays
  void _drawTexture(Canvas canvas, Offset c) {
    if (texture == 'fluffy') {
      final paint = Paint()..color = Colors.white.withOpacity(0.6);
      for (double a = 0; a < 360; a += 15) {
        final ang = a * pi / 180;
        final r = 90 + sin(a / 30) * 10;
        final x = c.dx + r * cos(ang);
        final y = c.dy + r * sin(ang);
        canvas.drawCircle(Offset(x, y), 6, paint);
      }
    } else if (texture == 'rough') {
      final paint = Paint()..color = Colors.black26..strokeWidth = 3;
      for (int i = 0; i < 25; i++) {
        final x = c.dx - 70 + i * 5;
        final y = c.dy + 10 + (i % 2 == 0 ? -5 : 5);
        canvas.drawLine(Offset(x, y), Offset(x + 8, y + 8), paint);
      }
    } else if (texture == 'spiky') {
      final paint = Paint()..color = Colors.orangeAccent..strokeWidth = 4;
      for (double a = 0; a < 360; a += 20) {
        final ang = a * pi / 180;
        final x1 = c.dx + 80 * cos(ang);
        final y1 = c.dy + 50 * sin(ang);
        final x2 = c.dx + 100 * cos(ang);
        final y2 = c.dy + 70 * sin(ang);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    } else if (texture == 'smooth') {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawOval(
        Rect.fromCenter(center: c, width: 200, height: 140),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

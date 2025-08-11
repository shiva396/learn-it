import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class ComingSoonPage extends StatefulWidget {
  final String topicName;
  final String difficultyName;

  const ComingSoonPage({
    super.key,
    required this.topicName,
    required this.difficultyName,
  });

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation and repeat it
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: Text(
          '${widget.topicName.toUpperCase()} - ${widget.difficultyName.toUpperCase()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: LColors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Test questions for ${widget.topicName} are being prepared',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: LColors.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'We\'re working hard to bring you engaging test content.\nCheck back soon!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: LColors.grey, height: 1.5),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learnit/services/recent_activities_service.dart';
import 'package:learnit/ui/atoms/colors.dart';

/// Enhanced interactive cat painting with adjectives - Educational game for learning descriptive words
class PaintTheCatPage extends StatefulWidget {
  const PaintTheCatPage({Key? key}) : super(key: key);

  @override
  State<PaintTheCatPage> createState() => _PaintTheCatPageState();
}

class _PaintTheCatPageState extends State<PaintTheCatPage>
    with TickerProviderStateMixin {
  // Enhanced adjective categories with app theme colors
  final List<Map<String, dynamic>> colors = [
    {'name': 'black', 'color': Colors.black87},
    {'name': 'white', 'color': Colors.grey[200]},
    {'name': 'orange', 'color': LColors.warning},
    {'name': 'grey', 'color': Colors.grey},
    {'name': 'brown', 'color': Colors.brown},
    {'name': 'blue', 'color': LColors.blue},
  ];

  final List<Map<String, dynamic>> sizes = [
    {'name': 'tiny', 'scale': 0.6},
    {'name': 'small', 'scale': 0.8},
    {'name': 'normal', 'scale': 1.0},
    {'name': 'big', 'scale': 1.2},
    {'name': 'huge', 'scale': 1.6},
    {'name': 'gigantic', 'scale': 2.0},
  ];

  final List<Map<String, dynamic>> textures = [
    {'name': 'fluffy', 'description': 'Soft and puffy'},
    {'name': 'smooth', 'description': 'Sleek and shiny'},
    {'name': 'rough', 'description': 'Bumpy and coarse'},
    {'name': 'spiky', 'description': 'Sharp and pointed'},
    {'name': 'silky', 'description': 'Ultra smooth'},
    {'name': 'woolly', 'description': 'Thick and warm'},
  ];

  final List<Map<String, dynamic>> feelings = [
    {'name': 'happy', 'description': 'Joyful and content'},
    {'name': 'sad', 'description': 'Melancholy and down'},
    {'name': 'angry', 'description': 'Furious and mad'},
    {'name': 'surprised', 'description': 'Shocked and amazed'},
    {'name': 'sleepy', 'description': 'Tired and drowsy'},
    {'name': 'playful', 'description': 'Fun and energetic'},
  ];

  final List<Map<String, dynamic>> personalities = [
    {'name': 'lazy', 'description': 'Loves to relax'},
    {'name': 'energetic', 'description': 'Full of energy'},
    {'name': 'curious', 'description': 'Always exploring'},
    {'name': 'shy', 'description': 'Quiet and reserved'},
    {'name': 'brave', 'description': 'Fearless and bold'},
    {'name': 'mischievous', 'description': 'Playfully naughty'},
  ];

  // State variables
  String? selectedColor;
  String? selectedSize;
  String? selectedTexture;
  String? selectedFeeling;
  String? selectedPersonality;
  bool _showMagic = false;
  bool _showStars = false;
  bool _isMuted = false;

  // Flutter TTS instance
  FlutterTts? flutterTts;
  bool _isTtsAvailable = false;

  // Animation controllers
  late AnimationController _controller;
  late AnimationController _magicController;
  late AnimationController _starController;
  late AnimationController _bounceController;

  // Animations
  late Animation<double> _fadeAnim;
  late Animation<double> _magicAnim;
  late Animation<double> _starAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _controller.forward();
    _logActivity();

    // Initialize TTS with delay to ensure widget is built
    Future.delayed(const Duration(milliseconds: 500), () {
      _initializeTts();
    });
  }

  void _initializeTts() async {
    try {
      flutterTts = FlutterTts();

      // Add small delay for platform to initialize
      await Future.delayed(const Duration(milliseconds: 100));

      // Set completion awaiting
      await flutterTts!.awaitSpeakCompletion(true);

      // Set up TTS configuration with error handling for each call
      try {
        await flutterTts!.setLanguage("en-US");
      } catch (e) {
        debugPrint('Error setting language: $e');
      }

      try {
        await flutterTts!.setSpeechRate(0.6);
      } catch (e) {
        debugPrint('Error setting speech rate: $e');
      }

      try {
        await flutterTts!.setVolume(1.0);
      } catch (e) {
        debugPrint('Error setting volume: $e');
      }

      try {
        await flutterTts!.setPitch(1.0);
      } catch (e) {
        debugPrint('Error setting pitch: $e');
      }

      // Set up error handlers
      flutterTts!.setErrorHandler((msg) {
        debugPrint('TTS Error Handler: $msg');
        _isTtsAvailable = false;
      });

      flutterTts!.setCompletionHandler(() {
        debugPrint('TTS Completion Handler called');
      });

      flutterTts!.setStartHandler(() {
        debugPrint('TTS Start Handler called');
        _isTtsAvailable = true;
      });

      // Test TTS availability with a simple test
      try {
        var result = await flutterTts!.speak("");
        debugPrint('TTS empty test result: $result');
        _isTtsAvailable = true;
      } catch (e) {
        debugPrint('TTS test speak error: $e');
        _isTtsAvailable = false;
      }

      debugPrint('TTS initialization completed. Available: $_isTtsAvailable');
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      _isTtsAvailable = false;
    }
  }

  void _initializeAnimations() {
    // Main fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    // Magic effect animation
    _magicController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _magicAnim = CurvedAnimation(
      parent: _magicController,
      curve: Curves.elasticOut,
    );

    // Star particles animation
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _starAnim = CurvedAnimation(
      parent: _starController,
      curve: Curves.easeOutQuad,
    );

    // Bounce animation for selections
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnim = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );
  }

  void _logActivity() async {
    await RecentActivitiesService.logVideoWatched(
      'Paint the Cat - Interactive Adjective Learning',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _magicController.dispose();
    _starController.dispose();
    _bounceController.dispose();
    flutterTts?.stop();
    super.dispose();
  }

  // Enhanced apply adjective with haptic feedback, animations, and speech
  void _applyAdjective(String category, String value) {
    // Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _showMagic = true;
      _showStars = true;

      if (category == 'color') selectedColor = value;
      if (category == 'size') selectedSize = value;
      if (category == 'texture') selectedTexture = value;
      if (category == 'feeling') selectedFeeling = value;
      if (category == 'personality') selectedPersonality = value;
    });

    // Trigger animations
    _magicController.forward(from: 0);
    _starController.forward(from: 0);
    _bounceController.forward(from: 0);
    _controller.forward(from: 0);

    // Speak the selected adjective first, then the full description
    _speakSelectedAdjective(value);

    // Hide effects after animations
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showMagic = false;
          _showStars = false;
        });
      }
    });
  }

  void _speakSelectedAdjective(String adjective) async {
    if (_isMuted || !_isTtsAvailable || flutterTts == null) return;
    _speakDescription();

    // Speak the selected adjective immediately
    // try {
    //   var result = await flutterTts!.speak(adjective);
    //   debugPrint('TTS speak adjective result: $result');

    //   // Wait a moment then speak the full description
    //   await Future.delayed(const Duration(milliseconds: 800));
    //   _speakDescription();
    // } catch (e) {
    //   debugPrint('TTS Error speaking adjective: $e');
    //   // Fallback to just speaking the full description
    // }
  }

  void _speakDescription() async {
    if (_isMuted || !_isTtsAvailable || flutterTts == null) return;

    final applied = [
      if (selectedColor != null) selectedColor!,
      if (selectedTexture != null) selectedTexture!,
      if (selectedSize != null) selectedSize!,
      if (selectedFeeling != null) selectedFeeling!,
      if (selectedPersonality != null) selectedPersonality!,
    ];

    final sentence = _buildEnhancedSentence(applied);

    // Use flutter_tts to speak the description
    try {
      var result = await flutterTts!.speak(sentence);
      debugPrint('TTS speak result: $result');
    } catch (e) {
      debugPrint('TTS Error: $e');
      // Try to reinitialize and speak again
      try {
        _initializeTts();
        await Future.delayed(const Duration(milliseconds: 500));
        if (flutterTts != null) {
          await flutterTts!.speak(sentence);
        }
      } catch (e2) {
        debugPrint('TTS Fallback Error: $e2');
      }
    }
  }

  void _resetCat() async {
    HapticFeedback.mediumImpact();
    setState(() {
      selectedColor = null;
      selectedSize = null;
      selectedTexture = null;
      selectedFeeling = null;
      selectedPersonality = null;
    });
    _controller.forward(from: 0);

    // Speak the reset message using TTS
    if (!_isMuted && _isTtsAvailable && flutterTts != null) {
      try {
        var result = await flutterTts!.speak("This is just a plain cat!");
        debugPrint('TTS speak result: $result');
      } catch (e) {
        debugPrint('TTS Error: $e');
        // Try to reinitialize and speak again
        try {
          _initializeTts();
          await Future.delayed(const Duration(milliseconds: 500));
          if (flutterTts != null) {
            await flutterTts!.speak("This is just a plain cat!");
          }
        } catch (e2) {
          debugPrint('TTS Fallback Error: $e2');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final applied = [
      if (selectedColor != null) selectedColor!,
      if (selectedTexture != null) selectedTexture!,
      if (selectedSize != null) selectedSize!,
      if (selectedFeeling != null) selectedFeeling!,
      if (selectedPersonality != null) selectedPersonality!,
    ];

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Paint the Cat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isMuted = !_isMuted;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetCat,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [LColors.background, LColors.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cat display area with enhanced effects
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white, LColors.greyWhite],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: LColors.blue.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Animated background particles
                      AnimatedBuilder(
                        animation: _starController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ParticlePainter(
                              _starAnim.value,
                              _showStars,
                            ),
                            size: Size.infinite,
                          );
                        },
                      ),

                      // Main cat display
                      Center(
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: Transform.scale(
                            scale:
                                _getScaleFromSize(selectedSize) *
                                (1.0 + _bounceAnim.value * 0.1),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CustomPaint(
                                painter: EnhancedCatPainter(
                                  color: _getColorFromAdjective(selectedColor),
                                  texture: selectedTexture,
                                  feeling: selectedFeeling,
                                  personality: selectedPersonality,
                                  animationValue: _magicAnim.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Magic sparkle overlay
                      if (_showMagic)
                        AnimatedBuilder(
                          animation: _magicController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: MagicEffectPainter(_magicAnim.value),
                              size: Size.infinite,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Enhanced descriptive sentence with stable positioning
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: LColors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      _buildEnhancedSentence(applied),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LColors.greyDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // if (applied.isNotEmpty) ...[
                    //   const SizedBox(height: 8),
                    //   Text(
                    //     _getAdjectiveExplanation(applied),
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.white.withOpacity(0.8),
                    //       fontStyle: FontStyle.italic,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ],
                  ],
                ),
              ),

              // Enhanced adjective selectors
              Expanded(
                flex: 3,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    _buildEnhancedCategory('Colors', colors, 'color'),
                    _buildEnhancedCategory('Sizes', sizes, 'size'),
                    _buildEnhancedCategory('Textures', textures, 'texture'),
                    _buildEnhancedCategory('Feelings', feelings, 'feeling'),
                    _buildEnhancedCategory(
                      'Personalities',
                      personalities,
                      'personality',
                    ),
                  ],
                ),
              ),

              // Enhanced instruction footer
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: LColors.blue),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Tap adjectives to transform your magical cat!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced category builder with animations and better visuals
  Widget _buildEnhancedCategory(
    String title,
    List<Map<String, dynamic>> values,
    String category,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: LColors.blue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: LColors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LColors.greyDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = values[index];
                final isSelected = _isSelected(category, item['name']);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutBack,
                  child: GestureDetector(
                    onTap: () => _applyAdjective(category, item['name']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isSelected
                                  ? [LColors.blue, LColors.blueLight]
                                  : [LColors.greyWhite, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? LColors.blue : LColors.greyLight,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : LColors.greyDark,
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced sentence builder with more dynamic descriptions
  String _buildEnhancedSentence(List<String> adjectives) {
    if (adjectives.isEmpty) {
      return 'This is just a plain, ordinary cat waiting for your magic!';
    }

    if (adjectives.length == 1) {
      return 'This is a ${adjectives[0]} cat!';
    }

    if (adjectives.length <= 3) {
      return 'This is a ${adjectives.join(', ')} cat!';
    }

    return 'This is a ${adjectives.sublist(0, adjectives.length - 1).join(', ')}, and ${adjectives.last} cat!';
  }

  Color _getColorFromAdjective(String? color) {
    for (final colorData in colors) {
      if (colorData['name'] == color) {
        return colorData['color'] ?? Colors.brown;
      }
    }
    return Colors.brown;
  }

  double _getScaleFromSize(String? size) {
    for (final sizeData in sizes) {
      if (sizeData['name'] == size) {
        return sizeData['scale'] ?? 1.0;
      }
    }
    return 1.0;
  }

  bool _isSelected(String category, String value) {
    return (category == 'color' && selectedColor == value) ||
        (category == 'size' && selectedSize == value) ||
        (category == 'texture' && selectedTexture == value) ||
        (category == 'feeling' && selectedFeeling == value) ||
        (category == 'personality' && selectedPersonality == value);
  }
}

/// Enhanced particle effect painter for magical animations
class ParticlePainter extends CustomPainter {
  final double animationValue;
  final bool showParticles;

  ParticlePainter(this.animationValue, this.showParticles);

  @override
  void paint(Canvas canvas, Size size) {
    if (!showParticles || size.width <= 0 || size.height <= 0) return;

    // Ensure opacity is always valid (between 0.0 and 1.0)
    final opacity = (0.7 * (1 - animationValue)).clamp(0.0, 1.0);
    final paint =
        Paint()
          ..color = const Color(0xFFFFD700).withOpacity(opacity)
          ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent animation

    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = ((1 - animationValue) * 6 + 1).clamp(0.0, 10.0);

      if (radius > 0) {
        canvas.drawCircle(Offset(x, y - animationValue * 50), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Magic effect painter for transformation animations
class MagicEffectPainter extends CustomPainter {
  final double animationValue;

  MagicEffectPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw expanding circles with safe opacity values
    for (int i = 0; i < 3; i++) {
      final radius = (animationValue * (50 + i * 20)).clamp(0.0, size.width);
      final opacity = ((1 - animationValue) * 0.6).clamp(0.0, 1.0);

      // Use const color with safe opacity
      final paint =
          Paint()
            ..color = const Color(0xFFFFD700).withOpacity(opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      if (radius > 0 && radius < size.width && radius < size.height) {
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Enhanced custom painter that draws a stylized cat with dynamic attributes and animations
class EnhancedCatPainter extends CustomPainter {
  final Color color;
  final String? texture;
  final String? feeling;
  final String? personality;
  final double animationValue;

  EnhancedCatPainter({
    required this.color,
    this.texture,
    this.feeling,
    this.personality,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2 + 20);
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Add subtle animation glow
    if (animationValue > 0) {
      final safeOpacity = (animationValue * 0.3).clamp(0.0, 1.0);
      final glowPaint =
          Paint()
            ..color = const Color(0xFFFFD700).withOpacity(safeOpacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 180, height: 120),
        glowPaint,
      );
    }

    // Draw body with animation scale
    final bodyScale = 1.0 + animationValue * 0.1;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 160 * bodyScale,
        height: 100 * bodyScale,
      ),
      paint,
    );

    // Head
    canvas.drawCircle(Offset(center.dx, center.dy - 60), 40 * bodyScale, paint);

    // Enhanced features
    _drawEar(canvas, center, true, bodyScale);
    _drawEar(canvas, center, false, bodyScale);
    _drawLeg(canvas, center.translate(-30, 40), bodyScale);
    _drawLeg(canvas, center.translate(30, 40), bodyScale);
    _drawTail(canvas, center, bodyScale);
    _drawEnhancedFace(canvas, center, bodyScale);
    _drawWhiskers(canvas, center, bodyScale);
    _drawEnhancedTexture(canvas, center, bodyScale);
    _drawPersonalityFeatures(canvas, center, bodyScale);
  }

  void _drawEar(Canvas canvas, Offset c, bool isLeft, double scale) {
    final offsetX = (isLeft ? -30.0 : 30.0) * scale;
    final earPaint = Paint()..color = color;

    final earPath =
        Path()
          ..moveTo(c.dx + offsetX, c.dy - 90 * scale)
          ..lineTo(c.dx + offsetX * 1.3, c.dy - 120 * scale)
          ..lineTo(c.dx + offsetX * 0.3, c.dy - 100 * scale)
          ..close();
    canvas.drawPath(earPath, earPaint);

    // Inner ear
    final innerPaint = Paint()..color = Colors.pink[200]!;
    final innerPath =
        Path()
          ..moveTo(c.dx + offsetX, c.dy - 95 * scale)
          ..lineTo(c.dx + offsetX * 1.1, c.dy - 110 * scale)
          ..lineTo(c.dx + offsetX * 0.5, c.dy - 105 * scale)
          ..close();
    canvas.drawPath(innerPath, innerPaint);
  }

  void _drawLeg(Canvas canvas, Offset pos, double scale) {
    final legPaint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 20 * scale, height: 40 * scale),
        Radius.circular(10 * scale),
      ),
      legPaint,
    );

    // Add paw details
    final pawPaint = Paint()..color = Colors.pink[100]!;
    canvas.drawCircle(Offset(pos.dx, pos.dy + 15 * scale), 6 * scale, pawPaint);
  }

  void _drawTail(Canvas canvas, Offset c, double scale) {
    final tailPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8 * scale;

    final tail =
        Path()
          ..moveTo(c.dx + 70 * scale, c.dy + 10)
          ..quadraticBezierTo(
            c.dx + 100 * scale,
            c.dy - 20,
            c.dx + 80 * scale,
            c.dy - 40 * scale,
          );
    canvas.drawPath(tail, tailPaint);

    // Add tail tip
    final tipPaint = Paint()..color = color;
    canvas.drawCircle(
      Offset(c.dx + 80 * scale, c.dy - 40 * scale),
      5 * scale,
      tipPaint,
    );
  }

  void _drawEnhancedFace(Canvas canvas, Offset c, double scale) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final mouthPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    final eyeY = c.dy - 60 * scale;
    final dx = 15.0 * scale;

    // Enhanced eyes based on feeling
    double eyeHeight = 12 * scale;
    if (feeling == 'sleepy') eyeHeight = 6 * scale;
    if (feeling == 'surprised') eyeHeight = 16 * scale;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx - dx, eyeY),
        width: 15 * scale,
        height: eyeHeight,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx + dx, eyeY),
        width: 15 * scale,
        height: eyeHeight,
      ),
      eyePaint,
    );

    // Enhanced pupils
    double pupilSize = 4 * scale;
    if (feeling == 'surprised') pupilSize = 2 * scale;
    if (feeling == 'sleepy') pupilSize = 1 * scale;

    canvas.drawCircle(Offset(c.dx - dx, eyeY), pupilSize, pupilPaint);
    canvas.drawCircle(Offset(c.dx + dx, eyeY), pupilSize, pupilPaint);

    // Enhanced mouth expressions
    _drawMouthExpression(canvas, c, scale, mouthPaint);

    // Add nose
    final nosePaint = Paint()..color = Colors.pink;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy - 50 * scale),
        width: 6 * scale,
        height: 4 * scale,
      ),
      nosePaint,
    );
  }

  void _drawMouthExpression(
    Canvas canvas,
    Offset c,
    double scale,
    Paint mouthPaint,
  ) {
    switch (feeling) {
      case 'happy':
        final path =
            Path()
              ..moveTo(c.dx - 10 * scale, c.dy - 45 * scale)
              ..quadraticBezierTo(
                c.dx,
                c.dy - 30 * scale,
                c.dx + 10 * scale,
                c.dy - 45 * scale,
              );
        canvas.drawPath(path, mouthPaint);
        break;
      case 'sad':
        final path =
            Path()
              ..moveTo(c.dx - 10 * scale, c.dy - 40 * scale)
              ..quadraticBezierTo(
                c.dx,
                c.dy - 50 * scale,
                c.dx + 10 * scale,
                c.dy - 40 * scale,
              );
        canvas.drawPath(path, mouthPaint);
        break;
      case 'surprised':
        final surprisedPaint = Paint()..color = Colors.black;
        canvas.drawCircle(
          Offset(c.dx, c.dy - 45 * scale),
          5 * scale,
          surprisedPaint,
        );
        break;
      case 'playful':
        // Draw tongue out
        final tonguePaint = Paint()..color = Colors.pink;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(c.dx + 3 * scale, c.dy - 40 * scale),
            width: 8 * scale,
            height: 6 * scale,
          ),
          tonguePaint,
        );
        break;
      default:
        // Simple line mouth
        canvas.drawLine(
          Offset(c.dx - 6 * scale, c.dy - 42 * scale),
          Offset(c.dx + 6 * scale, c.dy - 42 * scale),
          mouthPaint,
        );
    }
  }

  void _drawWhiskers(Canvas canvas, Offset c, double scale) {
    final whiskerPaint =
        Paint()
          ..color = Colors.black87
          ..strokeWidth = 1.5 * scale;

    for (int sign in [1, -1]) {
      // Multiple whiskers on each side
      for (int i = 0; i < 3; i++) {
        final yOffset = i * 6 - 6;
        canvas.drawLine(
          Offset(c.dx + sign * 15 * scale, c.dy - 45 * scale + yOffset),
          Offset(c.dx + sign * 35 * scale, c.dy - 40 * scale + yOffset),
          whiskerPaint,
        );
      }
    }
  }

  void _drawEnhancedTexture(Canvas canvas, Offset c, double scale) {
    switch (texture) {
      case 'fluffy':
        final paint = Paint()..color = Colors.white.withOpacity(0.5);
        for (double a = 0; a < 360; a += 20) {
          final ang = a * pi / 180;
          final r = (60 + sin(a / 30) * 8) * scale;
          final x = c.dx + r * cos(ang);
          final y = c.dy + r * sin(ang);
          canvas.drawCircle(Offset(x, y), 4 * scale, paint);
        }
        break;
      case 'silky':
        final paint =
            Paint()
              ..color = Colors.white.withOpacity(0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5 * scale;
        for (int i = 0; i < 3; i++) {
          canvas.drawOval(
            Rect.fromCenter(
              center: c,
              width: (120 + i * 15) * scale,
              height: (80 + i * 10) * scale,
            ),
            paint,
          );
        }
        break;
      case 'woolly':
        final paint = Paint()..color = Colors.grey.withOpacity(0.4);
        for (int i = 0; i < 20; i++) {
          final x = c.dx - 60 * scale + (i % 8) * 15 * scale;
          final y = c.dy - 30 * scale + (i ~/ 8) * 15 * scale;
          canvas.drawCircle(Offset(x, y), 3 * scale, paint);
        }
        break;
    }
  }

  void _drawPersonalityFeatures(Canvas canvas, Offset c, double scale) {
    switch (personality) {
      case 'lazy':
        // Draw sleepy lines around eyes
        final sleepPaint =
            Paint()
              ..color = Colors.black54
              ..strokeWidth = 1.5 * scale;
        for (int i = 0; i < 3; i++) {
          canvas.drawLine(
            Offset(c.dx - 25 * scale, c.dy - 70 * scale + i * 4),
            Offset(c.dx - 20 * scale, c.dy - 65 * scale + i * 4),
            sleepPaint,
          );
        }
        break;
      case 'energetic':
        // Draw energy sparks
        final sparkPaint =
            Paint()
              ..color = const Color(0xFFFFD700)
              ..strokeWidth = 2 * scale;
        for (int i = 0; i < 6; i++) {
          final angle = i * pi / 3;
          final startX = c.dx + 45 * scale * cos(angle);
          final startY = c.dy - 45 * scale + 30 * scale * sin(angle);
          final endX = startX + 10 * scale * cos(angle);
          final endY = startY + 10 * scale * sin(angle);
          canvas.drawLine(
            Offset(startX, startY),
            Offset(endX, endY),
            sparkPaint,
          );
        }
        break;
      case 'brave':
        // Draw a cape
        final capePaint =
            Paint()..color = const Color(0xFFEF4444).withOpacity(0.8);
        final capePath =
            Path()
              ..moveTo(c.dx - 25 * scale, c.dy - 45 * scale)
              ..lineTo(c.dx - 50 * scale, c.dy + 30 * scale)
              ..lineTo(c.dx - 35 * scale, c.dy + 40 * scale)
              ..lineTo(c.dx - 15 * scale, c.dy + 15 * scale)
              ..close();
        canvas.drawPath(capePath, capePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

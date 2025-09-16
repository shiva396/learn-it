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
    {
      'name': 'black',
      'color': Colors.black87,
      'rgb': [30, 30, 35],
    },
    {
      'name': 'white',
      'color': Colors.grey[200],
      'rgb': [245, 245, 250],
    },
    {
      'name': 'orange',
      'color': Colors.orange[600],
      'rgb': [255, 152, 0],
    },
    {
      'name': 'grey',
      'color': Colors.grey[600],
      'rgb': [117, 117, 117],
    },
    {
      'name': 'brown',
      'color': Colors.brown[400],
      'rgb': [141, 110, 99],
    },
    {
      'name': 'blue',
      'color': LColors.blue,
      'rgb': [10, 132, 255],
    },
    {
      'name': 'calico',
      'color': Colors.orange[300],
      'rgb': [255, 183, 77],
    },
    {
      'name': 'tabby',
      'color': Colors.brown[300],
      'rgb': [161, 136, 127],
    },
  ];

  final List<Map<String, dynamic>> sizes = [
    {'name': 'tiny', 'scale': 0.5, 'description': 'Adorable kitten size'},
    {'name': 'small', 'scale': 0.7, 'description': 'Young cat size'},
    {'name': 'normal', 'scale': 1.0, 'description': 'Perfect adult size'},
    {'name': 'big', 'scale': 1.3, 'description': 'Large and majestic'},
    {'name': 'huge', 'scale': 1.6, 'description': 'Maine Coon size'},
    {'name': 'gigantic', 'scale': 2.0, 'description': 'Lion-like presence'},
  ];

  final List<Map<String, dynamic>> textures = [
    {'name': 'fluffy', 'description': 'Soft cloud-like fur', 'effect': 'puffy'},
    {
      'name': 'smooth',
      'description': 'Sleek and shiny coat',
      'effect': 'glossy',
    },
    {
      'name': 'long-haired',
      'description': 'Luxurious flowing fur',
      'effect': 'flowing',
    },
    {
      'name': 'short-haired',
      'description': 'Neat and tidy coat',
      'effect': 'neat',
    },
    {
      'name': 'silky',
      'description': 'Ultra smooth and soft',
      'effect': 'shimmer',
    },
    {'name': 'curly', 'description': 'Adorably curled fur', 'effect': 'wavy'},
  ];

  final List<Map<String, dynamic>> feelings = [
    {
      'name': 'happy',
      'description': 'Joyful and content',
      'eyes': 'squinting',
      'mouth': 'smiling',
      'ears': 'forward',
      'tail': 'up',
      'pose': 'relaxed',
    },
    {
      'name': 'sad',
      'description': 'Melancholy and down',
      'eyes': 'droopy',
      'mouth': 'frown',
      'ears': 'back',
      'tail': 'down',
      'pose': 'hunched',
    },
    {
      'name': 'angry',
      'description': 'Furious and mad',
      'eyes': 'narrow',
      'mouth': 'hissing',
      'ears': 'flat',
      'tail': 'puffed',
      'pose': 'arched',
    },
    {
      'name': 'surprised',
      'description': 'Shocked and amazed',
      'eyes': 'wide',
      'mouth': 'open',
      'ears': 'alert',
      'tail': 'straight',
      'pose': 'alert',
    },
    {
      'name': 'sleepy',
      'description': 'Tired and drowsy',
      'eyes': 'closed',
      'mouth': 'relaxed',
      'ears': 'relaxed',
      'tail': 'curled',
      'pose': 'lying',
    },
    {
      'name': 'playful',
      'description': 'Fun and energetic',
      'eyes': 'bright',
      'mouth': 'open',
      'ears': 'perked',
      'tail': 'twitching',
      'pose': 'crouched',
    },
    {
      'name': 'curious',
      'description': 'Interested and alert',
      'eyes': 'wide',
      'mouth': 'slightly_open',
      'ears': 'forward',
      'tail': 'question_mark',
      'pose': 'sitting',
    },
    {
      'name': 'scared',
      'description': 'Frightened and nervous',
      'eyes': 'wide',
      'mouth': 'closed',
      'ears': 'back',
      'tail': 'between_legs',
      'pose': 'crouched_low',
    },
  ];

  // State variables
  String? selectedColor;
  String? selectedSize;
  String? selectedTexture;
  String? selectedFeeling;
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
                                painter: RealisticCatPainter(
                                  color: _getColorFromAdjective(selectedColor),
                                  texture: selectedTexture,
                                  feeling: selectedFeeling,
                                  animationValue: _magicAnim.value,
                                  scale: _getScaleFromSize(selectedSize),
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

  // Helper function to determine correct article (a/an)
  String _getCorrectArticle(String word) {
    if (word.isEmpty) return 'a';

    // Words that start with vowel sounds
    final vowelSounds = ['a', 'e', 'i', 'o', 'u'];
    final firstLetter = word.toLowerCase()[0];

    // Special cases for words that start with 'u' but have consonant sound
    if (word.toLowerCase().startsWith('un')) {
      return 'an'; // uniform, unusual, etc.
    }

    // Special cases for 'h' words
    if (firstLetter == 'h') {
      // Silent 'h' words use 'an'
      final silentHWords = ['hour', 'honest', 'honor', 'heir'];
      if (silentHWords.any(
        (silentWord) => word.toLowerCase().startsWith(silentWord),
      )) {
        return 'an';
      }
      return 'a'; // most 'h' words use 'a'
    }

    return vowelSounds.contains(firstLetter) ? 'an' : 'a';
  }

  // Enhanced sentence builder with proper grammar
  String _buildEnhancedSentence(List<String> adjectives) {
    if (adjectives.isEmpty) {
      return 'This is just a plain, ordinary cat waiting for your magic!';
    }

    if (adjectives.length == 1) {
      final article = _getCorrectArticle(adjectives[0]);
      return 'This is $article ${adjectives[0]} cat!';
    }

    if (adjectives.length <= 3) {
      final article = _getCorrectArticle(adjectives[0]);
      return 'This is $article ${adjectives.join(', ')} cat!';
    }

    final article = _getCorrectArticle(adjectives[0]);
    return 'This is $article ${adjectives.sublist(0, adjectives.length - 1).join(', ')}, and ${adjectives.last} cat!';
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
        (category == 'feeling' && selectedFeeling == value);
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
class RealisticCatPainter extends CustomPainter {
  final Color color;
  final String? texture;
  final String? feeling;
  final double animationValue;
  final double scale;

  RealisticCatPainter({
    required this.color,
    this.texture,
    this.feeling,
    required this.animationValue,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final bodyScale = scale * (1.0 + animationValue * 0.15);

    // Enhanced glow effect for magical moments
    if (animationValue > 0) {
      _drawMagicalGlow(canvas, center, bodyScale);
    }

    // Draw cat components in realistic order (back to front)
    _drawTail(canvas, center, bodyScale);
    _drawBackLegs(canvas, center, bodyScale);
    _drawBody(canvas, center, bodyScale);
    _drawFrontLegs(canvas, center, bodyScale);
    _drawNeck(canvas, center, bodyScale);
    _drawHead(canvas, center, bodyScale);
    _drawEars(canvas, center, bodyScale);
    _drawFacialFeatures(canvas, center, bodyScale);
    _drawWhiskers(canvas, center, bodyScale);
    _drawTexture(canvas, center, bodyScale);
    _drawEmotionalEffects(canvas, center, bodyScale);
  }

  void _drawMagicalGlow(Canvas canvas, Offset center, double scale) {
    final glowIntensity = (animationValue * 0.4).clamp(0.0, 1.0);

    // Outer glow
    final outerGlow =
        Paint()
          ..color = Colors.white.withOpacity(glowIntensity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 300 * scale, height: 200 * scale),
      outerGlow,
    );

    // Inner magical sparkle
    final innerGlow =
        Paint()
          ..color = color.withOpacity(glowIntensity * 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 220 * scale, height: 150 * scale),
      innerGlow,
    );
  }

  void _drawBody(Canvas canvas, Offset center, double scale) {
    final bodyPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Main body - more realistic oval shape
    final bodyRect = Rect.fromCenter(
      center: center.translate(0, 10 * scale),
      width: 180 * scale,
      height: 120 * scale,
    );
    canvas.drawOval(bodyRect, bodyPaint);

    // Chest area - lighter color for depth
    final chestPaint =
        Paint()
          ..color = _lightenColor(color, 0.1)
          ..style = PaintingStyle.fill;

    final chestRect = Rect.fromCenter(
      center: center.translate(0, -5 * scale),
      width: 120 * scale,
      height: 80 * scale,
    );
    canvas.drawOval(chestRect, chestPaint);

    // Belly marking (if appropriate)
    if (color != Colors.white && color != Colors.grey[200]) {
      final bellyPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.8)
            ..style = PaintingStyle.fill;

      final bellyRect = Rect.fromCenter(
        center: center.translate(0, 25 * scale),
        width: 100 * scale,
        height: 60 * scale,
      );
      canvas.drawOval(bellyRect, bellyPaint);
    }
  }

  void _drawHead(Canvas canvas, Offset center, double scale) {
    final headCenter = center.translate(0, -80 * scale);
    final headPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Main head - more realistic proportions
    canvas.drawOval(
      Rect.fromCenter(
        center: headCenter,
        width: 100 * scale,
        height: 90 * scale,
      ),
      headPaint,
    );

    // Forehead area
    final foreheadPaint =
        Paint()
          ..color = _lightenColor(color, 0.05)
          ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: headCenter.translate(0, -15 * scale),
        width: 80 * scale,
        height: 50 * scale,
      ),
      foreheadPaint,
    );

    // Muzzle area
    _drawMuzzle(canvas, headCenter, scale);
  }

  void _drawMuzzle(Canvas canvas, Offset headCenter, double scale) {
    final muzzleCenter = headCenter.translate(0, 20 * scale);
    final muzzlePaint =
        Paint()
          ..color = _lightenColor(color, 0.15)
          ..style = PaintingStyle.fill;

    // Upper muzzle
    canvas.drawOval(
      Rect.fromCenter(
        center: muzzleCenter.translate(0, -5 * scale),
        width: 45 * scale,
        height: 25 * scale,
      ),
      muzzlePaint,
    );

    // Lower muzzle
    canvas.drawOval(
      Rect.fromCenter(
        center: muzzleCenter.translate(0, 8 * scale),
        width: 35 * scale,
        height: 20 * scale,
      ),
      muzzlePaint,
    );
  }

  void _drawEars(Canvas canvas, Offset center, double scale) {
    final headCenter = center.translate(0, -80 * scale);

    // Left ear
    _drawRealisticEar(
      canvas,
      headCenter.translate(-35 * scale, -35 * scale),
      scale,
      true,
    );

    // Right ear
    _drawRealisticEar(
      canvas,
      headCenter.translate(35 * scale, -35 * scale),
      scale,
      false,
    );
  }

  void _drawRealisticEar(
    Canvas canvas,
    Offset earPos,
    double scale,
    bool isLeft,
  ) {
    final earPaint = Paint()..color = color;
    final innerEarPaint = Paint()..color = Colors.pink[200]!;

    // Adjust ear position based on emotion
    final emotionOffset = _getEarEmotionOffset();
    final adjustedPos = earPos.translate(
      emotionOffset.dx * scale,
      emotionOffset.dy * scale,
    );

    // Outer ear shape - more realistic triangular shape
    final earPath =
        Path()
          ..moveTo(adjustedPos.dx, adjustedPos.dy + 20 * scale)
          ..lineTo(
            adjustedPos.dx + (isLeft ? -15 : 15) * scale,
            adjustedPos.dy - 25 * scale,
          )
          ..lineTo(
            adjustedPos.dx + (isLeft ? 20 : -20) * scale,
            adjustedPos.dy - 10 * scale,
          )
          ..close();
    canvas.drawPath(earPath, earPaint);

    // Inner ear
    final innerEarPath =
        Path()
          ..moveTo(adjustedPos.dx, adjustedPos.dy + 15 * scale)
          ..lineTo(
            adjustedPos.dx + (isLeft ? -8 : 8) * scale,
            adjustedPos.dy - 15 * scale,
          )
          ..lineTo(
            adjustedPos.dx + (isLeft ? 12 : -12) * scale,
            adjustedPos.dy - 5 * scale,
          )
          ..close();
    canvas.drawPath(innerEarPath, innerEarPaint);

    // Ear tufts for certain textures
    if (texture == 'fluffy' || texture == 'long-haired') {
      _drawEarTufts(canvas, adjustedPos, scale, isLeft);
    }
  }

  void _drawEarTufts(Canvas canvas, Offset earPos, double scale, bool isLeft) {
    final tuftPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    for (int i = 0; i < 3; i++) {
      final tuftPath =
          Path()
            ..moveTo(
              earPos.dx + (isLeft ? -10 : 10) * scale,
              earPos.dy - 20 * scale,
            )
            ..lineTo(
              earPos.dx + (isLeft ? -15 : 15) * scale + i * 2,
              earPos.dy - 30 * scale,
            );
      canvas.drawPath(tuftPath, tuftPaint);
    }
  }

  void _drawFacialFeatures(Canvas canvas, Offset center, double scale) {
    final headCenter = center.translate(0, -80 * scale);

    // Draw eyes based on emotion
    _drawRealisticEyes(canvas, headCenter, scale);

    // Draw nose
    _drawNose(canvas, headCenter.translate(0, 10 * scale), scale);

    // Draw mouth based on emotion
    _drawMouth(canvas, headCenter.translate(0, 25 * scale), scale);
  }

  void _drawRealisticEyes(Canvas canvas, Offset headCenter, double scale) {
    final eyeStyle = _getEyeStyle();
    final leftEyePos = headCenter.translate(-20 * scale, -15 * scale);
    final rightEyePos = headCenter.translate(20 * scale, -15 * scale);

    _drawSingleEye(canvas, leftEyePos, scale, eyeStyle);
    _drawSingleEye(canvas, rightEyePos, scale, eyeStyle);
  }

  void _drawSingleEye(
    Canvas canvas,
    Offset eyePos,
    double scale,
    Map<String, dynamic> style,
  ) {
    final eyeWhitePaint = Paint()..color = Colors.white;
    final eyeColorPaint = Paint()..color = Colors.green[600]!;
    final pupilPaint = Paint()..color = Colors.black;

    switch (style['type']) {
      case 'normal':
        // Almond-shaped eye
        canvas.drawOval(
          Rect.fromCenter(
            center: eyePos,
            width: 18 * scale,
            height: 12 * scale,
          ),
          eyeWhitePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: eyePos,
            width: 12 * scale,
            height: 12 * scale,
          ),
          eyeColorPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: eyePos, width: 4 * scale, height: 8 * scale),
          pupilPaint,
        );
        break;

      case 'wide':
        // Wide surprised eyes
        canvas.drawCircle(eyePos, 12 * scale, eyeWhitePaint);
        canvas.drawCircle(eyePos, 10 * scale, eyeColorPaint);
        canvas.drawCircle(eyePos, 6 * scale, pupilPaint);
        break;

      case 'squinting':
        // Happy squinting eyes
        final squintPath =
            Path()
              ..moveTo(eyePos.dx - 12 * scale, eyePos.dy)
              ..quadraticBezierTo(
                eyePos.dx,
                eyePos.dy - 4 * scale,
                eyePos.dx + 12 * scale,
                eyePos.dy,
              )
              ..quadraticBezierTo(
                eyePos.dx,
                eyePos.dy + 2 * scale,
                eyePos.dx - 12 * scale,
                eyePos.dy,
              );
        canvas.drawPath(squintPath, eyeColorPaint);
        break;

      case 'droopy':
        // Sad droopy eyes
        canvas.drawOval(
          Rect.fromCenter(
            center: eyePos.translate(0, 2 * scale),
            width: 16 * scale,
            height: 10 * scale,
          ),
          eyeWhitePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: eyePos.translate(0, 2 * scale),
            width: 10 * scale,
            height: 8 * scale,
          ),
          eyeColorPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: eyePos.translate(0, 3 * scale),
            width: 3 * scale,
            height: 6 * scale,
          ),
          pupilPaint,
        );
        break;

      case 'narrow':
        // Angry narrow eyes
        canvas.drawOval(
          Rect.fromCenter(center: eyePos, width: 20 * scale, height: 6 * scale),
          eyeWhitePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: eyePos, width: 14 * scale, height: 4 * scale),
          eyeColorPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: eyePos, width: 2 * scale, height: 4 * scale),
          pupilPaint,
        );
        break;

      case 'closed':
        // Sleeping closed eyes
        final closedPath =
            Path()
              ..moveTo(eyePos.dx - 10 * scale, eyePos.dy)
              ..quadraticBezierTo(
                eyePos.dx,
                eyePos.dy + 2 * scale,
                eyePos.dx + 10 * scale,
                eyePos.dy,
              );
        final eyeLidPaint =
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3 * scale;
        canvas.drawPath(closedPath, eyeLidPaint);
        break;
    }

    // Add eye shine for living eyes
    if (style['type'] != 'closed') {
      final shinePaint = Paint()..color = Colors.white.withOpacity(0.8);
      canvas.drawCircle(
        eyePos.translate(-2 * scale, -2 * scale),
        2 * scale,
        shinePaint,
      );
    }
  }

  void _drawNose(Canvas canvas, Offset nosePos, double scale) {
    final nosePaint = Paint()..color = Colors.pink[300]!;

    // Heart-shaped nose
    final nosePath =
        Path()
          ..moveTo(nosePos.dx, nosePos.dy + 3 * scale)
          ..quadraticBezierTo(
            nosePos.dx - 4 * scale,
            nosePos.dy - 2 * scale,
            nosePos.dx - 2 * scale,
            nosePos.dy - 4 * scale,
          )
          ..quadraticBezierTo(
            nosePos.dx,
            nosePos.dy - 6 * scale,
            nosePos.dx + 2 * scale,
            nosePos.dy - 4 * scale,
          )
          ..quadraticBezierTo(
            nosePos.dx + 4 * scale,
            nosePos.dy - 2 * scale,
            nosePos.dx,
            nosePos.dy + 3 * scale,
          );

    canvas.drawPath(nosePath, nosePaint);

    // Nose highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.6);
    canvas.drawCircle(
      nosePos.translate(-1 * scale, -2 * scale),
      1 * scale,
      highlightPaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset mouthPos, double scale) {
    final mouthStyle = _getMouthStyle();
    final mouthPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale
          ..strokeCap = StrokeCap.round;

    switch (mouthStyle) {
      case 'smiling':
        // Happy curved mouth
        final smilePath =
            Path()
              ..moveTo(mouthPos.dx - 8 * scale, mouthPos.dy)
              ..quadraticBezierTo(
                mouthPos.dx,
                mouthPos.dy + 4 * scale,
                mouthPos.dx + 8 * scale,
                mouthPos.dy,
              );
        canvas.drawPath(smilePath, mouthPaint);
        break;

      case 'frown':
        // Sad frown
        final frownPath =
            Path()
              ..moveTo(mouthPos.dx - 6 * scale, mouthPos.dy + 3 * scale)
              ..quadraticBezierTo(
                mouthPos.dx,
                mouthPos.dy - 2 * scale,
                mouthPos.dx + 6 * scale,
                mouthPos.dy + 3 * scale,
              );
        canvas.drawPath(frownPath, mouthPaint);
        break;

      case 'open':
        // Surprised/playful open mouth
        canvas.drawOval(
          Rect.fromCenter(
            center: mouthPos,
            width: 6 * scale,
            height: 8 * scale,
          ),
          Paint()..color = Colors.black,
        );
        break;

      case 'hissing':
        // Angry hissing
        final hissPath =
            Path()
              ..moveTo(mouthPos.dx - 10 * scale, mouthPos.dy)
              ..lineTo(mouthPos.dx - 3 * scale, mouthPos.dy - 3 * scale)
              ..lineTo(mouthPos.dx, mouthPos.dy)
              ..lineTo(mouthPos.dx + 3 * scale, mouthPos.dy - 3 * scale)
              ..lineTo(mouthPos.dx + 10 * scale, mouthPos.dy);
        canvas.drawPath(hissPath, mouthPaint);
        break;

      default:
        // Neutral mouth
        canvas.drawLine(
          mouthPos.translate(-4 * scale, 0),
          mouthPos.translate(4 * scale, 0),
          mouthPaint,
        );
    }
  }

  void _drawWhiskers(Canvas canvas, Offset center, double scale) {
    final headCenter = center.translate(0, -80 * scale);
    final whiskerPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * scale
          ..strokeCap = StrokeCap.round;

    // Left whiskers
    for (int i = 0; i < 3; i++) {
      final startY = headCenter.dy + (i - 1) * 8 * scale;
      canvas.drawLine(
        Offset(headCenter.dx - 25 * scale, startY),
        Offset(headCenter.dx - 55 * scale, startY + (i - 1) * 3 * scale),
        whiskerPaint,
      );
    }

    // Right whiskers
    for (int i = 0; i < 3; i++) {
      final startY = headCenter.dy + (i - 1) * 8 * scale;
      canvas.drawLine(
        Offset(headCenter.dx + 25 * scale, startY),
        Offset(headCenter.dx + 55 * scale, startY + (i - 1) * 3 * scale),
        whiskerPaint,
      );
    }
  }

  void _drawNeck(Canvas canvas, Offset center, double scale) {
    final neckPaint = Paint()..color = color;

    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, -40 * scale),
        width: 60 * scale,
        height: 40 * scale,
      ),
      neckPaint,
    );
  }

  void _drawFrontLegs(Canvas canvas, Offset center, double scale) {
    // Left front leg - positioned more naturally under the chest
    _drawRealisticLeg(canvas, center.translate(-30 * scale, 50 * scale), scale);
    // Right front leg - slightly forward and to the right
    _drawRealisticLeg(canvas, center.translate(-10 * scale, 55 * scale), scale);
  }

  void _drawBackLegs(Canvas canvas, Offset center, double scale) {
    // Left back leg - positioned more naturally under the body
    _drawRealisticLeg(canvas, center.translate(20 * scale, 50 * scale), scale);
    // Right back leg - slightly back and to the right
    _drawRealisticLeg(canvas, center.translate(45 * scale, 45 * scale), scale);
  }

  void _drawRealisticLeg(Canvas canvas, Offset legPos, double scale) {
    final legPaint = Paint()..color = color;
    final pawPaint = Paint()..color = _darkenColor(color, 0.1);

    // Upper leg
    canvas.drawOval(
      Rect.fromCenter(
        center: legPos.translate(0, -10 * scale),
        width: 18 * scale,
        height: 35 * scale,
      ),
      legPaint,
    );

    // Lower leg/paw
    canvas.drawOval(
      Rect.fromCenter(
        center: legPos.translate(0, 15 * scale),
        width: 15 * scale,
        height: 25 * scale,
      ),
      legPaint,
    );

    // Paw pad
    canvas.drawOval(
      Rect.fromCenter(
        center: legPos.translate(0, 25 * scale),
        width: 12 * scale,
        height: 8 * scale,
      ),
      pawPaint,
    );

    // Toe beans
    final toePaint = Paint()..color = Colors.pink[200]!;
    for (int i = 0; i < 4; i++) {
      final toeX = legPos.dx + (i - 1.5) * 3 * scale;
      canvas.drawCircle(
        Offset(toeX, legPos.dy + 22 * scale),
        1.5 * scale,
        toePaint,
      );
    }
  }

  void _drawTail(Canvas canvas, Offset center, double scale) {
    final tailPosition = _getTailPosition();
    final tailPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12 * scale
          ..strokeCap = StrokeCap.round;

    Path tailPath;

    switch (tailPosition) {
      case 'up':
        // Happy high tail
        tailPath =
            Path()
              ..moveTo(center.dx + 80 * scale, center.dy + 20 * scale)
              ..quadraticBezierTo(
                center.dx + 100 * scale,
                center.dy - 40 * scale,
                center.dx + 90 * scale,
                center.dy - 80 * scale,
              );
        break;

      case 'down':
        // Sad low tail
        tailPath =
            Path()
              ..moveTo(center.dx + 80 * scale, center.dy + 20 * scale)
              ..quadraticBezierTo(
                center.dx + 120 * scale,
                center.dy + 60 * scale,
                center.dx + 140 * scale,
                center.dy + 80 * scale,
              );
        break;

      case 'puffed':
        // Angry puffed tail
        final puffedPaint =
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 20 * scale
              ..strokeCap = StrokeCap.round;
        tailPath =
            Path()
              ..moveTo(center.dx + 80 * scale, center.dy + 20 * scale)
              ..quadraticBezierTo(
                center.dx + 110 * scale,
                center.dy - 10 * scale,
                center.dx + 130 * scale,
                center.dy - 20 * scale,
              );
        canvas.drawPath(tailPath, puffedPaint);
        return;

      case 'question_mark':
        // Curious question mark tail
        tailPath =
            Path()
              ..moveTo(center.dx + 80 * scale, center.dy + 20 * scale)
              ..quadraticBezierTo(
                center.dx + 100 * scale,
                center.dy - 30 * scale,
                center.dx + 85 * scale,
                center.dy - 50 * scale,
              )
              ..quadraticBezierTo(
                center.dx + 70 * scale,
                center.dy - 60 * scale,
                center.dx + 75 * scale,
                center.dy - 70 * scale,
              );
        break;

      default:
        // Normal relaxed tail
        tailPath =
            Path()
              ..moveTo(center.dx + 80 * scale, center.dy + 20 * scale)
              ..quadraticBezierTo(
                center.dx + 120 * scale,
                center.dy + 10 * scale,
                center.dx + 140 * scale,
                center.dy + 30 * scale,
              );
    }

    canvas.drawPath(tailPath, tailPaint);

    // Add tail rings for tabby patterns
    if (color == Colors.brown[400] || texture == 'tabby') {
      _drawTailRings(canvas, tailPath, scale);
    }
  }

  void _drawTailRings(Canvas canvas, Path tailPath, double scale) {
    final ringPaint =
        Paint()
          ..color = _darkenColor(color, 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * scale;

    // Draw rings along the tail
    for (int i = 0; i < 3; i++) {
      final ringPath = Path();
      ringPath.addOval(
        Rect.fromCircle(
          center: Offset(0, -20.0 * scale * (i + 1)),
          radius: 8 * scale,
        ),
      );
      canvas.drawPath(ringPath, ringPaint);
    }
  }

  void _drawTexture(Canvas canvas, Offset center, double scale) {
    switch (texture) {
      case 'fluffy':
        _drawFluffyTexture(canvas, center, scale);
        break;
      case 'smooth':
        _drawSmoothTexture(canvas, center, scale);
        break;
      case 'long-haired':
        _drawLongHairTexture(canvas, center, scale);
        break;
      case 'silky':
        _drawSilkyTexture(canvas, center, scale);
        break;
      case 'curly':
        _drawCurlyTexture(canvas, center, scale);
        break;
    }
  }

  void _drawFluffyTexture(Canvas canvas, Offset center, double scale) {
    final fluffPaint =
        Paint()
          ..color = _lightenColor(color, 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1 * scale;

    final random = Random(42);
    for (int i = 0; i < 30; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = 40 + random.nextDouble() * 60;
      final startPoint = center.translate(
        cos(angle) * radius * scale,
        sin(angle) * radius * scale,
      );
      final endPoint = startPoint.translate(
        cos(angle) * 8 * scale,
        sin(angle) * 8 * scale,
      );
      canvas.drawLine(startPoint, endPoint, fluffPaint);
    }
  }

  void _drawSmoothTexture(Canvas canvas, Offset center, double scale) {
    // Add subtle shine lines
    final shinePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    for (int i = 0; i < 3; i++) {
      final y = center.dy - 20 + i * 20;
      canvas.drawLine(
        Offset(center.dx - 60 * scale, y * scale),
        Offset(center.dx + 60 * scale, y * scale),
        shinePaint,
      );
    }
  }

  void _drawLongHairTexture(Canvas canvas, Offset center, double scale) {
    final hairPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    // Draw flowing hair strands
    for (int i = 0; i < 15; i++) {
      final startX = center.dx - 80 + i * 12;
      final hairPath =
          Path()
            ..moveTo(startX * scale, center.dy * scale)
            ..quadraticBezierTo(
              (startX + 5) * scale,
              (center.dy + 20) * scale,
              (startX + 10) * scale,
              (center.dy + 30) * scale,
            );
      canvas.drawPath(hairPath, hairPaint);
    }
  }

  void _drawSilkyTexture(Canvas canvas, Offset center, double scale) {
    // Add subtle gradient effect
    final gradientPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [color, _lightenColor(color, 0.3), color],
          ).createShader(
            Rect.fromCenter(
              center: center,
              width: 200 * scale,
              height: 150 * scale,
            ),
          );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 180 * scale, height: 120 * scale),
      gradientPaint,
    );
  }

  void _drawCurlyTexture(Canvas canvas, Offset center, double scale) {
    final curlPaint =
        Paint()
          ..color = _darkenColor(color, 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    // Draw curly patterns
    for (int i = 0; i < 20; i++) {
      final x = center.dx + (i % 5 - 2) * 25 * scale;
      final y = center.dy + (i ~/ 5 - 2) * 20 * scale;

      final curlPath =
          Path()
            ..moveTo(x, y)
            ..quadraticBezierTo(x + 5 * scale, y - 5 * scale, x + 10 * scale, y)
            ..quadraticBezierTo(
              x + 15 * scale,
              y + 5 * scale,
              x + 20 * scale,
              y,
            );

      canvas.drawPath(curlPath, curlPaint);
    }
  }

  void _drawEmotionalEffects(Canvas canvas, Offset center, double scale) {
    switch (feeling) {
      case 'happy':
        _drawHappySparkles(canvas, center, scale);
        break;
      case 'angry':
        _drawAngerLines(canvas, center, scale);
        break;
      case 'sad':
        _drawTears(canvas, center, scale);
        break;
      case 'surprised':
        _drawShockLines(canvas, center, scale);
        break;
    }
  }

  void _drawHappySparkles(Canvas canvas, Offset center, double scale) {
    final sparklePaint = Paint()..color = Colors.yellow[400]!.withOpacity(0.8);

    for (int i = 0; i < 6; i++) {
      final sparklePos = center.translate(
        (50 + i * 20) * scale * cos(i * pi / 3),
        (50 + i * 20) * scale * sin(i * pi / 3),
      );
      _drawSparkle(canvas, sparklePos, scale, sparklePaint);
    }
  }

  void _drawAngerLines(Canvas canvas, Offset center, double scale) {
    final angerPaint =
        Paint()
          ..color = Colors.red[400]!.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * scale;

    // Anger marks above head
    final headCenter = center.translate(0, -80 * scale);
    for (int i = 0; i < 4; i++) {
      final markPos = headCenter.translate((i - 1.5) * 15 * scale, -50 * scale);
      final markPath =
          Path()
            ..moveTo(markPos.dx, markPos.dy)
            ..lineTo(markPos.dx + 5 * scale, markPos.dy - 10 * scale)
            ..moveTo(markPos.dx + 5 * scale, markPos.dy)
            ..lineTo(markPos.dx, markPos.dy - 10 * scale);
      canvas.drawPath(markPath, angerPaint);
    }
  }

  void _drawTears(Canvas canvas, Offset center, double scale) {
    final tearPaint = Paint()..color = Colors.blue[200]!.withOpacity(0.8);

    final eyePos = center.translate(0, -95 * scale);

    // Left tear
    final leftTear =
        Path()
          ..moveTo(eyePos.dx - 25 * scale, eyePos.dy)
          ..quadraticBezierTo(
            eyePos.dx - 25 * scale,
            eyePos.dy + 5 * scale,
            eyePos.dx - 20 * scale,
            eyePos.dy + 15 * scale,
          )
          ..quadraticBezierTo(
            eyePos.dx - 25 * scale,
            eyePos.dy + 20 * scale,
            eyePos.dx - 25 * scale,
            eyePos.dy + 25 * scale,
          );
    canvas.drawPath(leftTear, tearPaint);

    // Right tear
    final rightTear =
        Path()
          ..moveTo(eyePos.dx + 25 * scale, eyePos.dy)
          ..quadraticBezierTo(
            eyePos.dx + 25 * scale,
            eyePos.dy + 5 * scale,
            eyePos.dx + 20 * scale,
            eyePos.dy + 15 * scale,
          )
          ..quadraticBezierTo(
            eyePos.dx + 25 * scale,
            eyePos.dy + 20 * scale,
            eyePos.dx + 25 * scale,
            eyePos.dy + 25 * scale,
          );
    canvas.drawPath(rightTear, tearPaint);
  }

  void _drawShockLines(Canvas canvas, Offset center, double scale) {
    final shockPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * scale;

    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final start = center.translate(
        cos(angle) * 80 * scale,
        sin(angle) * 80 * scale,
      );
      final end = center.translate(
        cos(angle) * 100 * scale,
        sin(angle) * 100 * scale,
      );
      canvas.drawLine(start, end, shockPaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset pos, double scale, Paint paint) {
    // 4-pointed star sparkle
    final sparklePath =
        Path()
          ..moveTo(pos.dx, pos.dy - 4 * scale)
          ..lineTo(pos.dx + 1 * scale, pos.dy - 1 * scale)
          ..lineTo(pos.dx + 4 * scale, pos.dy)
          ..lineTo(pos.dx + 1 * scale, pos.dy + 1 * scale)
          ..lineTo(pos.dx, pos.dy + 4 * scale)
          ..lineTo(pos.dx - 1 * scale, pos.dy + 1 * scale)
          ..lineTo(pos.dx - 4 * scale, pos.dy)
          ..lineTo(pos.dx - 1 * scale, pos.dy - 1 * scale)
          ..close();

    canvas.drawPath(sparklePath, paint);
  }

  // Helper methods for emotional states
  Map<String, dynamic> _getEyeStyle() {
    switch (feeling) {
      case 'happy':
        return {'type': 'squinting'};
      case 'sad':
        return {'type': 'droopy'};
      case 'angry':
        return {'type': 'narrow'};
      case 'surprised':
        return {'type': 'wide'};
      case 'sleepy':
        return {'type': 'closed'};
      case 'curious':
        return {'type': 'wide'};
      case 'scared':
        return {'type': 'wide'};
      default:
        return {'type': 'normal'};
    }
  }

  String _getMouthStyle() {
    switch (feeling) {
      case 'happy':
        return 'smiling';
      case 'sad':
        return 'frown';
      case 'angry':
        return 'hissing';
      case 'surprised':
        return 'open';
      case 'playful':
        return 'open';
      case 'curious':
        return 'slightly_open';
      default:
        return 'neutral';
    }
  }

  String _getTailPosition() {
    switch (feeling) {
      case 'happy':
        return 'up';
      case 'sad':
        return 'down';
      case 'angry':
        return 'puffed';
      case 'curious':
        return 'question_mark';
      case 'playful':
        return 'up';
      case 'scared':
        return 'between_legs';
      default:
        return 'normal';
    }
  }

  Offset _getEarEmotionOffset() {
    switch (feeling) {
      case 'angry':
        return const Offset(0, 5); // Ears back
      case 'scared':
        return const Offset(0, 8); // Ears flat
      case 'curious':
        return const Offset(0, -3); // Ears forward
      case 'surprised':
        return const Offset(0, -5); // Ears alert
      default:
        return const Offset(0, 0);
    }
  }

  // Color manipulation helpers
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

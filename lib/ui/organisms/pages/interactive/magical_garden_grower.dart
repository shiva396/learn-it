import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learnit/services/recent_activities_service.dart';
import 'package:learnit/ui/atoms/colors.dart';

/// Enhanced interactive garden growing with adjectives - Educational game for learning descriptive words
class MagicalGardenGrowerPage extends StatefulWidget {
  const MagicalGardenGrowerPage({Key? key}) : super(key: key);

  @override
  State<MagicalGardenGrowerPage> createState() =>
      _MagicalGardenGrowerPageState();
}

class _MagicalGardenGrowerPageState extends State<MagicalGardenGrowerPage>
    with TickerProviderStateMixin {
  // Enhanced adjective categories for garden elements
  final List<Map<String, dynamic>> colors = [
    {'name': 'red', 'color': Colors.red},
    {'name': 'yellow', 'color': Colors.yellow},
    {'name': 'blue', 'color': Colors.blue},
    {'name': 'purple', 'color': Colors.purple},
    {'name': 'pink', 'color': Colors.pink},
    {'name': 'orange', 'color': Colors.orange},
    {'name': 'white', 'color': Colors.white},
  ];

  final List<Map<String, dynamic>> sizes = [
    {'name': 'tiny', 'scale': 0.5},
    {'name': 'small', 'scale': 0.7},
    {'name': 'medium', 'scale': 1.0},
    {'name': 'large', 'scale': 1.3},
    {'name': 'huge', 'scale': 1.6},
    {'name': 'giant', 'scale': 2.0},
  ];

  final List<Map<String, dynamic>> shapes = [
    {'name': 'round', 'description': 'Circular petals'},
    {'name': 'star-shaped', 'description': 'Pointed like a star'},
    {'name': 'heart-shaped', 'description': 'Shaped like hearts'},
    {'name': 'trumpet', 'description': 'Long and tubular'},
    {'name': 'daisy-like', 'description': 'Simple and cheerful'},
    {'name': 'rose-like', 'description': 'Layered and elegant'},
  ];

  final List<Map<String, dynamic>> atmospheres = [
    {'name': 'sunny', 'description': 'Bright sunny day', 'icon': '☀️'},
    {'name': 'moonlit', 'description': 'Magical moonlit night', 'icon': '🌙'},
    {'name': 'winter', 'description': 'Snowy winter scene', 'icon': '❄️'},
    {'name': 'sunset', 'description': 'Golden sunset glow', 'icon': '🌅'},
    {'name': 'rainy', 'description': 'Gentle rain shower', 'icon': '🌧️'},
    {'name': 'starry', 'description': 'Starry night sky', 'icon': '⭐'},
  ];

  final List<Map<String, dynamic>> plantTypes = [
    {'name': 'sunflower', 'icon': '🌻'},
    {'name': 'rose', 'icon': '🌹'},
    {'name': 'tulip', 'icon': '🌷'},
    {'name': 'daisy', 'icon': '🌼'},
    {'name': 'violet', 'icon': '🌸'},
    {'name': 'lily', 'icon': '🌺'},
  ];

  // State variables
  String? selectedColor;
  String? selectedSize;
  String? selectedShape;
  String? selectedAtmosphere;
  String selectedPlantType = 'sunflower';
  bool _showMagic = false;
  bool _showButterflies = false;
  bool _isMuted = false;

  // Flutter TTS instance
  FlutterTts? flutterTts;
  bool _isTtsAvailable = false;

  // Animation controllers
  late AnimationController _growthController;
  late AnimationController _bloomController;
  late AnimationController _butterflyController;
  late AnimationController _sparkleController;

  // Animations
  late Animation<double> _growthAnim;
  late Animation<double> _bloomAnim;
  late Animation<double> _butterflyAnim;
  late Animation<double> _sparkleAnim;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _logActivity();

    // Initialize TTS with delay to ensure widget is built
    Future.delayed(const Duration(milliseconds: 500), () {
      _initializeTts();
    });
  }

  void _initializeTts() async {
    try {
      flutterTts = FlutterTts();
      await Future.delayed(const Duration(milliseconds: 100));
      await flutterTts!.awaitSpeakCompletion(true);

      try {
        await flutterTts!.setLanguage("en-US");
        await flutterTts!.setSpeechRate(0.6);
        await flutterTts!.setVolume(1.0);
        await flutterTts!.setPitch(1.0);
      } catch (e) {
        debugPrint('Error setting TTS properties: $e');
      }

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

      try {
        var result = await flutterTts!.speak("");
        debugPrint('TTS test result: $result');
        _isTtsAvailable = true;
      } catch (e) {
        debugPrint('TTS test error: $e');
        _isTtsAvailable = false;
      }

      debugPrint('TTS initialization completed. Available: $_isTtsAvailable');
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      _isTtsAvailable = false;
    }
  }

  void _initializeAnimations() {
    // Growth animation
    _growthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _growthAnim = CurvedAnimation(
      parent: _growthController,
      curve: Curves.easeOutBack,
    );

    // Bloom animation
    _bloomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bloomAnim = CurvedAnimation(
      parent: _bloomController,
      curve: Curves.elasticOut,
    );

    // Butterfly animation
    _butterflyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _butterflyAnim = CurvedAnimation(
      parent: _butterflyController,
      curve: Curves.easeInOut,
    );

    // Sparkle animation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _sparkleAnim = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeOutQuad,
    );
  }

  void _logActivity() async {
    await RecentActivitiesService.logGamePlayed(
      'Magical Garden Grower',
      'Adjective',
    );
  }

  @override
  void dispose() {
    _growthController.dispose();
    _bloomController.dispose();
    _butterflyController.dispose();
    _sparkleController.dispose();
    flutterTts?.stop();
    super.dispose();
  }

  // Apply adjective with haptic feedback, animations, and speech
  void _applyAdjective(String category, String value) {
    HapticFeedback.lightImpact();

    setState(() {
      _showMagic = true;
      _showButterflies = true;

      if (category == 'color') selectedColor = value;
      if (category == 'size') selectedSize = value;
      if (category == 'shape') selectedShape = value;
      if (category == 'atmosphere') selectedAtmosphere = value;
    });

    // Trigger growth animations
    _growthController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _bloomController.forward();
      _sparkleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      _butterflyController.forward();
    });

    // Speak the plant description
    _speakPlantDescription();

    // Hide effects after animations
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        setState(() {
          _showMagic = false;
          _showButterflies = false;
        });
      }
    });
  }

  void _speakPlantDescription() async {
    if (_isMuted || !_isTtsAvailable || flutterTts == null) return;

    final applied = [
      if (selectedColor != null) selectedColor!,
      if (selectedSize != null) selectedSize!,
      if (selectedShape != null) selectedShape!,
      if (selectedAtmosphere != null) selectedAtmosphere!,
    ];

    final sentence = _buildPlantSentence(applied);

    try {
      var result = await flutterTts!.speak(sentence);
      debugPrint('TTS speak result: $result');
    } catch (e) {
      debugPrint('TTS Error: $e');
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

  void _resetGarden() async {
    HapticFeedback.mediumImpact();
    setState(() {
      selectedColor = null;
      selectedSize = null;
      selectedShape = null;
      selectedAtmosphere = null;
    });

    _growthController.reset();
    _bloomController.reset();
    _butterflyController.reset();
    _sparkleController.reset();

    if (!_isMuted && _isTtsAvailable && flutterTts != null) {
      try {
        var result = await flutterTts!.speak(
          "The garden is ready for new seeds!",
        );
        debugPrint('TTS speak result: $result');
      } catch (e) {
        debugPrint('TTS Error: $e');
      }
    }
  }

  void _changePlantType(String plantType) {
    setState(() {
      selectedPlantType = plantType;
    });
    _resetGarden();
  }

  @override
  Widget build(BuildContext context) {
    final applied = [
      if (selectedColor != null) selectedColor!,
      if (selectedSize != null) selectedSize!,
      if (selectedShape != null) selectedShape!,
      if (selectedAtmosphere != null) selectedAtmosphere!,
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
          'Magical Garden Grower',
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
            onPressed: _resetGarden,
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
              // Garden display area
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen[50]!, Colors.green[50]!],
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
                      // Garden background elements (atmosphere-aware)
                      CustomPaint(
                        painter: GardenBackgroundPainter(
                          atmosphere: selectedAtmosphere,
                        ),
                        size: Size.infinite,
                      ),

                      // Animated butterflies
                      if (_showButterflies)
                        AnimatedBuilder(
                          animation: _butterflyController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: ButterflyPainter(_butterflyAnim.value),
                              size: Size.infinite,
                            );
                          },
                        ),

                      // Main plant display
                      Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _growthController,
                            _bloomController,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale:
                                  _getScaleFromSize(selectedSize) *
                                  (0.3 + _growthAnim.value * 0.7),
                              child: CustomPaint(
                                painter: RealisticPlantPainter(
                                  plantType: selectedPlantType,
                                  color: _getColorFromAdjective(selectedColor),
                                  shape: selectedShape,
                                  atmosphere: selectedAtmosphere,
                                  growthValue: _growthAnim.value,
                                  bloomValue: _bloomAnim.value,
                                ),
                                size: const Size(200, 300),
                              ),
                            );
                          },
                        ),
                      ),

                      // Magic sparkles overlay
                      if (_showMagic)
                        AnimatedBuilder(
                          animation: _sparkleController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: SparkleEffectPainter(_sparkleAnim.value),
                              size: Size.infinite,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Plant type selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: LColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: LColors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Plant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: plantTypes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final plant = plantTypes[index];
                          final isSelected = selectedPlantType == plant['name'];
                          return GestureDetector(
                            onTap: () => _changePlantType(plant['name']),
                            child: Container(
                              width: 60,
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
                                  color:
                                      isSelected
                                          ? LColors.blue
                                          : LColors.greyLight,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    plant['icon'],
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    plant['name'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : LColors.greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Plant description
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
                child: Text(
                  _buildPlantSentence(applied),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LColors.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Adjective selectors
              Expanded(
                flex: 3,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    _buildEnhancedCategory('Colors', colors, 'color'),
                    _buildEnhancedCategory('Sizes', sizes, 'size'),
                    _buildEnhancedCategory('Shapes', shapes, 'shape'),
                    _buildEnhancedCategory(
                      'Atmosphere',
                      atmospheres,
                      'atmosphere',
                    ),
                  ],
                ),
              ),

              // Instruction footer
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: LColors.blue),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_florist, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Tap adjectives to grow your magical garden!',
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

  String _buildPlantSentence(List<String> adjectives) {
    if (adjectives.isEmpty) {
      return 'Plant a seed and watch your magical $selectedPlantType grow!';
    }

    if (adjectives.length == 1) {
      return 'Look at this beautiful ${adjectives[0]} $selectedPlantType!';
    }

    if (adjectives.length <= 3) {
      return 'Look at this beautiful ${adjectives.join(', ')} $selectedPlantType!';
    }

    return 'Look at this beautiful ${adjectives.sublist(0, adjectives.length - 1).join(', ')}, and ${adjectives.last} $selectedPlantType!';
  }

  Color _getColorFromAdjective(String? color) {
    for (final colorData in colors) {
      if (colorData['name'] == color) {
        return colorData['color'] ?? Colors.red;
      }
    }
    return Colors.red;
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
        (category == 'shape' && selectedShape == value) ||
        (category == 'atmosphere' && selectedAtmosphere == value);
  }
}

/// Garden background painter for scene elements
class GardenBackgroundPainter extends CustomPainter {
  final String? atmosphere;

  GardenBackgroundPainter({this.atmosphere});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Determine colors and effects based on atmosphere
    _paintAtmosphericBackground(canvas, size);
    _drawAtmosphericElements(canvas, size);
    _drawEnhancedLandscape(canvas, size);
    _drawRealisticVegetation(canvas, size);
    _drawGardenTools(canvas, size);
  }

  void _paintAtmosphericBackground(Canvas canvas, Size size) {
    Paint skyPaint;
    Paint groundPaint;

    switch (atmosphere) {
      case 'moonlit':
        skyPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFF0B1426), // Deep night blue
                  const Color(0xFF1a237e), // Midnight blue
                  const Color(0xFF283593), // Royal blue
                  const Color(0xFF3949ab), // Lighter blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.7, 1.0],
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [const Color(0xFF2e4057), const Color(0xFF1a252f)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
        break;

      case 'winter':
        skyPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFFe8eaf6), // Light winter sky
                  const Color(0xFFc5cae9), // Soft blue-grey
                  const Color(0xFF9fa8da), // Winter blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [Colors.white, const Color(0xFFf5f5f5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
        break;

      case 'sunset':
        skyPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFFff9800), // Golden orange
                  const Color(0xFFff5722), // Deep orange
                  const Color(0xFFe91e63), // Pink
                  const Color(0xFF9c27b0), // Purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.7, 1.0],
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [const Color(0xFF8bc34a), const Color(0xFF4caf50)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
        break;

      case 'rainy':
        skyPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFF607d8b), // Blue grey
                  const Color(0xFF455a64), // Dark blue grey
                  const Color(0xFF37474f), // Very dark blue grey
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [const Color(0xFF4caf50), const Color(0xFF2e7d32)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
        break;

      case 'starry':
        skyPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [
                  const Color(0xFF1a237e), // Deep space blue
                  const Color(0xFF0d47a1), // Royal blue
                  const Color(0xFF0b1426), // Almost black
                ],
                center: Alignment.topCenter,
                radius: 1.5,
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [const Color(0xFF1b5e20), const Color(0xFF0d3f0e)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
        break;

      default: // sunny
        skyPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFF87ceeb), // Sky blue
                  const Color(0xFF4fc3f7), // Light blue
                  const Color(0xFF29b6f6), // Bright blue
                  const Color(0xFF03a9f4), // Deep blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.7, 1.0],
              ).createShader(
                Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
              );
        groundPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  const Color(0xFF8bc34a),
                  const Color(0xFF4caf50),
                  const Color(0xFF2e7d32),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTWH(
                  0,
                  size.height * 0.6,
                  size.width,
                  size.height * 0.4,
                ),
              );
    }

    // Draw sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.6),
      skyPaint,
    );

    // Draw ground
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      groundPaint,
    );
  }

  void _drawAtmosphericElements(Canvas canvas, Size size) {
    switch (atmosphere) {
      case 'moonlit':
        _drawMoon(canvas, size);
        _drawStars(canvas, size, 15);
        _drawClouds(canvas, size, Colors.grey[800]!.withOpacity(0.3));
        break;
      case 'winter':
        _drawSun(canvas, size, Colors.yellow[200]!);
        _drawSnowfall(canvas, size);
        _drawClouds(canvas, size, Colors.grey[300]!.withOpacity(0.8));
        break;
      case 'sunset':
        _drawSunset(canvas, size);
        _drawSilhouetteClouds(canvas, size);
        break;
      case 'rainy':
        _drawRain(canvas, size);
        _drawStormClouds(canvas, size);
        break;
      case 'starry':
        _drawStars(canvas, size, 25);
        _drawMilkyWay(canvas, size);
        break;
      default: // sunny
        _drawSun(canvas, size, Colors.yellow[400]!);
        _drawClouds(canvas, size, Colors.white.withOpacity(0.9));
    }
  }

  void _drawMoon(Canvas canvas, Size size) {
    final moonPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white, Colors.grey[200]!],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.2),
              radius: 30,
            ),
          );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      30,
      moonPaint,
    );

    // Moon glow
    final glowPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      45,
      glowPaint,
    );
  }

  void _drawStars(Canvas canvas, Size size, int count) {
    final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final random = Random(42);

    for (int i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.5;
      final starSize = random.nextDouble() * 2 + 1;

      // Draw cross-shaped star
      canvas.drawLine(
        Offset(x - starSize, y),
        Offset(x + starSize, y),
        starPaint..strokeWidth = 1,
      );
      canvas.drawLine(
        Offset(x, y - starSize),
        Offset(x, y + starSize),
        starPaint,
      );
    }
  }

  void _drawSun(Canvas canvas, Size size, Color sunColor) {
    final sunCenter = Offset(size.width * 0.85, size.height * 0.15);

    // Sun with realistic gradient
    final sunPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [sunColor, sunColor.withOpacity(0.8)],
            stops: const [0.0, 1.0],
          ).createShader(Rect.fromCircle(center: sunCenter, radius: 28));

    canvas.drawCircle(sunCenter, 28, sunPaint);

    // Enhanced sun rays
    final rayPaint =
        Paint()
          ..color = sunColor.withOpacity(0.6)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final start = Offset(
        sunCenter.dx + cos(angle) * 35,
        sunCenter.dy + sin(angle) * 35,
      );
      final end = Offset(
        sunCenter.dx + cos(angle) * 50,
        sunCenter.dy + sin(angle) * 50,
      );
      canvas.drawLine(start, end, rayPaint);
    }
  }

  void _drawSunset(Canvas canvas, Size size) {
    final sunCenter = Offset(size.width * 0.2, size.height * 0.4);

    // Large sunset sun
    final sunPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFffc107), // Bright yellow
              const Color(0xFFff9800), // Orange
              const Color(0xFFff5722), // Deep orange
            ],
            stops: const [0.0, 0.7, 1.0],
          ).createShader(Rect.fromCircle(center: sunCenter, radius: 40));

    canvas.drawCircle(sunCenter, 40, sunPaint);

    // Sunset glow
    final glowPaint =
        Paint()
          ..color = const Color(0xFFff9800).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(sunCenter, 80, glowPaint);
  }

  void _drawRain(Canvas canvas, Size size) {
    final rainPaint =
        Paint()
          ..color = Colors.blue[200]!.withOpacity(0.6)
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;

    final random = Random(42);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.8;
      canvas.drawLine(Offset(x, y), Offset(x - 3, y + 15), rainPaint);
    }
  }

  void _drawSnowfall(Canvas canvas, Size size) {
    final snowPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final random = Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final flakeSize = random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), flakeSize, snowPaint);
    }
  }

  void _drawClouds(Canvas canvas, Size size, Color cloudColor) {
    final cloudPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [cloudColor, cloudColor.withOpacity(0.7)],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.2),
              radius: 25,
            ),
          );

    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.2, size.height * 0.2),
      cloudPaint,
    );
    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.7, size.height * 0.25),
      cloudPaint,
    );
  }

  void _drawRealisticCloud(Canvas canvas, Offset center, Paint paint) {
    // Multiple overlapping circles for realistic cloud shape
    canvas.drawCircle(center, 20, paint);
    canvas.drawCircle(center.translate(-15, 3), 18, paint);
    canvas.drawCircle(center.translate(15, 3), 18, paint);
    canvas.drawCircle(center.translate(-8, -12), 15, paint);
    canvas.drawCircle(center.translate(8, -12), 15, paint);
    canvas.drawCircle(center.translate(0, -10), 12, paint);
    canvas.drawCircle(center.translate(-20, 8), 12, paint);
    canvas.drawCircle(center.translate(20, 8), 12, paint);
  }

  void _drawStormClouds(Canvas canvas, Size size) {
    final stormPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.grey[600]!, Colors.grey[800]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.3, size.height * 0.3),
              radius: 30,
            ),
          );

    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.3, size.height * 0.3),
      stormPaint,
    );
    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.6, size.height * 0.2),
      stormPaint,
    );
  }

  void _drawSilhouetteClouds(Canvas canvas, Size size) {
    final silhouettePaint = Paint()..color = Colors.black.withOpacity(0.3);

    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.4, size.height * 0.3),
      silhouettePaint,
    );
    _drawRealisticCloud(
      canvas,
      Offset(size.width * 0.8, size.height * 0.2),
      silhouettePaint,
    );
  }

  void _drawMilkyWay(Canvas canvas, Size size) {
    final milkyWayPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));

    final path =
        Path()
          ..moveTo(0, size.height * 0.3)
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.1,
            size.width,
            size.height * 0.4,
          )
          ..lineTo(size.width, size.height * 0.5)
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.2,
            0,
            size.height * 0.4,
          )
          ..close();

    canvas.drawPath(path, milkyWayPaint);
  }

  void _drawEnhancedLandscape(Canvas canvas, Size size) {
    // Draw distant hills/mountains
    final hillPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.green[400]!.withOpacity(0.6),
              Colors.green[600]!.withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.2),
          );

    final hillPath =
        Path()
          ..moveTo(0, size.height * 0.5)
          ..quadraticBezierTo(
            size.width * 0.3,
            size.height * 0.4,
            size.width * 0.6,
            size.height * 0.5,
          )
          ..quadraticBezierTo(
            size.width * 0.8,
            size.height * 0.55,
            size.width,
            size.height * 0.5,
          )
          ..lineTo(size.width, size.height * 0.6)
          ..lineTo(0, size.height * 0.6)
          ..close();

    canvas.drawPath(hillPath, hillPaint);
  }

  void _drawRealisticVegetation(Canvas canvas, Size size) {
    // Draw grass texture
    final grassPaint =
        Paint()
          ..color = Colors.green[600]!.withOpacity(0.3)
          ..strokeWidth = 1;

    final random = Random(123);
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height * 0.75 + random.nextDouble() * size.height * 0.2;
      final height = random.nextDouble() * 8 + 3;

      canvas.drawLine(
        Offset(x, y),
        Offset(x + random.nextDouble() * 2 - 1, y - height),
        grassPaint,
      );
    }

    // Draw small background plants
    _drawBackgroundPlants(canvas, size);
  }

  void _drawBackgroundPlants(Canvas canvas, Size size) {
    final plantPaint = Paint()..color = Colors.green[700]!.withOpacity(0.4);

    // Small bushes
    for (int i = 0; i < 5; i++) {
      final x = (i + 1) * size.width / 6;
      final y = size.height * 0.85;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 15, height: 8),
        plantPaint,
      );
    }
  }

  void _drawGardenTools(Canvas canvas, Size size) {
    // Enhanced garden tools with atmospheric lighting
    _drawEnhancedWateringCan(
      canvas,
      Offset(size.width * 0.1, size.height * 0.8),
    );
    _drawEnhancedShovel(canvas, Offset(size.width * 0.9, size.height * 0.75));

    // Add decorative elements based on atmosphere
    if (atmosphere != 'winter') {
      _drawCornerFlowers(canvas, size);
    }
  }

  void _drawEnhancedCloud(Canvas canvas, Offset center, Paint paint) {
    // Main cloud body with multiple circles for depth
    canvas.drawCircle(center, 18, paint);
    canvas.drawCircle(center.translate(-12, 2), 15, paint);
    canvas.drawCircle(center.translate(12, 2), 15, paint);
    canvas.drawCircle(center.translate(-6, -10), 12, paint);
    canvas.drawCircle(center.translate(6, -10), 12, paint);
    canvas.drawCircle(center.translate(0, -8), 10, paint);
  }

  void _drawMagicalElements(Canvas canvas, Size size) {
    final magicPaint = Paint()..color = Colors.purple[200]!.withOpacity(0.3);

    // Draw floating magical orbs
    for (int i = 0; i < 5; i++) {
      final x = (i + 1) * size.width / 6;
      final y = size.height * 0.3 + sin(i * pi / 2) * 20;
      canvas.drawCircle(Offset(x, y), 4, magicPaint);
    }
  }

  void _drawEnhancedWateringCan(Canvas canvas, Offset pos) {
    // Body with gradient
    final canPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.blue[300]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCenter(center: pos, width: 35, height: 25));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 35, height: 25),
        const Radius.circular(8),
      ),
      canPaint,
    );

    // Enhanced spout
    final spoutPaint = Paint()..color = Colors.grey[600]!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos.translate(22, -8), width: 18, height: 6),
        const Radius.circular(3),
      ),
      spoutPaint,
    );

    // Handle
    final handlePaint =
        Paint()
          ..color = Colors.brown[600]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCenter(center: pos.translate(-8, 0), width: 15, height: 20),
      -pi / 2,
      pi,
      false,
      handlePaint,
    );
  }

  void _drawEnhancedShovel(Canvas canvas, Offset pos) {
    // Enhanced handle with wood texture
    final handlePaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.brown[400]!, Colors.brown[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromCenter(
              center: pos.translate(0, -12),
              width: 4,
              height: 28,
            ),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos.translate(0, -12), width: 4, height: 28),
        const Radius.circular(2),
      ),
      handlePaint,
    );

    // Enhanced blade with metallic look
    final bladePaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.grey[400]!, Colors.grey[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromCenter(center: pos.translate(0, 6), width: 15, height: 10),
          );

    canvas.drawOval(
      Rect.fromCenter(center: pos.translate(0, 6), width: 15, height: 10),
      bladePaint,
    );
  }

  void _drawCornerFlowers(Canvas canvas, Size size) {
    final flowerPaint = Paint()..color = Colors.pink[200]!.withOpacity(0.6);

    // Bottom left corner flowers
    _drawSmallFlower(canvas, Offset(30, size.height - 30), flowerPaint);
    _drawSmallFlower(canvas, Offset(60, size.height - 50), flowerPaint);

    // Bottom right corner flowers
    _drawSmallFlower(
      canvas,
      Offset(size.width - 30, size.height - 30),
      flowerPaint,
    );
    _drawSmallFlower(
      canvas,
      Offset(size.width - 60, size.height - 50),
      flowerPaint,
    );
  }

  void _drawSmallFlower(Canvas canvas, Offset center, Paint paint) {
    // Small decorative flower
    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5;
      canvas.drawCircle(
        center.translate(cos(angle) * 8, sin(angle) * 8),
        4,
        paint,
      );
    }
    // Center
    canvas.drawCircle(center, 3, Paint()..color = Colors.yellow[300]!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is GardenBackgroundPainter &&
      oldDelegate.atmosphere != atmosphere;
}

/// Butterfly painter for flying animations
class ButterflyPainter extends CustomPainter {
  final double animationValue;

  ButterflyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Enhanced butterfly colors with gradients
    final butterfly1Paint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.orange[300]!, Colors.red[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 10));

    final wing1Paint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.purple[300]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8));

    final butterfly2Paint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.pink[300]!, Colors.purple[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 10));

    final wing2Paint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.yellow[300]!, Colors.orange[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8));

    // Butterfly 1 with enhanced path
    final pos1 = Offset(
      size.width * 0.3 + sin(animationValue * pi * 2) * 60,
      size.height * 0.3 + cos(animationValue * pi * 2) * 40,
    );
    _drawEnhancedButterfly(
      canvas,
      pos1,
      butterfly1Paint,
      wing1Paint,
      animationValue,
    );

    // Butterfly 2 with different pattern
    final pos2 = Offset(
      size.width * 0.7 + sin(animationValue * pi * 2 + pi) * 50,
      size.height * 0.4 + cos(animationValue * pi * 2 + pi) * 35,
    );
    _drawEnhancedButterfly(
      canvas,
      pos2,
      butterfly2Paint,
      wing2Paint,
      animationValue + 0.5,
    );

    // Butterfly 3 for more magical effect
    final pos3 = Offset(
      size.width * 0.5 + sin(animationValue * pi * 1.5 + pi * 0.5) * 45,
      size.height * 0.2 + cos(animationValue * pi * 1.5 + pi * 0.5) * 30,
    );
    _drawEnhancedButterfly(
      canvas,
      pos3,
      wing2Paint,
      butterfly1Paint,
      animationValue + 0.25,
    );

    // Draw magical trail behind butterflies
    _drawMagicalTrail(canvas, pos1);
    _drawMagicalTrail(canvas, pos2);
    _drawMagicalTrail(canvas, pos3);
  }

  void _drawEnhancedButterfly(
    Canvas canvas,
    Offset center,
    Paint bodyPaint,
    Paint wingPaint,
    double phase,
  ) {
    // Enhanced body with gradient
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 3, height: 12),
      bodyPaint,
    );

    // Antennae
    final antennaPaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1;
    canvas.drawLine(
      center.translate(-1, -6),
      center.translate(-3, -10),
      antennaPaint,
    );
    canvas.drawLine(
      center.translate(1, -6),
      center.translate(3, -10),
      antennaPaint,
    );

    // Wings with enhanced flapping effect
    final wingSpread = sin(phase * pi * 6) * 0.4 + 0.8;

    // Left wings with spots
    _drawWingWithSpots(
      canvas,
      center.translate(-5 * wingSpread, -3),
      8,
      6,
      wingPaint,
    );
    _drawWingWithSpots(
      canvas,
      center.translate(-4 * wingSpread, 3),
      6,
      4,
      wingPaint,
    );

    // Right wings with spots
    _drawWingWithSpots(
      canvas,
      center.translate(5 * wingSpread, -3),
      8,
      6,
      wingPaint,
    );
    _drawWingWithSpots(
      canvas,
      center.translate(4 * wingSpread, 3),
      6,
      4,
      wingPaint,
    );
  }

  void _drawWingWithSpots(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint wingPaint,
  ) {
    // Draw wing
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      wingPaint,
    );

    // Add decorative spots
    final spotPaint = Paint()..color = Colors.white.withOpacity(0.7);
    canvas.drawCircle(center.translate(1, 0), 1, spotPaint);
    canvas.drawCircle(center.translate(-1, 1), 0.5, spotPaint);
  }

  void _drawMagicalTrail(Canvas canvas, Offset position) {
    final trailPaint = Paint()..color = Colors.white.withOpacity(0.3);

    // Draw small sparkles trailing behind
    for (int i = 0; i < 3; i++) {
      final trailPos = position.translate(
        -i * 8.0,
        sin(animationValue * pi * 4 + i) * 3,
      );
      canvas.drawCircle(trailPos, 1.5 - i * 0.3, trailPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Sparkle effect painter for magical animations
class SparkleEffectPainter extends CustomPainter {
  final double animationValue;

  SparkleEffectPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final random = Random(42);

    // Multiple layers of sparkles with different colors and sizes
    _drawSparkleLayer(canvas, size, random, Colors.yellow, 15, animationValue);
    _drawSparkleLayer(
      canvas,
      size,
      random,
      Colors.white,
      12,
      animationValue + 0.3,
    );
    _drawSparkleLayer(
      canvas,
      size,
      random,
      Colors.pink[200]!,
      10,
      animationValue + 0.6,
    );
    _drawSparkleLayer(
      canvas,
      size,
      random,
      Colors.purple[200]!,
      8,
      animationValue + 0.9,
    );

    // Draw magical stars
    _drawMagicalStars(canvas, size, random, animationValue);

    // Draw floating magical orbs
    _drawFloatingOrbs(canvas, size, animationValue);
  }

  void _drawSparkleLayer(
    Canvas canvas,
    Size size,
    Random random,
    Color color,
    int count,
    double phase,
  ) {
    final sparkPaint =
        Paint()..color = color.withOpacity((1 - phase).clamp(0.0, 1.0) * 0.8);

    for (int i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius =
          (1 - phase).clamp(0.0, 1.0) * (2 + random.nextDouble() * 3);
      final twinkle = sin(phase * pi * 4 + i) * 0.3 + 0.7;

      if (radius > 0) {
        sparkPaint.color = color.withOpacity(
          (1 - phase).clamp(0.0, 1.0) * twinkle * 0.9,
        );
        canvas.drawCircle(Offset(x, y), radius, sparkPaint);

        // Add star shape effect
        if (radius > 2) {
          _drawStar(canvas, Offset(x, y), radius * 0.7, sparkPaint);
        }
      }
    }
  }

  void _drawMagicalStars(
    Canvas canvas,
    Size size,
    Random random,
    double phase,
  ) {
    final starPaint =
        Paint()
          ..color = Colors.white.withOpacity((1 - phase).clamp(0.0, 1.0) * 0.9);

    for (int i = 0; i < 6; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize =
          (1 - phase).clamp(0.0, 1.0) * (3 + random.nextDouble() * 4);

      if (starSize > 0) {
        _drawStar(canvas, Offset(x, y), starSize, starPaint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5 - pi / 2;
      final outerRadius = size;
      final innerRadius = size * 0.4;

      // Outer point
      final outerX = center.dx + cos(angle) * outerRadius;
      final outerY = center.dy + sin(angle) * outerRadius;

      // Inner point
      final innerAngle = angle + pi / 5;
      final innerX = center.dx + cos(innerAngle) * innerRadius;
      final innerY = center.dy + sin(innerAngle) * innerRadius;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawFloatingOrbs(Canvas canvas, Size size, double phase) {
    final orbPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.purple[200]!.withOpacity(
                (1 - phase).clamp(0.0, 1.0) * 0.6,
              ),
              Colors.transparent,
            ],
            stops: const [0.0, 1.0],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 15));

    for (int i = 0; i < 4; i++) {
      final angle = phase * pi * 2 + i * pi / 2;
      final radius = 30 + sin(phase * pi * 3 + i) * 10;
      final orbCenter = Offset(
        size.width * 0.5 + cos(angle) * radius,
        size.height * 0.5 + sin(angle) * radius,
      );

      final orbSize = (1 - phase).clamp(0.0, 1.0) * 8;
      if (orbSize > 0) {
        canvas.drawCircle(orbCenter, orbSize, orbPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Plant painter for drawing different plants with attributes - ENHANCED REALISTIC VERSION
class RealisticPlantPainter extends CustomPainter {
  final String plantType;
  final Color color;
  final String? shape;
  final String? atmosphere;
  final double growthValue;
  final double bloomValue;

  RealisticPlantPainter({
    required this.plantType,
    required this.color,
    this.shape,
    this.atmosphere,
    required this.growthValue,
    required this.bloomValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || growthValue <= 0) return;

    final center = Offset(size.width / 2, size.height);
    final stemHeight = size.height * 0.7 * growthValue;

    // Draw enhanced stem with realistic texture
    _drawRealisticStem(canvas, center, stemHeight);

    // Draw realistic leaves with detailed texture
    if (growthValue > 0.3) {
      _drawRealisticLeaves(canvas, center, stemHeight);
    }

    // Draw highly detailed realistic flower
    if (growthValue > 0.7 && bloomValue > 0) {
      final flowerCenter = center.translate(0, -stemHeight);
      _drawRealisticFlower(canvas, flowerCenter, bloomValue);
    }

    // Enhanced atmosphere effects
    if (atmosphere != null && bloomValue > 0.5) {
      _drawEnhancedAtmosphereEffect(
        canvas,
        center.translate(0, -stemHeight),
        atmosphere!,
      );
    }

    // Magical glow effect for fully bloomed flowers
    if (bloomValue > 0.8) {
      _drawEnhancedGlowEffect(canvas, center.translate(0, -stemHeight));
    }
  }

  void _drawRealisticStem(Canvas canvas, Offset center, double stemHeight) {
    // Enhanced stem with gradient and texture
    final stemPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.green[800]!,
              Colors.green[600]!,
              Colors.green[400]!,
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromPoints(center, center.translate(0, -stemHeight)),
          );

    // Main stem with proper thickness
    canvas.drawLine(
      center,
      center.translate(0, -stemHeight),
      stemPaint..strokeWidth = 8,
    );

    // Add stem texture lines
    final texturePaint =
        Paint()
          ..color = Colors.green[700]!
          ..strokeWidth = 1;

    for (int i = 0; i < (stemHeight / 15).round(); i++) {
      final y = center.dy - (i * 15);
      canvas.drawLine(
        Offset(center.dx - 2, y),
        Offset(center.dx + 2, y),
        texturePaint,
      );
    }
  }

  void _drawRealisticLeaves(Canvas canvas, Offset center, double stemHeight) {
    // Large, detailed leaves with realistic shape and texture
    _drawDetailedLeaf(
      canvas,
      center.translate(-25, -stemHeight * 0.3),
      -0.3,
      1.2,
    );
    _drawDetailedLeaf(
      canvas,
      center.translate(25, -stemHeight * 0.6),
      0.3,
      1.0,
    );
    _drawDetailedLeaf(
      canvas,
      center.translate(-20, -stemHeight * 0.8),
      -0.2,
      0.8,
    );
  }

  void _drawDetailedLeaf(
    Canvas canvas,
    Offset center,
    double rotation,
    double scale,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.scale(scale);

    // Leaf gradient paint
    final leafPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.green[800]!,
              Colors.green[600]!,
              Colors.green[400]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromCenter(center: Offset.zero, width: 30, height: 50),
          );

    // Main leaf shape
    final leafPath =
        Path()
          ..moveTo(0, 25)
          ..quadraticBezierTo(-15, 10, -12, -10)
          ..quadraticBezierTo(-8, -20, 0, -25)
          ..quadraticBezierTo(8, -20, 12, -10)
          ..quadraticBezierTo(15, 10, 0, 25)
          ..close();

    canvas.drawPath(leafPath, leafPaint);

    // Leaf vein details
    final veinPaint =
        Paint()
          ..color = Colors.green[800]!
          ..strokeWidth = 1.5;

    // Central vein
    canvas.drawLine(Offset(0, 25), Offset(0, -25), veinPaint);

    // Side veins
    for (int i = 0; i < 5; i++) {
      final y = 20 - i * 10;
      final width = 8 - i * 1.5;
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(-width, y - 5.0),
        veinPaint,
      );
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(width, y - 5.0),
        veinPaint,
      );
    }

    canvas.restore();
  }

  void _drawRealisticFlower(Canvas canvas, Offset center, double bloom) {
    // Scale up flowers significantly for realistic size
    final baseSize = 40 * bloom; // Much larger base size

    switch (plantType) {
      case 'sunflower':
        _drawRealisticSunflower(canvas, center, baseSize, bloom);
        break;
      case 'rose':
        _drawRealisticRose(canvas, center, baseSize, bloom);
        break;
      case 'tulip':
        _drawRealisticTulip(canvas, center, baseSize, bloom);
        break;
      case 'daisy':
        _drawRealisticDaisy(canvas, center, baseSize, bloom);
        break;
      case 'violet':
        _drawRealisticViolet(canvas, center, baseSize, bloom);
        break;
      case 'lily':
        _drawRealisticLily(canvas, center, baseSize, bloom);
        break;
    }
  }

  void _drawRealisticSunflower(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Large realistic sunflower center
    final centerPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.brown[900]!,
              Colors.brown[700]!,
              Colors.orange[800]!,
            ],
            stops: const [0.0, 0.7, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: size * 0.4));

    canvas.drawCircle(center, size * 0.4, centerPaint);

    // Add seed pattern in center
    final seedPaint = Paint()..color = Colors.brown[900]!;
    for (int ring = 0; ring < 3; ring++) {
      final ringRadius = (ring + 1) * size * 0.1;
      final seedCount = (ring + 1) * 8;
      for (int i = 0; i < seedCount; i++) {
        final angle = i * pi * 2 / seedCount;
        final seedPos = center.translate(
          cos(angle) * ringRadius,
          sin(angle) * ringRadius,
        );
        canvas.drawCircle(seedPos, 1.5, seedPaint);
      }
    }

    // Large realistic petals with gradient
    for (int i = 0; i < 20; i++) {
      final angle = i * pi * 2 / 20;
      final petalCenter = center.translate(
        cos(angle) * size * 0.65,
        sin(angle) * size * 0.65,
      );

      _drawSunflowerPetal(canvas, petalCenter, angle, size * 0.6, color);
    }
  }

  void _drawSunflowerPetal(
    Canvas canvas,
    Offset center,
    double angle,
    double size,
    Color petalColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final petalPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              _darkenColor(petalColor, 0.3),
              petalColor,
              _lightenColor(petalColor, 0.2),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: size * 0.4,
              height: size,
            ),
          );

    final petalPath =
        Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(
            -size * 0.2,
            -size * 0.3,
            -size * 0.15,
            -size * 0.8,
          )
          ..quadraticBezierTo(0, -size, size * 0.15, -size * 0.8)
          ..quadraticBezierTo(size * 0.2, -size * 0.3, 0, 0)
          ..close();

    canvas.drawPath(petalPath, petalPaint);

    // Add petal vein
    final veinPaint =
        Paint()
          ..color = _darkenColor(petalColor, 0.2)
          ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(0, -size * 0.7), veinPaint);

    canvas.restore();
  }

  void _drawRealisticRose(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Multi-layered rose with realistic depth
    final layers = 4;

    for (int layer = layers; layer >= 1; layer--) {
      final layerSize = size * (layer / layers.toDouble()) * 0.8;
      final petalsInLayer = 5 + layer;
      final layerOpacity = 0.7 + (layer / layers.toDouble()) * 0.3;

      for (int i = 0; i < petalsInLayer; i++) {
        final angle = (i * pi * 2 / petalsInLayer) + (layer * 0.3);
        final petalDistance = layerSize * 0.3 * (layer / layers.toDouble());
        final petalCenter = center.translate(
          cos(angle) * petalDistance,
          sin(angle) * petalDistance,
        );

        _drawRosePetal(
          canvas,
          petalCenter,
          angle,
          layerSize,
          color.withOpacity(layerOpacity),
        );
      }
    }

    // Rose center
    final centerPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [_darkenColor(color, 0.4), _darkenColor(color, 0.2)],
          ).createShader(Rect.fromCircle(center: center, radius: size * 0.15));

    canvas.drawCircle(center, size * 0.15, centerPaint);
  }

  void _drawRosePetal(
    Canvas canvas,
    Offset center,
    double angle,
    double size,
    Color petalColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final petalPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              _lightenColor(petalColor, 0.3),
              petalColor,
              _darkenColor(petalColor, 0.2),
            ],
            stops: const [0.0, 0.6, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: size,
              height: size * 0.8,
            ),
          );

    final petalPath =
        Path()
          ..moveTo(0, size * 0.1)
          ..quadraticBezierTo(
            -size * 0.4,
            -size * 0.1,
            -size * 0.3,
            -size * 0.5,
          )
          ..quadraticBezierTo(-size * 0.1, -size * 0.7, 0, -size * 0.6)
          ..quadraticBezierTo(size * 0.1, -size * 0.7, size * 0.3, -size * 0.5)
          ..quadraticBezierTo(size * 0.4, -size * 0.1, 0, size * 0.1)
          ..close();

    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _drawRealisticTulip(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Large tulip with realistic shape and gradient
    final tulipPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              _darkenColor(color, 0.3),
              color,
              _lightenColor(color, 0.3),
              color,
              _darkenColor(color, 0.1),
            ],
            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(
            Rect.fromCenter(
              center: center,
              width: size * 1.2,
              height: size * 1.5,
            ),
          );

    // Main tulip shape - larger and more detailed
    final tulipPath =
        Path()
          ..moveTo(center.dx, center.dy + size * 0.6)
          ..quadraticBezierTo(
            center.dx - size * 0.7,
            center.dy + size * 0.2,
            center.dx - size * 0.4,
            center.dy - size * 0.8,
          )
          ..quadraticBezierTo(
            center.dx - size * 0.2,
            center.dy - size * 1.2,
            center.dx,
            center.dy - size * 1.1,
          )
          ..quadraticBezierTo(
            center.dx + size * 0.2,
            center.dy - size * 1.2,
            center.dx + size * 0.4,
            center.dy - size * 0.8,
          )
          ..quadraticBezierTo(
            center.dx + size * 0.7,
            center.dy + size * 0.2,
            center.dx,
            center.dy + size * 0.6,
          )
          ..close();

    canvas.drawPath(tulipPath, tulipPaint);

    // Add tulip divisions
    final divisionPaint =
        Paint()
          ..color = _darkenColor(color, 0.3)
          ..strokeWidth = 2;

    canvas.drawLine(
      center.translate(-size * 0.3, -size * 0.5),
      center.translate(0, center.dy + size * 0.4 - center.dy),
      divisionPaint,
    );
    canvas.drawLine(
      center.translate(size * 0.3, -size * 0.5),
      center.translate(0, center.dy + size * 0.4 - center.dy),
      divisionPaint,
    );

    // Add inner highlights
    final highlightPaint =
        Paint()
          ..color = _lightenColor(color, 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final innerPath =
        Path()
          ..moveTo(center.dx - size * 0.2, center.dy - size * 0.3)
          ..quadraticBezierTo(
            center.dx,
            center.dy - size * 0.7,
            center.dx + size * 0.2,
            center.dy - size * 0.3,
          );

    canvas.drawPath(innerPath, highlightPaint);
  }

  void _drawRealisticDaisy(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Large realistic daisy center
    final centerPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.yellow[400]!,
              Colors.yellow[600]!,
              Colors.orange[300]!,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: size * 0.25));

    canvas.drawCircle(center, size * 0.25, centerPaint);

    // Add center texture
    final texturePaint = Paint()..color = Colors.orange[400]!;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final texturePos = center.translate(
        cos(angle) * size * 0.15,
        sin(angle) * size * 0.15,
      );
      canvas.drawCircle(texturePos, 1.5, texturePaint);
    }

    // Large realistic white petals
    for (int i = 0; i < 16; i++) {
      final angle = i * pi * 2 / 16;
      final petalCenter = center.translate(
        cos(angle) * size * 0.6,
        sin(angle) * size * 0.6,
      );

      _drawDaisyPetal(canvas, petalCenter, angle, size * 0.7, color);
    }
  }

  void _drawDaisyPetal(
    Canvas canvas,
    Offset center,
    double angle,
    double size,
    Color petalColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final petalPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              _lightenColor(petalColor, 0.2),
              petalColor,
              _darkenColor(petalColor, 0.1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: size * 0.3,
              height: size,
            ),
          );

    final petalPath =
        Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(
            -size * 0.15,
            -size * 0.3,
            -size * 0.1,
            -size * 0.9,
          )
          ..quadraticBezierTo(0, -size, size * 0.1, -size * 0.9)
          ..quadraticBezierTo(size * 0.15, -size * 0.3, 0, 0)
          ..close();

    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _drawRealisticViolet(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Violet with heart-shaped petals - enhanced size and detail
    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5;
      final petalCenter = center.translate(
        cos(angle) * size * 0.4,
        sin(angle) * size * 0.4,
      );

      _drawVioletPetal(canvas, petalCenter, angle, size * 0.8, color);
    }

    // Violet center with detailed stamens
    final centerPaint = Paint()..color = Colors.yellow[200]!;
    canvas.drawCircle(center, size * 0.1, centerPaint);

    // Add small stamens
    final stamenPaint = Paint()..color = Colors.orange[300]!;
    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5;
      final stamenPos = center.translate(
        cos(angle) * size * 0.05,
        sin(angle) * size * 0.05,
      );
      canvas.drawCircle(stamenPos, 1, stamenPaint);
    }
  }

  void _drawVioletPetal(
    Canvas canvas,
    Offset center,
    double angle,
    double size,
    Color petalColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final petalPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              _lightenColor(petalColor, 0.4),
              petalColor,
              _darkenColor(petalColor, 0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: size,
              height: size * 0.8,
            ),
          );

    // Enhanced heart shape
    final heartPath =
        Path()
          ..moveTo(0, size * 0.3)
          ..quadraticBezierTo(
            -size * 0.3,
            size * 0.1,
            -size * 0.25,
            -size * 0.1,
          )
          ..quadraticBezierTo(-size * 0.1, -size * 0.3, 0, -size * 0.2)
          ..quadraticBezierTo(size * 0.1, -size * 0.3, size * 0.25, -size * 0.1)
          ..quadraticBezierTo(size * 0.3, size * 0.1, 0, size * 0.3)
          ..close();

    canvas.drawPath(heartPath, petalPaint);

    // Add petal veining
    final veinPaint =
        Paint()
          ..color = _darkenColor(petalColor, 0.4)
          ..strokeWidth = 0.8;

    canvas.drawLine(Offset(0, size * 0.2), Offset(0, -size * 0.1), veinPaint);
    canvas.drawLine(
      Offset(-size * 0.1, 0),
      Offset(-size * 0.15, -size * 0.05),
      veinPaint,
    );
    canvas.drawLine(
      Offset(size * 0.1, 0),
      Offset(size * 0.15, -size * 0.05),
      veinPaint,
    );

    canvas.restore();
  }

  void _drawRealisticLily(
    Canvas canvas,
    Offset center,
    double size,
    double bloom,
  ) {
    // Large lily with 6 detailed petals
    for (int i = 0; i < 6; i++) {
      final angle = i * pi * 2 / 6;
      final petalCenter = center.translate(
        cos(angle) * size * 0.3,
        sin(angle) * size * 0.3,
      );

      _drawLilyPetal(canvas, petalCenter, angle, size * 1.2, color);
    }

    // Large prominent stamens
    for (int i = 0; i < 6; i++) {
      final angle = i * pi * 2 / 6;
      final stamenBase = center.translate(
        cos(angle) * size * 0.15,
        sin(angle) * size * 0.15,
      );
      final stamenTip = center.translate(
        cos(angle) * size * 0.4,
        sin(angle) * size * 0.4,
      );

      // Stamen filament
      final filamentPaint =
          Paint()
            ..color = Colors.green[300]!
            ..strokeWidth = 2;
      canvas.drawLine(stamenBase, stamenTip, filamentPaint);

      // Anther
      final antherPaint = Paint()..color = Colors.orange[600]!;
      canvas.drawOval(
        Rect.fromCenter(center: stamenTip, width: 4, height: 8),
        antherPaint,
      );
    }

    // Central pistil
    final pistilPaint = Paint()..color = Colors.green[400]!;
    canvas.drawCircle(center, size * 0.08, pistilPaint);
  }

  void _drawLilyPetal(
    Canvas canvas,
    Offset center,
    double angle,
    double size,
    Color petalColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final petalPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              _lightenColor(petalColor, 0.3),
              petalColor,
              _darkenColor(petalColor, 0.2),
              petalColor,
              _lightenColor(petalColor, 0.1),
            ],
            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: size * 0.6,
              height: size,
            ),
          );

    // Star-shaped lily petal with curves
    final petalPath =
        Path()
          ..moveTo(0, size * 0.1)
          ..quadraticBezierTo(
            -size * 0.2,
            -size * 0.2,
            -size * 0.15,
            -size * 0.7,
          )
          ..quadraticBezierTo(-size * 0.1, -size * 1.0, 0, -size * 0.95)
          ..quadraticBezierTo(size * 0.1, -size * 1.0, size * 0.15, -size * 0.7)
          ..quadraticBezierTo(size * 0.2, -size * 0.2, 0, size * 0.1)
          ..close();

    canvas.drawPath(petalPath, petalPaint);

    // Add spots for tiger lily effect (if orange/red color)
    if (petalColor.red > 200 && petalColor.green < 150) {
      final spotPaint = Paint()..color = Colors.brown[800]!;
      for (int i = 0; i < 5; i++) {
        final spotY = -size * 0.3 - (i * size * 0.1);
        final spotX = (i.isEven ? -1 : 1) * size * 0.05;
        canvas.drawCircle(Offset(spotX, spotY), 2, spotPaint);
      }
    }

    canvas.restore();
  }

  void _drawEnhancedAtmosphereEffect(
    Canvas canvas,
    Offset center,
    String atmosphere,
  ) {
    switch (atmosphere) {
      case 'moonlit':
      case 'starry':
        // Enhanced silver moonlight glow
        final moonlightPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [
                  Colors.grey[200]!.withOpacity(0.6),
                  Colors.grey[300]!.withOpacity(0.3),
                  Colors.transparent,
                ],
              ).createShader(Rect.fromCircle(center: center, radius: 60));
        canvas.drawCircle(center, 60, moonlightPaint);

        // Larger stars around the flower
        final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
        for (int i = 0; i < 12; i++) {
          final angle = i * pi / 6;
          final starPos = center.translate(cos(angle) * 70, sin(angle) * 70);
          _drawEnhancedStar(canvas, starPos, starPaint, 5);
        }
        break;

      case 'winter':
        // Enhanced frost effect with ice crystals
        final frostPaint = Paint()..color = Colors.white.withOpacity(0.7);
        for (int i = 0; i < 20; i++) {
          final angle = i * pi * 2 / 20;
          final frostPos = center.translate(cos(angle) * 45, sin(angle) * 45);
          _drawIceCrystal(canvas, frostPos, frostPaint);
        }
        break;

      case 'sunset':
        // Enhanced golden hour glow
        final goldenPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [
                  Colors.orange[200]!.withOpacity(0.6),
                  Colors.yellow[200]!.withOpacity(0.4),
                  Colors.transparent,
                ],
              ).createShader(Rect.fromCircle(center: center, radius: 80));
        canvas.drawCircle(center, 80, goldenPaint);
        break;

      case 'rainy':
        // Enhanced water droplets with reflections
        final dropPaint = Paint()..color = Colors.blue[300]!.withOpacity(0.7);
        for (int i = 0; i < 15; i++) {
          final angle = i * pi * 2 / 15;
          final dropPos = center.translate(cos(angle) * 35, sin(angle) * 35);
          _drawRainDrop(canvas, dropPos, dropPaint);
        }
        break;

      default: // sunny
        // Enhanced warm sunlight effect
        final sunlightPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [
                  Colors.yellow[100]!.withOpacity(0.5),
                  Colors.orange[100]!.withOpacity(0.3),
                  Colors.transparent,
                ],
              ).createShader(Rect.fromCircle(center: center, radius: 70));
        canvas.drawCircle(center, 70, sunlightPaint);

        // Sun rays
        final rayPaint =
            Paint()
              ..color = Colors.yellow[200]!.withOpacity(0.4)
              ..strokeWidth = 2;
        for (int i = 0; i < 8; i++) {
          final angle = i * pi / 4;
          canvas.drawLine(
            center.translate(cos(angle) * 40, sin(angle) * 40),
            center.translate(cos(angle) * 65, sin(angle) * 65),
            rayPaint,
          );
        }
    }
  }

  void _drawEnhancedStar(
    Canvas canvas,
    Offset center,
    Paint paint,
    double size,
  ) {
    // Draw a detailed 5-pointed star
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5 - pi / 2;
      final outerRadius = size;
      final innerRadius = size * 0.4;

      final outerX = center.dx + cos(angle) * outerRadius;
      final outerY = center.dy + sin(angle) * outerRadius;

      final innerAngle = angle + pi / 5;
      final innerX = center.dx + cos(innerAngle) * innerRadius;
      final innerY = center.dy + sin(innerAngle) * innerRadius;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawIceCrystal(Canvas canvas, Offset center, Paint paint) {
    // Draw a 6-pointed ice crystal
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawLine(
        center,
        center.translate(cos(angle) * 6, sin(angle) * 6),
        paint..strokeWidth = 1.5,
      );

      // Add side branches
      final midPoint = center.translate(cos(angle) * 3, sin(angle) * 3);
      canvas.drawLine(
        midPoint,
        midPoint.translate(cos(angle + pi / 3) * 2, sin(angle + pi / 3) * 2),
        paint..strokeWidth = 1,
      );
      canvas.drawLine(
        midPoint,
        midPoint.translate(cos(angle - pi / 3) * 2, sin(angle - pi / 3) * 2),
        paint..strokeWidth = 1,
      );
    }
  }

  void _drawRainDrop(Canvas canvas, Offset center, Paint paint) {
    // Draw a realistic water droplet
    final dropPath =
        Path()
          ..moveTo(center.dx, center.dy + 6)
          ..quadraticBezierTo(
            center.dx - 3,
            center.dy + 2,
            center.dx - 2,
            center.dy - 2,
          )
          ..quadraticBezierTo(
            center.dx,
            center.dy - 4,
            center.dx + 2,
            center.dy - 2,
          )
          ..quadraticBezierTo(
            center.dx + 3,
            center.dy + 2,
            center.dx,
            center.dy + 6,
          )
          ..close();

    canvas.drawPath(dropPath, paint);

    // Add highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.6);
    canvas.drawCircle(center.translate(-1, -1), 1, highlightPaint);
  }

  void _drawEnhancedGlowEffect(Canvas canvas, Offset center) {
    // Multiple layers of enhanced glow
    final glowPaint1 =
        Paint()
          ..color = color.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, 80, glowPaint1);

    final glowPaint2 =
        Paint()
          ..color = color.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 60, glowPaint2);

    final glowPaint3 =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, 40, glowPaint3);

    // Enhanced sparkle ring
    final sparklePaint = Paint()..color = Colors.white.withOpacity(0.9);
    for (int i = 0; i < 16; i++) {
      final angle = i * pi * 2 / 16;
      final sparklePos = center.translate(cos(angle) * 65, sin(angle) * 65);
      canvas.drawCircle(sparklePos, 2.5, sparklePaint);

      // Add twinkle effect
      canvas.drawLine(
        sparklePos.translate(-4, 0),
        sparklePos.translate(4, 0),
        sparklePaint..strokeWidth = 1,
      );
      canvas.drawLine(
        sparklePos.translate(0, -4),
        sparklePos.translate(0, 4),
        sparklePaint,
      );
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

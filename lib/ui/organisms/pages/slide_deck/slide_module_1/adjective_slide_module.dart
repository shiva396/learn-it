import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AdjectiveSlideModule extends StatefulWidget {
  final VoidCallback? onComplete;

  const AdjectiveSlideModule({super.key, this.onComplete});

  @override
  State<AdjectiveSlideModule> createState() => _AdjectiveSlideModuleState();
}

class _AdjectiveSlideModuleState extends State<AdjectiveSlideModule>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  FlutterTts _flutterTts = FlutterTts();

  int _currentSlide = 0;
  bool _isTextVisible = false;
  bool _isAnswerRevealed = false;
  bool _isCatTransformed = false;
  bool _showMagicBrush = false;
  bool _showAdjectiveLabels = false;
  bool _showThinkingTime = false;

  // Animation controllers
  late AnimationController _slideInController;
  late AnimationController _textTypeController;
  late AnimationController _magicBrushController;
  late AnimationController _catTransformController;
  late AnimationController _labelFloatController;
  late AnimationController _pulseController;

  // Animations
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _brushSlideAnimation;
  late Animation<double> _brushRotationAnimation;
  late Animation<double> _catScaleAnimation;
  late Animation<Color?> _catColorAnimation;
  late Animation<double> _labelOpacityAnimation;
  late Animation<double> _pulseAnimation;

  // Cat painting game state
  List<String> _paintedFeatures = [];
  final List<String> _availableFeatures = [
    'Black',
    'Fluffy',
    'Cute',
    'Big',
    'Sleepy',
  ];
  Color _currentCatColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTTS();
    _startFirstSlide();
  }

  void _initializeAnimations() {
    // Slide transition
    _slideInController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Text typing effect
    _textTypeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Magic brush animation
    _magicBrushController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Cat transformation
    _catTransformController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Label floating
    _labelFloatController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation for interaction
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideInController, curve: Curves.easeOutCubic),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textTypeController, curve: Curves.easeInOut),
    );

    _brushSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, -0.5),
      end: const Offset(0.2, 0.1),
    ).animate(
      CurvedAnimation(parent: _magicBrushController, curve: Curves.elasticOut),
    );

    _brushRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 6.28, // 2π radians
    ).animate(
      CurvedAnimation(parent: _magicBrushController, curve: Curves.easeInOut),
    );

    _catScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _catTransformController, curve: Curves.bounceOut),
    );

    _catColorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: Colors.orange.shade600,
    ).animate(
      CurvedAnimation(parent: _catTransformController, curve: Curves.easeInOut),
    );

    _labelOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _labelFloatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Set up repeating pulse
    _pulseController.repeat(reverse: true);
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.6);
    await _flutterTts.setVolume(0.9);
    await _flutterTts.setPitch(1.1);
  }

  void _startFirstSlide() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Slide in
    _slideInController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // Show text with typing effect
    _textTypeController.forward();
    setState(() {
      _isTextVisible = true;
    });

    // Speak the content
    await _speak(
      "This is a cat. A noun is the name of a person, place, animal or thing.",
    );

    await Future.delayed(const Duration(seconds: 2));

    // Interactive question
    setState(() {
      _showThinkingTime = true;
    });

    await _speak("What does this cat look like?");

    await Future.delayed(const Duration(seconds: 5)); // Thinking time

    // Reveal answer
    _revealFirstAnswer();
  }

  void _revealFirstAnswer() async {
    setState(() {
      _isAnswerRevealed = true;
      _showThinkingTime = false;
    });

    await _speak("We don't know yet! This cat has no describing words.");

    await Future.delayed(const Duration(seconds: 3));

    // Show continue button or auto-advance
    _showContinueOption();
  }

  void _showContinueOption() {
    setState(() {});
  }

  void _nextSlide() {
    if (_currentSlide == 0) {
      // Move to adjective slide
      _startAdjectiveSlide();
    } else if (_currentSlide == 1) {
      // Move to practice slide
      _startPracticeSlide();
    } else if (_currentSlide == 2) {
      // Move to summary
      _startSummarySlide();
    } else {
      // Complete the module
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  void _startAdjectiveSlide() async {
    setState(() {
      _currentSlide = 1;
      _isTextVisible = false;
      _isAnswerRevealed = false;
      _isCatTransformed = false;
      _showMagicBrush = false;
      _showAdjectiveLabels = false;
    });

    _resetAnimations();

    await Future.delayed(const Duration(milliseconds: 300));

    // Slide transition
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _slideInController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // Show text
    _textTypeController.forward();
    setState(() {
      _isTextVisible = true;
    });

    await _speak("Watch what happens when adjectives come in!");

    await Future.delayed(const Duration(seconds: 2));

    // Start magic animation
    _animateMagicTransformation();
  }

  void _animateMagicTransformation() async {
    // Show magic brush
    setState(() {
      _showMagicBrush = true;
    });

    _magicBrushController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Transform cat
    setState(() {
      _isCatTransformed = true;
      _currentCatColor = Colors.orange.shade600;
    });

    _catTransformController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Show adjective labels
    setState(() {
      _showAdjectiveLabels = true;
      _paintedFeatures = ['Black', 'Fluffy'];
    });

    _labelFloatController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Speak the result
    await _speak(
      "This is a black, fluffy cat. Adjectives colour and describe the noun!",
    );

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnswerRevealed = true;
    });
  }

  void _startPracticeSlide() async {
    setState(() {
      _currentSlide = 2;
      _isTextVisible = false;
      _isAnswerRevealed = false;
    });

    _resetAnimations();

    await Future.delayed(const Duration(milliseconds: 300));

    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _slideInController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    _textTypeController.forward();
    setState(() {
      _isTextVisible = true;
    });

    await _speak("Let's practice! Can you find the adjectives?");

    await Future.delayed(const Duration(seconds: 2));

    await _speak(
      "In the sentence 'The big, red balloon floats high', which words are adjectives?",
    );

    await Future.delayed(const Duration(seconds: 6)); // Thinking time

    setState(() {
      _isAnswerRevealed = true;
    });

    await _speak("Big and red are adjectives! They describe the balloon.");
  }

  void _startSummarySlide() async {
    setState(() {
      _currentSlide = 3;
      _isTextVisible = false;
      _isAnswerRevealed = false;
    });

    _resetAnimations();

    await Future.delayed(const Duration(milliseconds: 300));

    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _slideInController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    _textTypeController.forward();
    setState(() {
      _isTextVisible = true;
    });

    await _speak("What did we learn?");

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnswerRevealed = true;
    });

    await _speak(
      "Adjectives are describing words that make nouns more interesting and colorful!",
    );
  }

  void _resetAnimations() {
    _slideInController.reset();
    _textTypeController.reset();
    _magicBrushController.reset();
    _catTransformController.reset();
    _labelFloatController.reset();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideInController.dispose();
    _textTypeController.dispose();
    _magicBrushController.dispose();
    _catTransformController.dispose();
    _labelFloatController.dispose();
    _pulseController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // Fixed height for modular use
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LColors.background, LColors.surface],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildSlide1(), // Plain Noun
            _buildSlide2(), // Adjective Magic
            _buildSlide3(), // Practice
            _buildSlide4(), // Summary
          ],
        ),
      ),
    );
  }

  Widget _buildSlide1() {
    return SlideTransition(
      position: _slideInAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            if (_isTextVisible)
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [LColors.blue, LColors.blue.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "What is a Noun?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Plain Cat
            Expanded(
              child: Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, size: 80, color: Colors.grey.shade600),
                      const SizedBox(height: 8),
                      Text(
                        "Plain Cat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Text Content
            if (_isTextVisible)
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: LColors.greyLight),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "This is a cat. A noun is the name of a person, place, animal or thing.",
                        style: TextStyle(
                          fontSize: 16,
                          color: LColors.greyDark,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      if (_showThinkingTime) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: LColors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ScaleTransition(
                                scale: _pulseAnimation,
                                child: Icon(
                                  Icons.help_outline,
                                  color: LColors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "What does this cat look like?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: LColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (_isAnswerRevealed) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: LColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb, color: LColors.success),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "We don't know yet!",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: LColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Continue Button
            if (_isAnswerRevealed) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextSlide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSlide2() {
    return SlideTransition(
      position: _slideInAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            if (_isTextVisible)
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LColors.success,
                        LColors.success.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "What Do Adjectives Do?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Magic Scene
            Expanded(
              child: Stack(
                children: [
                  // Transformed Cat
                  Center(
                    child: ScaleTransition(
                      scale: _catScaleAnimation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient:
                              _isCatTransformed
                                  ? LinearGradient(
                                    colors: [
                                      Colors.orange.shade700,
                                      Colors.orange.shade500,
                                      Colors.orange.shade300,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : null,
                          color:
                              _isCatTransformed ? null : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                _isCatTransformed
                                    ? Colors.orange.shade600
                                    : Colors.grey.shade400,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  _isCatTransformed
                                      ? Colors.orange.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.1),
                              blurRadius: _isCatTransformed ? 15 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.pets,
                                size: 80,
                                color:
                                    _isCatTransformed
                                        ? Colors.white
                                        : Colors.grey.shade600,
                              ),
                            ),

                            if (_isCatTransformed)
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 60),
                                  child: const Text(
                                    "✨ Fluffy ✨",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Magic Brush
                  if (_showMagicBrush)
                    SlideTransition(
                      position: _brushSlideAnimation,
                      child: Positioned(
                        top: 50,
                        left: 50,
                        child: AnimatedBuilder(
                          animation: _brushRotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _brushRotationAnimation.value,
                              child: Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.brown,
                                      Colors.orange,
                                      Colors.yellow,
                                      Colors.pink,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LColors.greyLight.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.brown,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            bottomLeft: Radius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange,
                                              Colors.yellow,
                                              Colors.pink,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Floating Adjective Labels
                  if (_showAdjectiveLabels) ...[
                    _buildFloatingLabel("Black", Colors.black87, 60, 120),
                    _buildFloatingLabel("Fluffy", Colors.blue, 200, 100),
                    _buildFloatingLabel("Cute", Colors.pink, 140, 240),
                  ],
                ],
              ),
            ),

            // Result Text
            if (_isAnswerRevealed) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      LColors.success.withOpacity(0.1),
                      Colors.orange.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: LColors.success.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.brush, color: LColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "This is a black, fluffy cat.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: LColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "🎨 Adjectives colour and describe the noun!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _nextSlide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Practice!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.quiz),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSlide3() {
    return SlideTransition(
      position: _slideInAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            if (_isTextVisible)
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LColors.warning,
                        LColors.warning.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "Let's Practice!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Practice Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: LColors.greyLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz, size: 60, color: LColors.warning),

                    const SizedBox(height: 20),

                    if (_isTextVisible) ...[
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: Text(
                          "Can you find the adjectives?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.greyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: LColors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: LColors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "The big, red balloon floats high",
                          style: TextStyle(
                            fontSize: 16,
                            color: LColors.blue,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      if (_isAnswerRevealed) ...[
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                LColors.success.withOpacity(0.1),
                                LColors.success.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: LColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: LColors.success,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Correct!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: LColors.success,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Big and red are adjectives!\nThey describe the balloon.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LColors.success,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            // Continue Button
            if (_isAnswerRevealed) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextSlide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.summarize),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSlide4() {
    return SlideTransition(
      position: _slideInAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            if (_isTextVisible)
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [LColors.blue, LColors.success],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "Summary",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Summary Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, LColors.surface],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: LColors.greyLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [LColors.success, LColors.blue],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_isTextVisible) ...[
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: Text(
                          "What did we learn?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: LColors.greyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (_isAnswerRevealed)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                LColors.success.withOpacity(0.1),
                                LColors.blue.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: LColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "🎨 Adjectives are describing words that make nouns more interesting and colorful!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: LColors.success,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "Ready to watch the full video lesson?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LColors.greyDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Complete Button
            if (_isAnswerRevealed) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextSlide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Watch Video",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingLabel(
    String text,
    Color color,
    double left,
    double top,
  ) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      left: left,
      top: top,
      child: FadeTransition(
        opacity: _labelOpacityAnimation,
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

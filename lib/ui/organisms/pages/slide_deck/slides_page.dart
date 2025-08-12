import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learnit/ui/atoms/colors.dart';

class SlidesPage extends StatefulWidget {
  final String topic;
  final String videoRoute;

  const SlidesPage({super.key, required this.topic, required this.videoRoute});

  @override
  State<SlidesPage> createState() => _SlidesPageState();
}

class _SlidesPageState extends State<SlidesPage> with TickerProviderStateMixin {
  PageController _pageController = PageController();
  FlutterTts _flutterTts = FlutterTts();

  int _currentSlide = 0;
  bool _isTextVisible = false;
  bool _isAnswerRevealed = false;
  bool _isCatPainted = false;
  bool _showAdjectiveLabel = false;

  // Animation controllers
  late AnimationController _textAnimationController;
  late AnimationController _catAnimationController;
  late AnimationController _paintBrushController;
  late AnimationController _colorAnimationController;
  late AnimationController _slideTransitionController;

  // Animations
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _paintBrushSlideAnimation;
  late Animation<double> _catScaleAnimation;
  late Animation<double> _colorOpacityAnimation;
  late Animation<Offset> _slideAnimation;

  // Slide content
  final List<SlideContent> _slides = [
    SlideContent(
      title: "What is a Noun?",
      question:
          "This is a cat. A noun is the name of a person, place, animal or thing.",
      interactiveQuestion: "What does this cat look like?",
      answer: "We don't know yet!",
      waitTime: 5,
    ),
    SlideContent(
      title: "What Do Adjectives Do?",
      question: "Watch what happens when adjectives come in...",
      interactiveQuestion: "",
      answer:
          "This is a black, fluffy cat. Adjectives colour and describe the noun!",
      waitTime: 8,
    ),
    SlideContent(
      title: "Let's Practice!",
      question: "Can you find the adjectives?",
      interactiveQuestion:
          "In the sentence 'The big, red balloon floats high', which words are adjectives?",
      answer: "Big and red are adjectives! They describe the balloon.",
      waitTime: 6,
    ),
    SlideContent(
      title: "Summary",
      question: "What did we learn?",
      interactiveQuestion: "",
      answer:
          "Adjectives are describing words that make nouns more interesting and colorful!",
      waitTime: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTTS();
    _startSlide();
  }

  void _initializeAnimations() {
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _catAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _paintBrushController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideTransitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _paintBrushSlideAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _paintBrushController, curve: Curves.elasticOut),
    );

    _catScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _catAnimationController, curve: Curves.bounceOut),
    );

    _colorOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorAnimationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideTransitionController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(0.8);
    await _flutterTts.setPitch(1.0);
  }

  void _startSlide() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Animate text in
    _textAnimationController.forward();
    setState(() {
      _isTextVisible = true;
    });

    // Speak the question
    await _speak(_slides[_currentSlide].question);

    if (_slides[_currentSlide].interactiveQuestion.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      await _speak(_slides[_currentSlide].interactiveQuestion);
    }

    // Wait and reveal answer
    await Future.delayed(Duration(seconds: _slides[_currentSlide].waitTime));
    _revealAnswer();
  }

  void _revealAnswer() async {
    setState(() {
      _isAnswerRevealed = true;
    });

    if (_currentSlide == 1) {
      // Special animation for adjective slide
      await _animateAdjectiveSlide();
    } else {
      // Regular answer reveal
      await _speak(_slides[_currentSlide].answer);
    }

    // Auto advance after answer or show continue button
    await Future.delayed(const Duration(seconds: 3));
    _showContinueButton();
  }

  Future<void> _animateAdjectiveSlide() async {
    // Animate paint brush coming in
    _paintBrushController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));

    // Paint the cat
    setState(() {
      _isCatPainted = true;
    });
    _catAnimationController.forward();
    _colorAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // Show adjective labels
    setState(() {
      _showAdjectiveLabel = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    await _speak(_slides[_currentSlide].answer);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _showContinueButton() {
    // Show continue button or auto-advance
    setState(() {});
  }

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      _resetAnimations();
      setState(() {
        _currentSlide++;
        _isTextVisible = false;
        _isAnswerRevealed = false;
        _isCatPainted = false;
        _showAdjectiveLabel = false;
      });

      _slideTransitionController.forward().then((_) {
        _slideTransitionController.reset();
        _startSlide();
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to video
      Navigator.pushReplacementNamed(context, widget.videoRoute);
    }
  }

  void _resetAnimations() {
    _textAnimationController.reset();
    _catAnimationController.reset();
    _paintBrushController.reset();
    _colorAnimationController.reset();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textAnimationController.dispose();
    _catAnimationController.dispose();
    _paintBrushController.dispose();
    _colorAnimationController.dispose();
    _slideTransitionController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: Text(
          '${widget.topic} - Interactive Learning',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentSlide + 1}/${_slides.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _slides.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildSlide(index),
          );
        },
      ),
      bottomNavigationBar: _buildBottomControls(),
    );
  }

  Widget _buildSlide(int index) {
    switch (index) {
      case 0:
        return _buildNounSlide();
      case 1:
        return _buildAdjectiveSlide();
      case 2:
        return _buildPracticeSlide();
      case 3:
        return _buildSummarySlide();
      default:
        return Container();
    }
  }

  Widget _buildNounSlide() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title
          FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LColors.blue.withOpacity(0.1),
                    LColors.blue.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: LColors.blue.withOpacity(0.3)),
              ),
              child: Text(
                _slides[0].title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LColors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Cat Image (Plain)
          Expanded(
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/plain_cat.png', // You'll need to add this
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 80,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Plain Cat',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Text Content
          if (_isTextVisible) ...[
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _slides[0].question,
                      style: TextStyle(
                        fontSize: 18,
                        color: LColors.greyDark,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (_slides[0].interactiveQuestion.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: LColors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline, color: LColors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _slides[0].interactiveQuestion,
                                style: TextStyle(
                                  fontSize: 16,
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
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: LColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: LColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb, color: LColors.success),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _slides[0].answer,
                                style: TextStyle(
                                  fontSize: 16,
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
          ],
        ],
      ),
    );
  }

  Widget _buildAdjectiveSlide() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title
          FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LColors.success.withOpacity(0.1),
                    LColors.success.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: LColors.success.withOpacity(0.3)),
              ),
              child: Text(
                _slides[1].title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LColors.success,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Magic Paint Scene
          Expanded(
            child: Stack(
              children: [
                // Cat (transforms from plain to colorful)
                Center(
                  child: ScaleTransition(
                    scale: _catScaleAnimation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: _isCatPainted ? null : Colors.grey.shade300,
                        gradient:
                            _isCatPainted
                                ? LinearGradient(
                                  colors: [
                                    Colors.brown.shade800,
                                    Colors.brown.shade600,
                                    Colors.orange.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                _isCatPainted
                                    ? Colors.orange.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                            blurRadius: _isCatPainted ? 15 : 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Cat icon/image
                            Center(
                              child: Icon(
                                Icons.pets,
                                size: 80,
                                color:
                                    _isCatPainted
                                        ? Colors.white
                                        : Colors.grey.shade600,
                              ),
                            ),

                            // Fluffy texture overlay
                            if (_isCatPainted)
                              FadeTransition(
                                opacity: _colorOpacityAnimation,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    backgroundBlendMode: BlendMode.overlay,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '✨ Fluffy ✨',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Magic Paint Brush
                SlideTransition(
                  position: _paintBrushSlideAnimation,
                  child: Positioned(
                    top: 50,
                    left: 50,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        width: 100,
                        height: 15,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.brown.shade600,
                              Colors.orange.shade400,
                              Colors.yellow.shade300,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade800,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange, Colors.yellow],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating Adjective Labels
                if (_showAdjectiveLabel) ...[
                  _buildFloatingLabel("Black", Colors.black, 80, 100),
                  _buildFloatingLabel("Fluffy", Colors.blue, 250, 120),
                  _buildFloatingLabel("Cute", Colors.pink, 150, 280),
                ],
              ],
            ),
          ),

          // Text Content
          if (_isTextVisible) ...[
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _slides[1].question,
                      style: TextStyle(
                        fontSize: 18,
                        color: LColors.greyDark,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (_isAnswerRevealed) ...[
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              LColors.success.withOpacity(0.1),
                              Colors.orange.withOpacity(0.1),
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
                              children: [
                                Icon(Icons.brush, color: LColors.success),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _slides[1].answer,
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
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
          ],
        ],
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
        opacity: _colorOpacityAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPracticeSlide() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title
          FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LColors.warning.withOpacity(0.1),
                    LColors.warning.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: LColors.warning.withOpacity(0.3)),
              ),
              child: Text(
                _slides[2].title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LColors.warning,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Practice Content
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.quiz, size: 80, color: LColors.warning),
                    const SizedBox(height: 24),

                    if (_isTextVisible) ...[
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Text(
                          _slides[2].question,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: LColors.greyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: LColors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: LColors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _slides[2].interactiveQuestion,
                          style: TextStyle(
                            fontSize: 18,
                            color: LColors.blue,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      if (_isAnswerRevealed) ...[
                        const SizedBox(height: 24),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                LColors.success.withOpacity(0.1),
                                LColors.success.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: LColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: LColors.success,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _slides[2].answer,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: LColors.success,
                                    height: 1.4,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySlide() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title
          FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [LColors.blue, LColors.blue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: LColors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                _slides[3].title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Summary Content
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.success,
                            LColors.success.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (_isTextVisible) ...[
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Text(
                          _slides[3].question,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: LColors.greyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              LColors.success.withOpacity(0.1),
                              Colors.blue.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: LColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "🎨 ${_slides[3].answer}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: LColors.success,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              "Ready to watch the full video lesson?",
                              style: TextStyle(
                                fontSize: 16,
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
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress Indicator
          Expanded(
            child: Row(
              children: List.generate(_slides.length, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          index <= _currentSlide
                              ? LColors.blue
                              : LColors.greyLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(width: 16),

          // Next Button
          if (_isAnswerRevealed)
            ElevatedButton(
              onPressed: _nextSlide,
              style: ElevatedButton.styleFrom(
                backgroundColor: LColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentSlide == _slides.length - 1
                        ? 'Watch Video'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentSlide == _slides.length - 1
                        ? Icons.play_arrow
                        : Icons.arrow_forward,
                    size: 20,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Data model for slide content
class SlideContent {
  final String title;
  final String question;
  final String interactiveQuestion;
  final String answer;
  final int waitTime;

  SlideContent({
    required this.title,
    required this.question,
    required this.interactiveQuestion,
    required this.answer,
    required this.waitTime,
  });
}

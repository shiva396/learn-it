import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learnit/ui/atoms/colors.dart';

class SlideModulePage extends StatefulWidget {
  final String moduleType;
  final VoidCallback? onComplete;

  const SlideModulePage({super.key, required this.moduleType, this.onComplete});

  @override
  State<SlideModulePage> createState() => _SlideModulePageState();
}

class _SlideModulePageState extends State<SlideModulePage>
    with TickerProviderStateMixin {
  late Widget _currentModule;

  @override
  void initState() {
    super.initState();
    _initializeModule();
  }

  void _initializeModule() {
    switch (widget.moduleType) {
      case 'adjectives':
        _currentModule = AdjectiveSlideModule(onComplete: widget.onComplete);
        break;
      default:
        _currentModule = _buildComingSoonModule();
    }
  }

  Widget _buildComingSoonModule() {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        title: const Text('Coming Soon', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'This module is under development',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentModule;
  }
}

// Enhanced Adjective Slide Module with Student-Friendly Features
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

  int _currentSlideIndex = 0;
  bool _showingPreview = true;

  // Animation controllers
  late AnimationController _slideAnimationController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Enhanced slide data structure with cat story
  List<Map<String, dynamic>> get _slideData => [
    {
      'title': 'Welcome, Young Explorer! 🌟',
      'icon': Icons.celebration,
      'color': LColors.blue,
      'showImage': false,
      'description':
          'Get ready for an amazing adventure into the world of words! Today, we\'re going to discover something magical that makes our language colorful and exciting.',
      'keyPoints': [
        '🎯 You\'re about to learn about ADJECTIVES!',
        '✨ These special words make stories come alive',
        '🚀 By the end, you\'ll be a word wizard!',
        '🎉 Let\'s start this incredible journey together!',
      ],
      'motivationalText':
          'Every great writer started just like you - curious and eager to learn!',
      'type': 'welcome',
    },
    {
      'title': 'What are Nouns? 🏷️',
      'icon': Icons.label_outline,
      'color': LColors.warning,
      'showImage': true,
      'imagePath': 'assets/images/slides/abstract_cute_cat.png',
      'description':
          'Before we learn adjectives, let\'s understand NOUNS. Nouns are words that name people, places, animals, or things.',
      'keyPoints': [
        '👤 People: teacher, student, friend',
        '🏠 Places: school, park, home',
        '🐱 Animals: cat, dog, bird',
        '📚 Things: book, pen, computer',
      ],
      'example':
          'Look at this shape. It\'s a "cat" - that\'s a NOUN! It names an animal.',
      'question':
          'But wait... can you imagine how this cat might look in real life? 🤔',
      'type': 'noun_intro',
    },
    {
      'title': 'Ta-Da! Meet Our Real Cat! 😻',
      'icon': Icons.pets,
      'color': LColors.success,
      'showImage': true,
      'imagePath': 'assets/images/slides/cute_cat.png',
      'description':
          'SURPRISE! Here\'s how our cat actually looks! Isn\'t it amazing how different it is from the simple shape?',
      'surpriseText': 'WOW! Look how BEAUTIFUL this cat is! 🌈',
      'keyPoints': [
        '😍 Notice how much more interesting this cat looks!',
        '🎨 We can see its colors, fur, and features',
        '✨ The simple noun "cat" became something wonderful!',
        '🔍 What words can describe this adorable cat?',
      ],
      'type': 'surprise_reveal',
    },
    {
      'title': 'The Magic of Adjectives! ✨',
      'icon': Icons.auto_fix_high,
      'color': LColors.achievement,
      'showImage': true,
      'imagePath': 'assets/images/slides/cute_cat.png',
      'description':
          'Those describing words are called ADJECTIVES! They make nouns come alive with details, colors, and feelings.',
      'adjectiveExamples': [
        {
          'word': 'FLUFFY',
          'color': LColors.blue,
          'description': 'describes the texture',
        },
        {
          'word': 'ORANGE',
          'color': LColors.warning,
          'description': 'describes the color',
        },
        {
          'word': 'CUTE',
          'color': LColors.success,
          'description': 'describes how it looks',
        },
        {
          'word': 'SMALL',
          'color': LColors.highlight,
          'description': 'describes the size',
        },
      ],
      'keyPoints': [
        '🎨 Adjectives add COLOR to our words',
        '📏 They tell us SIZE, SHAPE, and TEXTURE',
        '😊 They share FEELINGS and EMOTIONS',
        '⭐ They make writing EXCITING and VIVID!',
      ],
      'example':
          'Simple: "A cat sat." → Amazing: "A fluffy, orange, cute cat sat peacefully."',
      'type': 'adjective_magic',
    },
    {
      'title': 'Your Turn to Shine! 🌟',
      'icon': Icons.quiz,
      'color': LColors.highlight,
      'showImage': true,
      'imagePath': 'assets/images/slides/cute_cat.png',
      'description':
          'Now you know the secret! You can spot adjectives everywhere. Let\'s practice with our furry friend.',
      'practiceText':
          'Look at our cat again. Can you think of MORE adjectives to describe it?',
      'keyPoints': [
        '🤔 Think: What COLOR do you see?',
        '✋ Feel: How would its FUR feel?',
        '👀 Observe: What SIZE is it?',
        '💕 Emotions: How does it make you FEEL?',
      ],
      'interactiveChallenge':
          'Challenge: Find 3 adjectives that describe this cat!',
      'hints': ['Hint: Look at its fur, eyes, and expression! 🔍'],
      'type': 'practice',
    },
    {
      'title': 'Ready for More Magic? 🎬',
      'icon': Icons.play_circle_filled,
      'color': LColors.blue,
      'showImage': false,
      'description':
          'Fantastic work! You\'ve discovered the power of adjectives and how they transform simple nouns into vivid pictures.',
      'achievementBadge': true,
      'keyPoints': [
        '🎉 You learned what adjectives are',
        '🐱 You saw how they describe our cat',
        '✨ You practiced finding descriptive words',
        '🚀 You\'re ready for the next level!',
      ],
      'motivationalText':
          'You\'re becoming a true word wizard! Ready to discover even more secrets?',
      'videoCallText':
          'Let\'s dive deeper and watch an amazing video that will teach you everything about adjectives!',
      'type': 'video_transition',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTTS();

    // Show preview dialog after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showingPreview) {
        _showPreviewDialog();
      }
    });
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimationController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(0.8);
    await _flutterTts.setPitch(1.0);
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Engaging header with animation
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [LColors.blue, LColors.blue.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Exciting title
                  const Text(
                    'Ready for an Adventure? 🚀',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Engaging description
                  Text(
                    'Join us on an exciting adventure! We\'ll meet a mysterious cat, discover the magic of words, and become adjective wizards together! 🎭',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: LColors.greyDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Benefits container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          LColors.highlight.withOpacity(0.1),
                          LColors.blue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: LColors.blue.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.emoji_objects,
                              color: LColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'What you\'ll discover:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: LColors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...[
                          '🎉 Welcome adventure & encouragement',
                          '�️ Meet our mysterious abstract cat',
                          '😻 SURPRISE! See the real fluffy cat',
                          '✨ Discover the magic of adjectives',
                          '🎯 Practice with our cute furry friend',
                          '� Get ready for the amazing video!',
                        ].map(
                          (benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: LColors.greyDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _skipToVideo();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: LColors.greyLight),
                            ),
                          ),
                          child: const Text(
                            'Skip to Video',
                            style: TextStyle(
                              fontSize: 14,
                              color: LColors.greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _showingPreview = false;
                            });
                            _startSlideshow();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LColors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Let\'s Explore!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _startSlideshow() {
    // Add some haptic feedback for engagement
    HapticFeedback.lightImpact();

    // Start animations
    _slideAnimationController.forward();
  }

  void _skipToVideo() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void _nextSlide() {
    if (_currentSlideIndex < _slideData.length - 1) {
      setState(() {
        _currentSlideIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    } else {
      _completeSlideShow();
    }
  }

  void _previousSlide() {
    if (_currentSlideIndex > 0) {
      setState(() {
        _currentSlideIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _completeSlideShow() {
    HapticFeedback.mediumImpact();

    // Show completion animation/dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Celebration icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [LColors.success, LColors.achievement],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.celebration,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Awesome Job! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'You\'ve completed the adjective preview! Now you\'re ready to dive deeper with the video lesson.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: LColors.greyDark,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Motivation box
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
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.school, color: LColors.success, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Keep up the great work! Learning is a journey, and you\'re doing fantastic!',
                            style: TextStyle(
                              fontSize: 14,
                              color: LColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        if (widget.onComplete != null) {
                          widget.onComplete!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Start Video Lesson',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showingPreview) {
      return Scaffold(
        backgroundColor: LColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(LColors.blue),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Adjectives Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentSlideIndex + 1} / ${_slideData.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_currentSlideIndex + 1) / _slideData.length,
                backgroundColor: LColors.greyLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  LColors.success,
                ),
              ),
            ),
          ),

          // Slide Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSlideIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              itemCount: _slideData.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _slideAnimation,
                  builder:
                      (context, child) => _buildSlideContent(_slideData[index]),
                );
              },
            ),
          ),

          // Navigation Controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentSlideIndex > 0)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _previousSlide,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: TextButton.styleFrom(
                        foregroundColor: LColors.greyDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),

                const SizedBox(width: 16),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _nextSlide,
                    icon: Icon(
                      _currentSlideIndex < _slideData.length - 1
                          ? Icons.arrow_forward
                          : Icons.play_arrow,
                    ),
                    label: Text(
                      _currentSlideIndex < _slideData.length - 1
                          ? 'Next Slide'
                          : 'Start Video!',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _slideData[_currentSlideIndex]['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideContent(Map<String, dynamic> slide) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slide Header with Icon
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      slide['color'] as Color,
                      (slide['color'] as Color).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (slide['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  slide['icon'] as IconData,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              if (slide['achievementBadge'] == true) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [LColors.achievement, LColors.success],
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: LColors.achievement.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.stars, color: Colors.white, size: 32),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Slide Title
          Text(
            slide['title'] as String,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: LColors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          // Slide Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Surprise Text for reveal slide
                  if (slide['surpriseText'] != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.success.withOpacity(0.2),
                            LColors.achievement.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: LColors.success, width: 2),
                      ),
                      child: Text(
                        slide['surpriseText'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: LColors.success,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Image Display
                  if (slide['showImage'] == true &&
                      slide['imagePath'] != null) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            slide['imagePath'] as String,
                            height: slide['type'] == 'noun_intro' ? 150 : 200,
                            width: slide['type'] == 'noun_intro' ? 150 : 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: LColors.greyLight,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 60,
                                  color: LColors.greyDark,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description
                  Text(
                    slide['description'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      color: LColors.greyDark,
                      height: 1.6,
                    ),
                  ),

                  // Motivational Text for welcome slide
                  if (slide['motivationalText'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.highlight.withOpacity(0.15),
                            LColors.blue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: LColors.highlight.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: LColors.highlight,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              slide['motivationalText'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: LColors.greyDark,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Adjective Examples (for adjective magic slide)
                  if (slide['adjectiveExamples'] != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.psychology,
                                color: LColors.achievement,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Adjectives in Action:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.achievement,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...(slide['adjectiveExamples']
                                  as List<Map<String, dynamic>>)
                              .map(
                                (adj) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (adj['color'] as Color)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: adj['color'] as Color,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: adj['color'] as Color,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            adj['word'] as String,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            adj['description'] as String,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: adj['color'] as Color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],

                  // Key Points Section
                  if (slide['keyPoints'] != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: slide['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                slide['type'] == 'practice'
                                    ? 'Practice Time:'
                                    : 'Key Points:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: slide['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...((slide['keyPoints'] as List<String>).map(
                            (point) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 6,
                                      right: 12,
                                    ),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: slide['color'] as Color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: LColors.greyDark,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],

                  // Interactive Challenge for practice slide
                  if (slide['interactiveChallenge'] != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.highlight.withOpacity(0.15),
                            LColors.warning.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: LColors.highlight, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: LColors.highlight,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Challenge Time!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.highlight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            slide['interactiveChallenge'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: LColors.greyDark,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (slide['hints'] != null) ...[
                            const SizedBox(height: 8),
                            ...(slide['hints'] as List<String>).map(
                              (hint) => Text(
                                hint,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: LColors.greyDark,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // Question for noun intro slide
                  if (slide['question'] != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.warning.withOpacity(0.15),
                            LColors.highlight.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: LColors.warning.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.help_outline,
                            color: LColors.warning,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              slide['question'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                color: LColors.warning,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Practice Text for practice slide
                  if (slide['practiceText'] != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.highlight.withOpacity(0.1),
                            LColors.blue.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: LColors.highlight.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_objects,
                            color: LColors.highlight,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              slide['practiceText'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                color: LColors.greyDark,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Example Section
                  if (slide['example'] != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (slide['color'] as Color).withOpacity(0.1),
                            (slide['color'] as Color).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (slide['color'] as Color).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: slide['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Example',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: slide['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            slide['example'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: LColors.black,
                              height: 1.4,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Video Call to Action for final slide
                  if (slide['videoCallText'] != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.blue.withOpacity(0.15),
                            LColors.achievement.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: LColors.blue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [LColors.blue, LColors.achievement],
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Next Adventure Awaits!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide['videoCallText'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: LColors.greyDark,
                              height: 1.4,
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
      ),
    );
  }
}

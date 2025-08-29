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

  // Slide data structure
  List<Map<String, dynamic>> get _slideData => [
    {
      'title': 'What are Adjectives?',
      'icon': Icons.lightbulb_outline,
      'color': LColors.blue,
      'description':
          'Adjectives are special words that describe nouns (people, places, animals, or things).',
      'keyPoints': [
        'They make our writing more interesting and colorful',
        'They help us paint pictures with words',
        'They answer questions like "What kind?" or "How many?"',
      ],
      'example':
          'Look at this plain sentence: "The cat sat." Now with adjectives: "The fluffy, orange cat sat quietly."',
    },
    {
      'title': 'Types of Adjectives',
      'icon': Icons.category,
      'color': LColors.success,
      'description':
          'There are different types of adjectives that describe different things about nouns.',
      'keyPoints': [
        'Color adjectives: red, blue, green, purple',
        'Size adjectives: big, small, tiny, huge',
        'Shape adjectives: round, square, long, short',
        'Feeling adjectives: happy, sad, excited, calm',
      ],
      'example':
          'In "The small, round, red ball bounced high," we have three adjectives: small (size), round (shape), and red (color).',
    },
    {
      'title': 'Finding Adjectives',
      'icon': Icons.search,
      'color': LColors.warning,
      'description':
          'Let\'s practice finding adjectives in sentences. Look for words that describe nouns!',
      'keyPoints': [
        'Ask yourself: "What kind of _____ is it?"',
        'Look for descriptive words before nouns',
        'Remember: adjectives make sentences more vivid',
      ],
      'example':
          'Try this: "The brave knight rode his white horse through the dark forest." Can you find the adjectives? (Answer: brave, white, dark)',
    },
    {
      'title': 'You\'re Ready!',
      'icon': Icons.school,
      'color': LColors.achievement,
      'description':
          'Congratulations! You now understand how adjectives work and can spot them in sentences.',
      'keyPoints': [
        'You learned what adjectives are and why they\'re important',
        'You discovered different types of adjectives',
        'You practiced finding adjectives in sentences',
      ],
      'example':
          'Now you\'re ready to watch the video lesson and learn even more about using adjectives in your own writing!',
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
                    'Before we dive into the video, let\'s take a quick journey through ${_slideData.length} fun slides about adjectives!',
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
                          '✨ What makes adjectives so special',
                          '🎨 Different types of descriptive words',
                          '🔍 How to spot adjectives like a pro',
                          '🎯 Get ready for the main video lesson!',
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
                  // Description
                  Text(
                    slide['description'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      color: LColors.greyDark,
                      height: 1.6,
                    ),
                  ),

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
                                'Key Points:',
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

                  // Motivational Footer for Final Slide
                  if (_currentSlideIndex == _slideData.length - 1) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LColors.success.withOpacity(0.1),
                            LColors.blue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: LColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.celebration,
                                color: LColors.success,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'You\'re Ready!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.success,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Great job completing the preview! Now let\'s dive into the full video lesson to become an adjective expert! 🌟',
                            style: TextStyle(
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

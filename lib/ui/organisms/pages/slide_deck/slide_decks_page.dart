import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'adjective/adjective_deck.dart';

class SlideDecksPage extends StatefulWidget {
  const SlideDecksPage({super.key});

  @override
  State<SlideDecksPage> createState() => _SlideDecksPageState();
}

class _SlideDecksPageState extends State<SlideDecksPage>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late Animation<double> _fadeAnimation;

  final List<SlideModule> _slideModules = [
    SlideModule(
      id: 'adjectives',
      title: 'Adjectives',
      subtitle: 'Describing Words',
      description:
          'Learn how adjectives make nouns more colorful and interesting!',
      icon: Icons.palette,
      color: Colors.orange,
      isCompleted: false,
      progress: 0.0,
    ),
    SlideModule(
      id: 'verbs',
      title: 'Verbs',
      subtitle: 'Action Words',
      description: 'Discover action words that bring sentences to life!',
      icon: Icons.directions_run,
      color: Colors.green,
      isCompleted: false,
      progress: 0.0,
      isComingSoon: true,
    ),
    SlideModule(
      id: 'nouns',
      title: 'Nouns',
      subtitle: 'Naming Words',
      description:
          'Master the building blocks of sentences - people, places, and things!',
      icon: Icons.home,
      color: Colors.blue,
      isCompleted: false,
      progress: 0.0,
      isComingSoon: true,
    ),
    SlideModule(
      id: 'pronouns',
      title: 'Pronouns',
      subtitle: 'Replacement Words',
      description:
          'Learn words that replace nouns to make sentences flow better!',
      icon: Icons.swap_horiz,
      color: Colors.purple,
      isCompleted: false,
      progress: 0.0,
      isComingSoon: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _startEntryAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  void _openSlideModule(SlideModule module) {
    if (module.isComingSoon) {
      _showComingSoonDialog(module);
    } else {
      // Navigate to the specific slide module
      switch (module.id) {
        case 'adjectives':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SlideModulePage(
                    moduleType: 'adjectives',
                    onComplete: () {
                      setState(() {
                        module.isCompleted = true;
                        module.progress = 1.0;
                      });
                    },
                  ),
            ),
          );
          break;
        default:
          _showComingSoonDialog(module);
      }
    }
  }

  void _showComingSoonDialog(SlideModule module) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(module.icon, color: module.color, size: 30),
                const SizedBox(width: 12),
                Text(
                  module.title,
                  style: TextStyle(
                    color: module.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction,
                  size: 50,
                  color: Colors.orange.shade300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Coming Soon!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'This ${module.title.toLowerCase()} module is currently under development. Stay tuned for more amazing learning experiences!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: module.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Slide Deck Modules',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: LColors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: LColors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.slideshow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Interactive Learning',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Explore grammar concepts through engaging visual presentations',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Modules List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _slideModules.length,
                    itemBuilder: (context, index) {
                      final module = _slideModules[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 800 + (index * 200)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: _buildModuleCard(module, index),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(SlideModule module, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openSlideModule(module),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: module.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: module.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(module.icon, size: 24, color: Colors.white),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          module.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (module.isComingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Soon',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      module.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  module.isCompleted
                      ? Icons.check_circle
                      : module.isComingSoon
                      ? Icons.schedule
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Model
class SlideModule {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  bool isCompleted;
  double progress;
  final bool isComingSoon;

  SlideModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.progress = 0.0,
    this.isComingSoon = false,
  });
}

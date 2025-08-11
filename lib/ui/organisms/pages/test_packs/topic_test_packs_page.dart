import 'package:flutter/material.dart';
import 'package:learnit/data/test_packs_data/test_packs_data.dart';
import 'package:learnit/data/test_packs_data/test_pack_models.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/organisms/pages/test_packs/coming_soon_page.dart';

class TopicTestPacksPage extends StatefulWidget {
  final GrammarTopic topic;

  const TopicTestPacksPage({super.key, required this.topic});

  @override
  State<TopicTestPacksPage> createState() => _TopicTestPacksPageState();
}

class _TopicTestPacksPageState extends State<TopicTestPacksPage> {
  late TopicInfo topicInfo;
  late Color topicColor;

  @override
  void initState() {
    super.initState();
    topicInfo = TestPacksData.getTopicsList().firstWhere(
      (t) => t.topic == widget.topic,
    );
    topicColor = LColors.blue;
  }

  IconData _getTopicIcon(String topicName) {
    switch (topicName.toLowerCase()) {
      case 'adjectives':
        return Icons.palette;
      case 'nouns':
        return Icons.home;
      case 'pronouns':
        return Icons.person;
      case 'verbs':
        return Icons.directions_run;
      case 'adverbs':
        return Icons.flash_on;
      case 'prepositions':
        return Icons.place;
      case 'conjunctions':
        return Icons.link;
      case 'interjections':
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.book;
    }
  }

  String _getGrammarRoute(String topicName) {
    switch (topicName.toLowerCase()) {
      case 'adjectives':
        return '/grammar/adjectives';
      case 'nouns':
        return '/grammar/nouns';
      case 'pronouns':
        return '/grammar/pronouns';
      case 'verbs':
        return '/grammar/verbs';
      case 'adverbs':
        return '/grammar/adverbs';
      case 'prepositions':
        return '/grammar/prepositions';
      case 'conjunctions':
        return '/grammar/conjunctions';
      case 'interjections':
        return '/grammar/interjections';
      default:
        return '/grammar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final difficultyInfo = TestPacksData.getDifficultyInfo();

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: topicColor,
        elevation: 0,
        title: Column(
          children: [
            Text(
              topicInfo.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Choose Your Challenge Level',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topic Description Card (Now clickable to learn)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, _getGrammarRoute(topicInfo.name));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: topicColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            _getTopicIcon(topicInfo.name),
                            color: topicColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Learn ${topicInfo.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: topicColor,
                                ),
                              ),
                              Text(
                                'Read the complete grammar article',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: LColors.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: LColors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'TEST PACKS',
              style: TextStyle(
                color: LColors.greyDark,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Test Packs
            Expanded(
              child: ListView.builder(
                itemCount: DifficultyLevel.values.length,
                itemBuilder: (context, index) {
                  final difficulty = DifficultyLevel.values[index];
                  final info = difficultyInfo[difficulty]!;
                  return _TestPackTile(
                    topic: widget.topic,
                    difficulty: difficulty,
                    difficultyInfo: info,
                    topicColor: topicColor,
                    onTap: () {
                      // Check if topic is adjective (the only one with test questions)
                      if (widget.topic == GrammarTopic.adjective) {
                        Navigator.pushNamed(
                          context,
                          '/test_packs/test',
                          arguments: {
                            'topic': widget.topic,
                            'difficulty': difficulty,
                          },
                        );
                      } else {
                        // Show coming soon page for other topics
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ComingSoonPage(
                                  topicName: topicInfo.name,
                                  difficultyName: difficulty.name,
                                ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestPackTile extends StatelessWidget {
  final GrammarTopic topic;
  final DifficultyLevel difficulty;
  final Map<String, dynamic> difficultyInfo;
  final Color topicColor;
  final VoidCallback onTap;

  const _TestPackTile({
    required this.topic,
    required this.difficulty,
    required this.difficultyInfo,
    required this.topicColor,
    required this.onTap,
  });

  String _getDifficultyDescription() {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return '10 questions';
      case DifficultyLevel.medium:
        return '10 questions';
      case DifficultyLevel.hard:
        return '10 questions';
    }
  }

  IconData _getDifficultyIcon() {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Icons.sentiment_satisfied;
      case DifficultyLevel.medium:
        return Icons.sentiment_neutral;
      case DifficultyLevel.hard:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return LColors.success;
      case DifficultyLevel.medium:
        return LColors.warning;
      case DifficultyLevel.hard:
        return LColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getDifficultyColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: difficultyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getDifficultyIcon(),
                color: difficultyColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${difficultyInfo['name']} Test',
                        style: const TextStyle(
                          color: LColors.greyDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: topicColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${difficultyInfo['timeInMinutes']} min',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: topicColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _getDifficultyDescription(),
                    style: const TextStyle(color: LColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: LColors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

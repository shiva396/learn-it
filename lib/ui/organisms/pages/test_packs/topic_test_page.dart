import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/data/test_packs_data/test_packs_data.dart';
import 'package:learnit/data/test_packs_data/test_pack_models.dart';

class TopicTestPage extends StatelessWidget {
  const TopicTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TopicInfo topic =
        ModalRoute.of(context)!.settings.arguments as TopicInfo;
    final difficultyInfo = TestPacksData.getDifficultyInfo();

    Color topicColor;
    switch (topic.color) {
      case 'blue':
        topicColor = LColors.blue;
        break;
      case 'green':
        topicColor = LColors.success;
        break;
      case 'purple':
        topicColor = LColors.achievement;
        break;
      case 'orange':
        topicColor = LColors.warning;
        break;
      case 'red':
        topicColor = LColors.error;
        break;
      case 'teal':
        topicColor = LColors.highlight;
        break;
      case 'indigo':
        topicColor = LColors.levelUp;
        break;
      case 'pink':
        topicColor = Colors.pinkAccent;
        break;
      default:
        topicColor = LColors.blue;
    }

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: Text(
          '${topic.name} Tests',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: topicColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [topicColor.withOpacity(0.1), LColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(topic.emoji, style: const TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    Text(
                      topic.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: topicColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: LColors.greyDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Difficulty Selection
              Text(
                'Choose Difficulty Level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LColors.black,
                ),
              ),
              const SizedBox(height: 16),

              ...DifficultyLevel.values.map((difficulty) {
                final info = difficultyInfo[difficulty]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDifficultyCard(context, topic, difficulty, info),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Info Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: topicColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: topicColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: topicColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Test Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: topicColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Each test contains 10 questions\n'
                      '• Questions are multiple choice format\n'
                      '• Your progress will be saved automatically\n'
                      '• Review explanations after completion',
                      style: TextStyle(
                        fontSize: 13,
                        color: LColors.greyDark,
                        height: 1.5,
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

  Widget _buildDifficultyCard(
    BuildContext context,
    TopicInfo topic,
    DifficultyLevel difficulty,
    Map<String, dynamic> info,
  ) {
    final testPack = TestPacksData.getTestPack(topic.topic, difficulty);
    final isAvailable = testPack != null && testPack.questions.isNotEmpty;

    return GestureDetector(
      onTap:
          isAvailable
              ? () {
                Navigator.pushNamed(
                  context,
                  '/test_packs/test',
                  arguments: testPack,
                );
              }
              : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAvailable ? Colors.white : LColors.greyLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isAvailable
                  ? [
                    BoxShadow(
                      color: info['color'].withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
          border: Border.all(
            color:
                isAvailable
                    ? info['color'].withOpacity(0.3)
                    : LColors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    isAvailable
                        ? info['color'].withOpacity(0.1)
                        : LColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isAvailable ? info['icon'] : Icons.lock,
                color: isAvailable ? info['color'] : LColors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? LColors.black : LColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isAvailable ? LColors.greyDark : LColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAvailable
                        ? '${info['timeInMinutes']} minutes • 10 questions'
                        : 'Coming soon!',
                    style: TextStyle(
                      fontSize: 12,
                      color: isAvailable ? info['color'] : LColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isAvailable ? Icons.arrow_forward_ios : Icons.lock,
              color: isAvailable ? info['color'] : LColors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

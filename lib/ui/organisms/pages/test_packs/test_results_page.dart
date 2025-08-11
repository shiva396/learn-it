import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/data/test_packs_data/test_pack_models.dart';
import 'package:learnit/services/recent_activities_service.dart';

class TestResultsPage extends StatefulWidget {
  const TestResultsPage({super.key});

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  @override
  void initState() {
    super.initState();
    // Log the test completion after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logTestCompletion();
    });
  }

  void _logTestCompletion() async {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final TestPack testPack = arguments['testPack'];
    final int correctAnswers = arguments['correctAnswers'];
    final int totalQuestions = arguments['totalQuestions'];

    await RecentActivitiesService.logTestCompleted(
      testPack.topic.name,
      _getDifficultyString(testPack.difficulty),
      correctAnswers,
      totalQuestions,
    );
  }

  String _getDifficultyString(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final TestPack testPack = arguments['testPack'];
    final Map<String, int> userAnswers = arguments['userAnswers'];
    final int correctAnswers = arguments['correctAnswers'];
    final int totalQuestions = arguments['totalQuestions'];
    final int timeSpent = arguments['timeSpent'];

    final double percentage = (correctAnswers / totalQuestions) * 100;
    Color resultColor;
    String resultMessage;
    IconData resultIcon;

    if (percentage >= 80) {
      resultColor = LColors.success;
      resultMessage = 'Excellent!';
      resultIcon = Icons.celebration;
    } else if (percentage >= 60) {
      resultColor = LColors.warning;
      resultMessage = 'Good Job!';
      resultIcon = Icons.thumb_up;
    } else {
      resultColor = LColors.error;
      resultMessage = 'Keep Practicing!';
      resultIcon = Icons.school;
    }

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: resultColor,
        elevation: 0,
        title: const Text(
          'Test Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Result Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                  Icon(resultIcon, color: resultColor, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    resultMessage,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    testPack.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: LColors.greyDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        'Score',
                        '$correctAnswers/$totalQuestions',
                        resultColor,
                      ),
                      _buildStatItem(
                        'Percentage',
                        '${percentage.round()}%',
                        resultColor,
                      ),
                      _buildStatItem(
                        'Time',
                        '${_formatTime(timeSpent)}',
                        resultColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Questions Review
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Question Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...testPack.questions.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final TestQuestion question = entry.value;
                    final int? userAnswer = userAnswers[question.id];
                    final bool isCorrect =
                        userAnswer == question.correctAnswerIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isCorrect
                                ? LColors.success.withOpacity(0.1)
                                : LColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect ? LColors.success : LColors.error,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isCorrect
                                          ? LColors.success
                                          : LColors.error,
                                ),
                                child: Icon(
                                  isCorrect ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Question ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: LColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 12,
                              color: LColors.greyDark,
                            ),
                          ),
                          if (!isCorrect && question.explanation != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: LColors.highlight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                question.explanation!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: LColors.greyDark,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/tests',
                        (route) => route.settings.name == '/home',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LColors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Take Another Test',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: LColors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Go Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LColors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: LColors.greyDark),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/data/test_packs_data/test_pack_models.dart';
import 'package:learnit/data/test_packs_data/test_packs_data.dart';

class TestPackTestPage extends StatefulWidget {
  const TestPackTestPage({super.key});

  @override
  State<TestPackTestPage> createState() => _TestPackTestPageState();
}

class _TestPackTestPageState extends State<TestPackTestPage> {
  TestPack? testPack;
  int currentQuestionIndex = 0;
  Map<String, int> userAnswers = {};
  Timer? timer;
  int remainingTimeInSeconds = 0;
  bool testCompleted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (testPack == null) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final GrammarTopic topic = arguments['topic'];
      final DifficultyLevel difficulty = arguments['difficulty'];

      testPack = TestPacksData.getTestPack(topic, difficulty);
      if (testPack != null) {
        remainingTimeInSeconds = testPack!.timeInMinutes * 60;
        startTimer();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testPack = ModalRoute.of(context)!.settings.arguments as TestPack;
      remainingTimeInSeconds = testPack!.timeInMinutes * 60;
      startTimer();
      setState(() {});
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimeInSeconds > 0) {
        setState(() {
          remainingTimeInSeconds--;
        });
      } else {
        timer.cancel();
        completeTest();
      }
    });
  }

  void selectAnswer(int answerIndex) {
    if (testPack == null) return;
    setState(() {
      userAnswers[testPack!.questions[currentQuestionIndex].id] = answerIndex;
    });
  }

  void nextQuestion() {
    if (testPack == null) return;
    if (currentQuestionIndex < testPack!.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      completeTest();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void completeTest() {
    timer?.cancel();
    setState(() {
      testCompleted = true;
    });

    if (testPack == null) return;

    // Calculate score
    int correctAnswers = 0;
    for (var question in testPack!.questions) {
      final userAnswer = userAnswers[question.id];
      if (userAnswer != null && userAnswer == question.correctAnswerIndex) {
        correctAnswers++;
      }
    }

    // Navigate to results
    Navigator.pushReplacementNamed(
      context,
      '/test_packs/results',
      arguments: {
        'testPack': testPack,
        'userAnswers': userAnswers,
        'correctAnswers': correctAnswers,
        'totalQuestions': testPack!.questions.length,
        'timeSpent': (testPack!.timeInMinutes * 60) - remainingTimeInSeconds,
      },
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color getTopicColor() {
    if (testPack == null) return LColors.blue;
    switch (testPack!.topic) {
      case GrammarTopic.adjective:
        return LColors.blue;
      case GrammarTopic.noun:
        return LColors.success;
      case GrammarTopic.pronoun:
        return LColors.achievement;
      case GrammarTopic.verb:
        return LColors.warning;
      case GrammarTopic.adverb:
        return LColors.error;
      case GrammarTopic.preposition:
        return LColors.highlight;
      case GrammarTopic.conjunction:
        return LColors.levelUp;
      case GrammarTopic.interjection:
        return Colors.pinkAccent;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (testPack == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (testPack == null || testPack!.questions.isEmpty) {
      return Scaffold(
        backgroundColor: LColors.background,
        appBar: AppBar(
          title: const Text('Test Not Available'),
          backgroundColor: getTopicColor(),
        ),
        body: const Center(
          child: Text(
            'This test is not available yet.\nPlease check back later!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final currentQuestion = testPack!.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / testPack!.questions.length;

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: Text(
          testPack!.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: getTopicColor(),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  remainingTimeInSeconds <= 60
                      ? LColors.error.withOpacity(0.2)
                      : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color:
                      remainingTimeInSeconds <= 60
                          ? LColors.error
                          : Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  formatTime(remainingTimeInSeconds),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        remainingTimeInSeconds <= 60
                            ? LColors.error
                            : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of ${testPack!.questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LColors.black,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        color: getTopicColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: LColors.greyLight,
                  valueColor: AlwaysStoppedAnimation<Color>(getTopicColor()),
                  minHeight: 6,
                ),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Card
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question',
                          style: TextStyle(
                            fontSize: 14,
                            color: getTopicColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.black,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Options
                  Text(
                    'Choose the correct answer:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = userAnswers[currentQuestion.id] == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => selectAnswer(index),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? getTopicColor().withOpacity(0.1)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? getTopicColor()
                                      : LColors.greyLight,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: getTopicColor().withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected
                                          ? getTopicColor()
                                          : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? getTopicColor()
                                            : LColors.grey,
                                    width: 2,
                                  ),
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${String.fromCharCode(65 + index)}. $option',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isSelected
                                            ? getTopicColor()
                                            : LColors.black,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: previousQuestion,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: getTopicColor(), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: getTopicColor(),
                        ),
                      ),
                    ),
                  ),

                if (currentQuestionIndex > 0) const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        userAnswers.containsKey(currentQuestion.id)
                            ? nextQuestion
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getTopicColor(),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: LColors.greyLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 3,
                    ),
                    child: Text(
                      currentQuestionIndex == testPack!.questions.length - 1
                          ? 'Finish Test'
                          : 'Next Question',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}

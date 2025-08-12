import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnit/data/assessment.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AssessmentTestPage extends StatefulWidget {
  const AssessmentTestPage({super.key});

  @override
  State<AssessmentTestPage> createState() => _AssessmentTestPageState();
}

class _AssessmentTestPageState extends State<AssessmentTestPage> {
  late List<TestSection> _testSections;
  int _currentSectionIndex = 0;
  int _currentQuestionIndex = 0;
  Map<String, int> _userAnswers = {};
  Timer? _timer;
  int _timeRemainingSeconds = 0;
  Map<TestType, int> _timeSpent = {};
  DateTime? _sectionStartTime;

  @override
  void initState() {
    super.initState();
    _testSections = AssessmentData.getTestSections();
    _initializeCurrentSection();
  }

  void _initializeCurrentSection() {
    if (_currentSectionIndex < _testSections.length) {
      _timeRemainingSeconds =
          _testSections[_currentSectionIndex].timeInMinutes * 60;
      _sectionStartTime = DateTime.now();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemainingSeconds > 0) {
          _timeRemainingSeconds--;
        } else {
          _timeUp();
        }
      });
    });
  }

  void _timeUp() {
    _timer?.cancel();
    _saveTimeSpent();
    _showTimeUpDialog();
  }

  void _saveTimeSpent() {
    if (_sectionStartTime != null &&
        _currentSectionIndex < _testSections.length) {
      final currentSection = _testSections[_currentSectionIndex];
      final timeSpent = DateTime.now().difference(_sectionStartTime!).inSeconds;
      _timeSpent[currentSection.type] = timeSpent;
    }
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: LColors.warning, width: 1),
            ),
            title: const Row(
              children: [
                Icon(Icons.timer_off, color: LColors.warning),
                SizedBox(width: 8),
                Text("Time's Up!"),
              ],
            ),
            content: const Text(
              "Don't worry! Let's move to the next challenge.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextSection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Continue"),
              ),
            ],
          ),
    );
  }

  void _selectAnswer(int answerIndex) {
    final currentQuestion = _getCurrentQuestion();
    setState(() {
      _userAnswers[currentQuestion.id] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _getCurrentSection().questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _nextSection();
    }
  }

  void _nextSection() {
    _timer?.cancel();
    _saveTimeSpent();

    if (_currentSectionIndex < _testSections.length - 1) {
      setState(() {
        _currentSectionIndex++;
        _currentQuestionIndex = 0;
      });
      _initializeCurrentSection();
    } else {
      _completeAssessment();
    }
  }

  void _completeAssessment() async {
    _timer?.cancel();

    // Calculate results
    final result = _calculateResults();

    // Save result to storage
    await AssessmentData.saveAssessmentResult(result);

    // Navigate to analytics page
    Navigator.pushReplacementNamed(
      context,
      '/assessment/analytics',
      arguments: result,
    );
  }

  AssessmentResult _calculateResults() {
    Map<TestType, int> sectionScores = {};
    int totalScore = 0;
    int totalPossible = 0;

    for (TestSection section in _testSections) {
      int sectionScore = 0;
      for (AssessmentQuestion question in section.questions) {
        totalPossible++;
        final userAnswer = _userAnswers[question.id];
        if (userAnswer != null && userAnswer == question.correctAnswerIndex) {
          sectionScore++;
          totalScore++;
        }
      }
      sectionScores[section.type] = sectionScore;
    }

    final overallPercentage = (totalScore / totalPossible) * 100;

    final result = AssessmentResult(
      studentId: "student_001", // This would come from auth
      completedAt: DateTime.now(),
      sectionScores: sectionScores,
      timeSpent: _timeSpent,
      totalScore: totalScore,
      totalPossibleScore: totalPossible,
      overallPercentage: overallPercentage,
      cognitiveAnalysis: {},
    );

    result.cognitiveAnalysis.addAll(
      AssessmentData.calculateCognitiveAnalysis(result),
    );

    return result;
  }

  TestSection _getCurrentSection() => _testSections[_currentSectionIndex];
  AssessmentQuestion _getCurrentQuestion() =>
      _getCurrentSection().questions[_currentQuestionIndex];

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSectionIndex >= _testSections.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentSection = _getCurrentSection();
    final currentQuestion = _getCurrentQuestion();
    final progress =
        (_currentSectionIndex +
            (_currentQuestionIndex + 1) / currentSection.questions.length) /
        _testSections.length;

    return Scaffold(
      backgroundColor: LColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and timer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            currentSection.icon,
                            color: currentSection.themeColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currentSection.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LColors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _timeRemainingSeconds <= 60
                                  ? LColors.error.withOpacity(0.1)
                                  : LColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                _timeRemainingSeconds <= 60
                                    ? LColors.error
                                    : LColors.success,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color:
                                  _timeRemainingSeconds <= 60
                                      ? LColors.error
                                      : LColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(_timeRemainingSeconds),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    _timeRemainingSeconds <= 60
                                        ? LColors.error
                                        : LColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: LColors.greyLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            currentSection.themeColor,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${_currentQuestionIndex + 1}/${currentSection.questions.length}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: LColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Question Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Progress
                    Text(
                      "Section ${_currentSectionIndex + 1} of ${_testSections.length}",
                      style: TextStyle(
                        fontSize: 14,
                        color: currentSection.themeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Question
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
                            "Question ${_currentQuestionIndex + 1}",
                            style: TextStyle(
                              fontSize: 14,
                              color: currentSection.themeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Image if present
                          if (currentQuestion.imagePath != null) ...[
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: LColors.greyLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: LColors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Image.asset(
                                currentQuestion.imagePath!,
                                fit: BoxFit.fitWidth,
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Icon(
                              //       Icons.image,
                              //       size: 48,
                              //       color: LColors.grey,
                              //     ),
                              //     const SizedBox(height: 8),
                              //     Text(
                              //       "Image will be here",
                              //       style: TextStyle(
                              //         color: LColors.grey,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //     Text(
                              //       currentQuestion.imagePath!,
                              //       style: TextStyle(
                              //         color: LColors.grey,
                              //         fontSize: 10,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          Text(
                            currentQuestion.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: LColors.black,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Answer Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          final isSelected =
                              _userAnswers[currentQuestion.id] == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _selectAnswer(index),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? currentSection.themeColor
                                              .withOpacity(0.1)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? currentSection.themeColor
                                            : LColors.greyLight,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
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
                                                ? currentSection.themeColor
                                                : Colors.transparent,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? currentSection.themeColor
                                                  : LColors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "${String.fromCharCode(65 + index)}. ${currentQuestion.options[index]}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                          color: LColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0 || _currentSectionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (_currentQuestionIndex > 0) {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: LColors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: LColors.greyDark,
                          ),
                        ),
                      ),
                    ),

                  if (_currentQuestionIndex > 0 || _currentSectionIndex > 0)
                    const SizedBox(width: 12),

                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          _userAnswers.containsKey(currentQuestion.id)
                              ? _nextQuestion
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentSection.themeColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: LColors.greyLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 3,
                      ),
                      child: Text(
                        _currentQuestionIndex ==
                                currentSection.questions.length - 1
                            ? (_currentSectionIndex == _testSections.length - 1
                                ? "Finish Assessment"
                                : "Next Section")
                            : "Next Question",
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
      ),
    );
  }
}

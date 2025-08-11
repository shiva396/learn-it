import 'package:flutter/material.dart';
import 'package:learnit/data/assessment.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/molecules/confetti_animation.dart';

class AssessmentAnalyticsPage extends StatelessWidget {
  const AssessmentAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AssessmentResult result = ModalRoute.of(context)!.settings.arguments as AssessmentResult;
    final cognitiveAbilities = AssessmentData.generateCognitiveFeedback(result.cognitiveAnalysis);
    
    // Check if we should show confetti for good scores
    final shouldShowConfetti = result.overallPercentage >= 70;
    
    return ConfettiAnimation(
      shouldAnimate: shouldShowConfetti,
      child: Scaffold(
      backgroundColor: LColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [LColors.blue, LColors.highlight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "🎉 Assessment Complete!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Great job! Here's what we discovered about your amazing brain!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                      child: Column(
                        children: [
                          const Text(
                            "Your Overall Score",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LColors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: result.overallPercentage / 100,
                                  strokeWidth: 12,
                                  backgroundColor: LColors.greyLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getScoreColor(result.overallPercentage),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${result.overallPercentage.round()}%",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: LColors.black,
                                    ),
                                  ),
                                  Text(
                                    "${result.totalScore}/${result.totalPossibleScore}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: LColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getOverallFeedback(result.overallPercentage),
                            style: const TextStyle(
                              fontSize: 16,
                              color: LColors.greyDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          _buildScoreBasedMessage(result.overallPercentage),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Cognitive Abilities Section
                    const Text(
                      "🧠 Your Thinking Skills",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: LColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Each bar shows how well you did in different types of thinking!",
                      style: TextStyle(
                        fontSize: 14,
                        color: LColors.greyDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Cognitive Abilities Cards
                    ...cognitiveAbilities.map((ability) => _buildAbilityCard(ability)),

                    const SizedBox(height: 24),

                    // Section Performance
                    const Text(
                      "📊 How You Did in Each Challenge",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: LColors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...AssessmentData.getTestSections().map((section) => 
                      _buildSectionPerformance(section, result.sectionScores[section.type] ?? 0)
                    ),

                    const SizedBox(height: 24),

                    // Time Management
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
                          const Row(
                            children: [
                              Icon(Icons.timer, color: LColors.warning, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "⏰ Your Time Management",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getTimeManagementFeedback(result.timeSpent),
                            style: const TextStyle(
                              fontSize: 14,
                              color: LColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Motivational Message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [LColors.success.withOpacity(0.1), LColors.highlight.withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: LColors.success.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 40,
                            color: LColors.warning,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "You're Amazing!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getMotivationalMessage(result.overallPercentage),
                            style: const TextStyle(
                              fontSize: 14,
                              color: LColors.greyDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (result.overallPercentage < 50) {
                      // Show option to retake test for low scores
                      _showRetakeDialog(context, result);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        result.overallPercentage < 50 ? Icons.refresh : Icons.home, 
                        size: 24
                      ),
                      const SizedBox(width: 8),
                      Text(
                        result.overallPercentage < 50 
                          ? "Improve Score 💪" 
                          : "Start Learning! 🚀",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildAbilityCard(CognitiveAbility ability) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ability.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(ability.icon, color: ability.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ability.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: LColors.black,
                        ),
                      ),
                      Text(
                        ability.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: LColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${ability.percentage.round()}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ability.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ability.percentage / 100,
              backgroundColor: LColors.greyLight,
              valueColor: AlwaysStoppedAnimation<Color>(ability.color),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              ability.feedback,
              style: const TextStyle(
                fontSize: 13,
                color: LColors.greyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionPerformance(TestSection section, int score) {
    final percentage = (score / section.questions.length) * 100;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: section.themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(section.icon, color: section.themeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: LColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: LColors.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(section.themeColor),
                    minHeight: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "$score/${section.questions.length}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: section.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return LColors.success;
    if (percentage >= 60) return LColors.warning;
    return LColors.error;
  }

  String _getOverallFeedback(double percentage) {
    if (percentage >= 90) return "Outstanding! You're a superstar thinker! 🌟";
    if (percentage >= 80) return "Excellent work! Your brain is amazing! 🎯";
    if (percentage >= 70) return "Great job! You're a smart cookie! 🍪";
    if (percentage >= 60) return "Good effort! Keep practicing and you'll get even better! 💪";
    if (percentage >= 50) return "Nice try! Every expert was once a beginner! 🌱";
    return "You did your best! That's what matters most! Keep learning! 🚀";
  }

  String _getTimeManagementFeedback(Map<TestType, int> timeSpent) {
    if (timeSpent.isEmpty) return "You managed your time well during the assessment!";
    
    final totalTime = timeSpent.values.fold(0, (sum, time) => sum + time);
    final avgTimePerSection = totalTime / timeSpent.length;
    
    if (avgTimePerSection <= 300) { // 5 minutes average
      return "Wow! You're quick and efficient! ⚡ You finished sections faster than expected!";
    } else if (avgTimePerSection <= 600) { // 10 minutes average
      return "Great time management! 👍 You took just the right amount of time to think!";
    } else {
      return "You're a careful thinker! 🤔 Taking time to think shows you care about doing well!";
    }
  }

  String _getMotivationalMessage(double percentage) {
    final messages = [
      "Remember, every genius started as a beginner! Keep learning, keep growing! 🌟",
      "Your brain is like a muscle - the more you use it, the stronger it gets! 💪",
      "Mistakes are proof that you're trying! Every mistake teaches you something new! 📚",
      "You have a unique way of thinking that makes you special! 🦄",
      "Learning is an adventure, and you're the brave explorer! 🗺️",
    ];
    
    return messages[percentage.round() % messages.length];
  }

  Widget _buildScoreBasedMessage(double percentage) {
    if (percentage >= 70) {
      // Good score - celebratory message
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: LColors.success, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Fantastic job! You're a superstar learner! 🌟",
                style: TextStyle(
                  color: LColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (percentage >= 50) {
      // Mid score - encouraging message
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.thumb_up, color: LColors.warning, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Great effort! Keep practicing and you'll become even stronger! 💪",
                style: TextStyle(
                  color: LColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Low score - motivational message with retry option
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LColors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: LColors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Every expert was once a beginner! Let's learn and try again! 🚀",
                style: TextStyle(
                  color: LColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showRetakeDialog(BuildContext context, AssessmentResult result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.refresh, color: LColors.blue),
              const SizedBox(width: 8),
              const Text("Try Again?"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Would you like to take the assessment again to improve your score? Practice makes perfect!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                "💡 Tip: Review the questions you found challenging and try again when you're ready!",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: LColors.greyDark,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Text("Maybe Later"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/assessment/intro',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: LColors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Try Again!"),
            ),
          ],
        );
      },
    );
  }
}

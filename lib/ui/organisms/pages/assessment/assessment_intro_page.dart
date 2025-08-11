import 'package:flutter/material.dart';
import 'package:learnit/data/assessment.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AssessmentIntroPage extends StatelessWidget {
  const AssessmentIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Welcome Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [LColors.blue.withOpacity(0.1), LColors.highlight.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 80,
                              color: LColors.blue,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "🎯 Cognitive Skills Assessment",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: LColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Let's discover your amazing thinking skills!",
                              style: TextStyle(
                                fontSize: 16,
                                color: LColors.greyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Assessment Info
                      Container(
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
                                Icon(Icons.info_outline, color: LColors.blue, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "What You'll Do:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: LColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoItem(
                              icon: Icons.extension,
                              title: "7 Fun Challenges",
                              description: "Word puzzles, math problems, and thinking games!",
                              color: LColors.grammar,
                            ),
                            _buildInfoItem(
                              icon: Icons.timer,
                              title: "About 45 Minutes",
                              description: "Each section has its own timer - no rush!",
                              color: LColors.warning,
                            ),
                            _buildInfoItem(
                              icon: Icons.analytics,
                              title: "Your Results",
                              description: "See your strengths and areas to improve!",
                              color: LColors.success,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Test Sections Preview
                      Container(
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
                                Icon(Icons.view_list, color: LColors.highlight, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Your Challenges:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: LColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...AssessmentData.getTestSections().map((section) => 
                              _buildSectionPreview(section)
                            ).toList(),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Important Notes
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: LColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: LColors.warning.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: LColors.warning, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Important Tips:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: LColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTipItem("🎯 Do your best - there are no wrong answers!"),
                            _buildTipItem("⏰ Each section has a timer, but don't worry!"),
                            _buildTipItem("🤔 Take your time to think carefully"),
                            _buildTipItem("✨ This helps us understand how you learn best"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Start Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/assessment/test');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Start My Assessment! 🚀",
                        style: TextStyle(
                          fontSize: 18,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: LColors.greyDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPreview(TestSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: section.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(section.icon, color: section.themeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: LColors.black,
                  ),
                ),
                Text(
                  "${section.questions.length} questions • ${section.timeInMinutes} min",
                  style: const TextStyle(
                    fontSize: 11,
                    color: LColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        tip,
        style: const TextStyle(
          fontSize: 13,
          color: LColors.greyDark,
        ),
      ),
    );
  }
}

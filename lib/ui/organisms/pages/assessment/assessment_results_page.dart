import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/data/assessment.dart';

class AssessmentResultsPage extends StatefulWidget {
  const AssessmentResultsPage({super.key});

  @override
  State<AssessmentResultsPage> createState() => _AssessmentResultsPageState();
}

class _AssessmentResultsPageState extends State<AssessmentResultsPage> {
  List<AssessmentResult> _assessmentHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssessmentHistory();
  }

  Future<void> _loadAssessmentHistory() async {
    try {
      final history = await AssessmentData.loadAssessmentResults();
      setState(() {
        _assessmentHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: LColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Assessment Results",
          style: TextStyle(
            color: LColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: LColors.blue),
            onPressed: _loadAssessmentHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(LColors.blue),
              ),
            )
          : _assessmentHistory.isEmpty
              ? _buildEmptyState()
              : _buildResultsList(),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 80,
            color: LColors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Assessment Results Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LColors.greyDark,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Take your first cognitive assessment to see your results here!",
            style: TextStyle(
              fontSize: 16,
              color: LColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/assessment/intro');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LColors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Take Assessment",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                  Icons.timeline,
                  size: 50,
                  color: LColors.blue,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Assessment History",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: LColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${_assessmentHistory.length} assessments completed",
                  style: const TextStyle(
                    fontSize: 14,
                    color: LColors.greyDark,
                  ),
                ),
                if (_assessmentHistory.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        "Best Score",
                        "${_getBestScore().round()}%",
                        Icons.star,
                        LColors.success,
                      ),
                      _buildStatCard(
                        "Latest Score", 
                        "${_assessmentHistory.first.overallPercentage.round()}%",
                        Icons.new_releases,
                        LColors.blue,
                      ),
                      _buildStatCard(
                        "Average",
                        "${_getAverageScore().round()}%",
                        Icons.trending_up,
                        LColors.warning,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Recent Results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _assessmentHistory.length,
              itemBuilder: (context, index) {
                final result = _assessmentHistory[index];
                return _buildResultCard(result, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: LColors.greyDark,
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(AssessmentResult result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getScoreColor(result.overallPercentage).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getScoreIcon(result.overallPercentage),
                      color: _getScoreColor(result.overallPercentage),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assessment #${_assessmentHistory.length - index}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: LColors.black,
                        ),
                      ),
                      Text(
                        _formatDate(result.completedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: LColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${result.overallPercentage.round()}%",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(result.overallPercentage),
                    ),
                  ),
                  Text(
                    "${result.totalScore}/${result.totalPossibleScore}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: LColors.greyDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: LColors.greyLight),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat("Logic", result.cognitiveAnalysis["logicalReasoning"] ?? 0),
              ),
              Expanded(
                child: _buildMiniStat("Verbal", result.cognitiveAnalysis["verbalSkills"] ?? 0),
              ),
              Expanded(
                child: _buildMiniStat("Math", result.cognitiveAnalysis["numericalAbility"] ?? 0),
              ),
              Expanded(
                child: _buildMiniStat("Memory", result.cognitiveAnalysis["workingMemory"] ?? 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, double score) {
    final percentage = (score * 100).round();
    return Column(
      children: [
        Text(
          "$percentage%",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: LColors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: LColors.greyDark,
          ),
        ),
      ],
    );
  }

  double _getBestScore() {
    if (_assessmentHistory.isEmpty) return 0;
    return _assessmentHistory.map((result) => result.overallPercentage).reduce((a, b) => a > b ? a : b);
  }

  double _getAverageScore() {
    if (_assessmentHistory.isEmpty) return 0;
    final sum = _assessmentHistory.map((result) => result.overallPercentage).reduce((a, b) => a + b);
    return sum / _assessmentHistory.length;
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return LColors.success;
    if (percentage >= 60) return LColors.warning;
    return LColors.error;
  }

  IconData _getScoreIcon(double percentage) {
    if (percentage >= 80) return Icons.star;
    if (percentage >= 60) return Icons.thumb_up;
    return Icons.trending_up;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference < 7) {
      return "$difference days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}

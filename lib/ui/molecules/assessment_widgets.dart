import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final IconData icon;
  final String progressText;

  const ProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.icon,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: LColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                progressText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: LColors.greyLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class ScoreCircle extends StatelessWidget {
  final double percentage;
  final String label;
  final double size;

  const ScoreCircle({
    super.key,
    required this.percentage,
    required this.label,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(percentage);
    
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: size * 0.08,
                  backgroundColor: LColors.greyLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${percentage.round()}%",
                    style: TextStyle(
                      fontSize: size * 0.18,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: LColors.greyDark,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return LColors.success;
    if (percentage >= 60) return LColors.warning;
    return LColors.error;
  }
}

class AssessmentSectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int questionsCount;
  final int timeMinutes;
  final VoidCallback? onTap;

  const AssessmentSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.questionsCount,
    required this.timeMinutes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: LColors.greyDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.quiz, size: 16, color: LColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "$questionsCount questions",
                        style: const TextStyle(
                          fontSize: 12,
                          color: LColors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.timer, size: 16, color: LColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "$timeMinutes min",
                        style: const TextStyle(
                          fontSize: 12,
                          color: LColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class CognitiveSkillBar extends StatelessWidget {
  final String skillName;
  final String description;
  final double percentage;
  final Color color;
  final IconData icon;
  final String feedback;

  const CognitiveSkillBar({
    super.key,
    required this.skillName,
    required this.description,
    required this.percentage,
    required this.color,
    required this.icon,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      skillName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LColors.black,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: LColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${percentage.round()}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: LColors.greyLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: const TextStyle(
              fontSize: 13,
              color: LColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}

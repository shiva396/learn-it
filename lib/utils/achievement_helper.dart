import 'package:flutter/material.dart';
import 'package:learnit/services/streak_service.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AchievementHelper {
  /// Show achievement popup when user unlocks something new
  static Future<void> checkAndShowAchievements(BuildContext context) async {
    final streakData = await StreakService.getStreakStatus();
    final levelData = await StreakService.getLearningLevel();

    final currentStreak = streakData['currentStreak'] ?? 0;
    final totalActivities = levelData['totalActivities'] ?? 0;

    List<Achievement> newAchievements = [];

    // Check for streak achievements
    if (currentStreak == 3) {
      newAchievements.add(
        Achievement(
          emoji: '🔥',
          title: 'First Streak!',
          description: 'You completed 3 days in a row! Keep it up!',
          color: LColors.streak,
        ),
      );
    }

    if (currentStreak == 7) {
      newAchievements.add(
        Achievement(
          emoji: '⭐',
          title: 'Weekly Star!',
          description: 'Amazing! You learned for a whole week straight!',
          color: LColors.achievement,
        ),
      );
    }

    if (currentStreak == 14) {
      newAchievements.add(
        Achievement(
          emoji: '🎯',
          title: 'Dedication Master!',
          description: 'Two weeks of consistent learning! You\'re unstoppable!',
          color: LColors.levelUp,
        ),
      );
    }

    // Check for activity achievements
    if (totalActivities == 10) {
      newAchievements.add(
        Achievement(
          emoji: '📚',
          title: 'Bookworm!',
          description: 'You\'ve completed 10 learning activities!',
          color: LColors.grammar,
        ),
      );
    }

    if (totalActivities == 50) {
      newAchievements.add(
        Achievement(
          emoji: '🏆',
          title: 'Grammar Champion!',
          description: 'Wow! 50 activities completed! You\'re a true champion!',
          color: LColors.success,
        ),
      );
    }

    if (totalActivities == 100) {
      newAchievements.add(
        Achievement(
          emoji: '👑',
          title: 'Learning Legend!',
          description: 'Incredible! 100 activities! You\'re a learning legend!',
          color: LColors.highlight,
        ),
      );
    }

    // Show achievements
    for (Achievement achievement in newAchievements) {
      await _showAchievementDialog(context, achievement);
    }
  }

  static Future<void> _showAchievementDialog(
    BuildContext context,
    Achievement achievement,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  achievement.color.withOpacity(0.1),
                  achievement.color.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Achievement Animation Effect
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: achievement.color.withOpacity(0.1),
                    border: Border.all(
                      color: achievement.color.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      achievement.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Achievement Unlocked!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: achievement.color,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: LColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: LColors.greyDark,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: achievement.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Continue Learning!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get motivational messages based on progress
  static List<String> getMotivationalMessages(int streak, int totalActivities) {
    List<String> messages = [];

    if (streak == 0) {
      messages.add("Ready to start your learning journey? You've got this! 🚀");
    } else if (streak < 3) {
      messages.add("Great start! You're building a fantastic habit! 💪");
    } else if (streak < 7) {
      messages.add("Amazing streak! You're becoming a learning champion! 🎯");
    } else if (streak < 14) {
      messages.add("Incredible dedication! You're on fire! 🔥");
    } else {
      messages.add("WOW! You're a true learning superstar! Keep it up! ⭐");
    }

    if (totalActivities >= 50) {
      messages.add("You've mastered so many grammar concepts! 🎓");
    } else if (totalActivities >= 25) {
      messages.add("You're becoming a grammar expert! 📚");
    } else if (totalActivities >= 10) {
      messages.add("Look how much you've learned already! 🌟");
    }

    return messages;
  }

  /// Get learning tips for 6th graders
  static List<String> getLearningTips() {
    return [
      "📝 Try reading your lessons out loud - it helps with understanding!",
      "🎯 Set a small goal each day - even 10 minutes makes a difference!",
      "🤝 Practice with friends or family - grammar can be fun together!",
      "📚 Use new words you learn in everyday conversations!",
      "⭐ Celebrate small wins - every correct answer counts!",
      "🔄 Review yesterday's lesson before starting something new!",
      "🎨 Create colorful notes or drawings to remember rules!",
      "🕒 Learn at the same time each day to build a routine!",
    ];
  }

  /// Get age-appropriate encouragement
  static List<String> getEncouragementMessages() {
    return [
      "You're doing amazing! Grammar is becoming your superpower! 🦸‍♀️",
      "Every day you learn, you grow stronger and smarter! 💪",
      "Your brain is like a muscle - the more you use it, the stronger it gets! 🧠",
      "Making mistakes is how we learn - keep going! 🌱",
      "You're not just learning grammar, you're becoming a better communicator! 💬",
      "Each lesson brings you closer to mastering English! 🎯",
      "Your dedication is inspiring! Keep up the fantastic work! ⭐",
      "Learning is an adventure, and you're the hero of your story! 🗡️",
    ];
  }
}

class Achievement {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  Achievement({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}

import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakCountKey = 'streak_count';
  static const String _lastActivityDateKey = 'last_activity_date';
  static const String _totalActivitiesKey = 'total_activities';
  static const String _weeklyGoalKey = 'weekly_goal';
  static const String _currentWeekActivitiesKey = 'current_week_activities';
  static const String _longestStreakKey = 'longest_streak';
  static const String _totalHoursKey = 'total_hours_spent';
  static const String _sessionStartKey = 'session_start_time';
  static const String _lastSessionDateKey = 'last_session_date';

  /// Start a new app session
  static Future<void> startSession() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_sessionStartKey, now.toIso8601String());

    // Check if it's a new day and automatically record activity
    await _checkAndUpdateDailyActivity();
  }

  /// End current app session and record time spent
  static Future<void> endSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionStartString = prefs.getString(_sessionStartKey);

    if (sessionStartString != null) {
      final sessionStart = DateTime.parse(sessionStartString);
      final sessionEnd = DateTime.now();
      final hoursSpent = sessionEnd.difference(sessionStart).inMinutes / 60.0;

      // Only count meaningful sessions (at least 1 minute)
      if (hoursSpent >= 0.0167) {
        // 1 minute = 0.0167 hours
        final totalHours = await getTotalHours();
        await prefs.setDouble(_totalHoursKey, totalHours + hoursSpent);
      }

      // Clear session start
      await prefs.remove(_sessionStartKey);
    }
  }

  /// Get total hours spent in the app
  static Future<double> getTotalHours() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_totalHoursKey) ?? 0.0;
  }

  /// Private method to check and update daily activity automatically
  static Future<void> _checkAndUpdateDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastSessionString = prefs.getString(_lastSessionDateKey);

    // Check if we've already counted today
    bool shouldCountToday = true;
    if (lastSessionString != null) {
      final lastSession = DateTime.parse(lastSessionString);
      final lastSessionDate = DateTime(
        lastSession.year,
        lastSession.month,
        lastSession.day,
      );
      if (lastSessionDate.isAtSameMomentAs(today)) {
        shouldCountToday = false; // Already counted today
      }
    }

    if (shouldCountToday) {
      await _recordDailyActivity();
      await prefs.setString(_lastSessionDateKey, today.toIso8601String());
    }
  }

  /// Private method to record daily activity (called automatically)
  static Future<void> _recordDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActivityString = prefs.getString(_lastActivityDateKey);

    // Update total activities
    final totalActivities = await getTotalActivities();
    await prefs.setInt(_totalActivitiesKey, totalActivities + 1);

    // Update weekly activities
    final currentWeek = _getCurrentWeekKey();
    final weeklyCount =
        prefs.getInt('${_currentWeekActivitiesKey}_$currentWeek') ?? 0;
    await prefs.setInt(
      '${_currentWeekActivitiesKey}_$currentWeek',
      weeklyCount + 1,
    );

    // Update streak logic
    if (lastActivityString != null) {
      final lastActivity = DateTime.parse(lastActivityString);
      final lastActivityDate = DateTime(
        lastActivity.year,
        lastActivity.month,
        lastActivity.day,
      );
      final daysDifference = today.difference(lastActivityDate).inDays;

      if (daysDifference == 1) {
        // Consecutive day - increment streak
        final currentStreak = await getCurrentStreak();
        await prefs.setInt(_streakCountKey, currentStreak + 1);

        // Update longest streak if needed
        final longestStreak = await getLongestStreak();
        if (currentStreak + 1 > longestStreak) {
          await prefs.setInt(_longestStreakKey, currentStreak + 1);
        }
      } else if (daysDifference > 1) {
        // Break in streak - reset to 1
        await prefs.setInt(_streakCountKey, 1);
      }
    } else {
      // First activity ever
      await prefs.setInt(_streakCountKey, 1);
      await prefs.setInt(_longestStreakKey, 1);
    }

    // Update last activity date
    await prefs.setString(_lastActivityDateKey, today.toIso8601String());
  }

  /// Get current streak count
  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  /// Get longest streak achieved
  static Future<int> getLongestStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_longestStreakKey) ?? 0;
  }

  /// Get total learning activities completed
  static Future<int> getTotalActivities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalActivitiesKey) ?? 0;
  }

  /// Get weekly goal (default 5 activities)
  static Future<int> getWeeklyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weeklyGoalKey) ?? 5;
  }

  /// Get current week's activities count
  static Future<int> getCurrentWeekActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final currentWeek = _getCurrentWeekKey();
    return prefs.getInt('${_currentWeekActivitiesKey}_$currentWeek') ?? 0;
  }

  /// Record a learning activity and update streak (DEPRECATED - use automatic tracking)
  static Future<void> recordActivity() async {
    // This method is now deprecated as activities are recorded automatically
    // But keeping it for backward compatibility
    await _recordDailyActivity();
  }

  /// Check if streak is still valid (hasn't been broken)
  static Future<bool> validateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityString = prefs.getString(_lastActivityDateKey);

    if (lastActivityString == null) return false;

    final lastActivity = DateTime.parse(lastActivityString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysDifference = today.difference(lastActivity).inDays;

    if (daysDifference > 1) {
      // Streak is broken - reset
      await prefs.setInt(_streakCountKey, 0);
      return false;
    }

    return true;
  }

  /// Get streak status and motivation message
  static Future<Map<String, dynamic>> getStreakStatus() async {
    await validateStreak();
    final currentStreak = await getCurrentStreak();
    final longestStreak = await getLongestStreak();
    final weeklyGoal = await getWeeklyGoal();
    final weeklyProgress = await getCurrentWeekActivities();
    final totalHours = await getTotalHours();

    String motivationMessage;
    String streakEmoji;

    if (currentStreak == 0) {
      motivationMessage = "Start your learning journey today! 🚀";
      streakEmoji = "🌱";
    } else if (currentStreak < 3) {
      motivationMessage = "Great start! Keep the momentum going! 💪";
      streakEmoji = "🔥";
    } else if (currentStreak < 7) {
      motivationMessage = "You're on fire! Amazing progress! 🎯";
      streakEmoji = "🔥";
    } else if (currentStreak < 14) {
      motivationMessage =
          "Incredible dedication! You're a grammar champion! 🏆";
      streakEmoji = "🚀";
    } else {
      motivationMessage = "WOW! You're a learning superstar! 🌟";
      streakEmoji = "⭐";
    }

    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'weeklyProgress': weeklyProgress,
      'weeklyGoal': weeklyGoal,
      'totalHours': totalHours,
      'motivationMessage': motivationMessage,
      'streakEmoji': streakEmoji,
      'weeklyPercentage':
          (weeklyProgress / weeklyGoal * 100).clamp(0, 100).round(),
    };
  }

  /// Get time-based achievement badge
  static Future<Map<String, dynamic>> getTimeBasedBadge() async {
    final totalHours = await getTotalHours();

    String badge;
    String title;
    String description;
    bool isUnlocked = true;

    if (totalHours < 1) {
      badge = "⏰";
      title = "First Steps";
      description = "Spend 1 hour learning";
      isUnlocked = false;
    } else if (totalHours < 5) {
      badge = "📚";
      title = "Dedicated Learner";
      description = "5 hours of learning";
    } else if (totalHours < 10) {
      badge = "🎯";
      title = "Focused Student";
      description = "10 hours of learning";
    } else if (totalHours < 25) {
      badge = "🏆";
      title = "Study Champion";
      description = "25 hours of learning";
    } else if (totalHours < 50) {
      badge = "🌟";
      title = "Learning Star";
      description = "50 hours of learning";
    } else if (totalHours < 100) {
      badge = "💎";
      title = "Study Master";
      description = "100 hours of learning";
    } else {
      badge = "👑";
      title = "Learning Legend";
      description = "${totalHours.toInt()}+ hours of dedication";
    }

    return {
      'badge': badge,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'totalHours': totalHours,
    };
  }

  /// Get learning level based on total activities
  static Future<Map<String, dynamic>> getLearningLevel() async {
    final totalActivities = await getTotalActivities();

    int level;
    String title;
    int nextLevelActivities;
    String badge;

    if (totalActivities < 10) {
      level = 1;
      title = "Grammar Beginner";
      nextLevelActivities = 10;
      badge = "🌱";
    } else if (totalActivities < 25) {
      level = 2;
      title = "Word Explorer";
      nextLevelActivities = 25;
      badge = "🔍";
    } else if (totalActivities < 50) {
      level = 3;
      title = "Grammar Detective";
      nextLevelActivities = 50;
      badge = "🕵️";
    } else if (totalActivities < 100) {
      level = 4;
      title = "Language Master";
      nextLevelActivities = 100;
      badge = "🎓";
    } else if (totalActivities < 200) {
      level = 5;
      title = "Grammar Champion";
      nextLevelActivities = 200;
      badge = "🏆";
    } else {
      level = 6;
      title = "Language Legend";
      nextLevelActivities = totalActivities + 50; // Always growing
      badge = "⭐";
    }

    final progressToNext = ((totalActivities / nextLevelActivities) * 100)
        .clamp(0, 100);

    return {
      'level': level,
      'title': title,
      'totalActivities': totalActivities,
      'nextLevelActivities': nextLevelActivities,
      'progressToNext': progressToNext.round(),
      'badge': badge,
    };
  }

  /// Get current week key for weekly tracking
  static String _getCurrentWeekKey() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final weekNumber = ((now.difference(startOfYear).inDays) / 7).floor();
    return '${now.year}_$weekNumber';
  }

  /// Reset all streak data (for testing or reset functionality)
  static Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakCountKey);
    await prefs.remove(_lastActivityDateKey);
    await prefs.remove(_totalActivitiesKey);
    await prefs.remove(_longestStreakKey);
    await prefs.remove(_totalHoursKey);
    await prefs.remove(_sessionStartKey);
    await prefs.remove(_lastSessionDateKey);

    // Also clean up weekly data
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_currentWeekActivitiesKey)) {
        await prefs.remove(key);
      }
    }
  }
}

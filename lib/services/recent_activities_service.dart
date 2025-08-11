import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum ActivityType { videoWatched, testCompleted, grammarLearned, gamePlayed }

class ActivityItem {
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String? additionalData;

  ActivityItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'title': title,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'additionalData': additionalData,
    };
  }

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      type: ActivityType.values[json['type']],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      additionalData: json['additionalData'],
    );
  }
}

class RecentActivitiesService {
  static const String _activitiesKey = 'recent_activities';
  static const int _maxActivities = 50; // Keep last 50 activities

  static Future<void> logVideoWatched(String videoTitle) async {
    await _logActivity(
      ActivityItem(
        type: ActivityType.videoWatched,
        title: 'Video Watched',
        description: videoTitle,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<void> logTestCompleted(
    String testTopic,
    String difficulty,
    int score,
    int totalQuestions,
  ) async {
    await _logActivity(
      ActivityItem(
        type: ActivityType.testCompleted,
        title: 'Test Completed',
        description: '$testTopic - $difficulty',
        timestamp: DateTime.now(),
        additionalData: '$score/$totalQuestions',
      ),
    );
  }

  static Future<void> logGrammarLearned(String grammarTopic) async {
    await _logActivity(
      ActivityItem(
        type: ActivityType.grammarLearned,
        title: 'Grammar Studied',
        description: grammarTopic,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<void> logGamePlayed(
    String gameName,
    String grammarTopic,
  ) async {
    await _logActivity(
      ActivityItem(
        type: ActivityType.gamePlayed,
        title: 'Game Played',
        description: gameName,
        timestamp: DateTime.now(),
        additionalData: grammarTopic,
      ),
    );
  }

  static Future<void> _logActivity(ActivityItem activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getRecentActivities();

    activities.insert(0, activity); // Add to beginning

    // Keep only the latest activities
    if (activities.length > _maxActivities) {
      activities.removeRange(_maxActivities, activities.length);
    }

    final activitiesJson = activities.map((a) => a.toJson()).toList();
    await prefs.setString(_activitiesKey, jsonEncode(activitiesJson));
  }

  static Future<List<ActivityItem>> getRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString(_activitiesKey);

    if (activitiesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(activitiesJson);
    return decoded.map((json) => ActivityItem.fromJson(json)).toList();
  }

  static Future<List<ActivityItem>> getActivitiesByType(
    ActivityType type,
  ) async {
    final activities = await getRecentActivities();
    return activities.where((activity) => activity.type == type).toList();
  }

  static Future<void> clearAllActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activitiesKey);
  }
}

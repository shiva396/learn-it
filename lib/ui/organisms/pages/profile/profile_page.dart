import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learnit/services/streak_service.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/molecules/profile_widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isLoading = true;
  Map<String, dynamic> _streakData = {};
  Map<String, dynamic> _levelData = {};
  String _userName = 'Guest';
  String _lastLogin = 'Unknown';
  String _userAvatar = '👦'; // Default avatar

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      // Load basic user info
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName') ?? 'Grammar Explorer';
      _lastLogin = prefs.getString('lastLogin') ?? 'Today';

      // Load selected avatar
      final selectedAvatarIndex = prefs.getInt('selectedAvatar') ?? 0;
      const avatarEmojis = [
        '👦',
        '👧',
        '🦸‍♂️',
        '🦸‍♀️',
        '👨‍🎓',
        '👩‍🎓',
        '🧑‍💻',
        '👨‍🏫',
        '👩‍🏫',
        '🧙‍♂️',
        '🧙‍♀️',
        '👨‍🚀',
        '👩‍🚀',
        '🦄',
        '🐱',
        '🐶',
        '🐸',
        '🦊',
        '🐺',
        '🐻',
        '🐼',
        '🐨',
        '🦁',
        '🐯',
      ];
      _userAvatar =
          avatarEmojis[selectedAvatarIndex.clamp(0, avatarEmojis.length - 1)];

      // Load streak and level data
      final streakData = await StreakService.getStreakStatus();
      final levelData = await StreakService.getLearningLevel();

      setState(() {
        _streakData = streakData;
        _levelData = levelData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  void _initializeProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    prefs.setString('lastLogin', '${now.day}/${now.month}/${now.year}');
  }

  Future<List<Map<String, dynamic>>> _getAchievements() async {
    final currentStreak = _streakData['currentStreak'] ?? 0;
    final totalActivities = _levelData['totalActivities'] ?? 0;
    final longestStreak = _streakData['longestStreak'] ?? 0;

    // Get time-based badge
    final timeBadge = await StreakService.getTimeBasedBadge();

    return [
      {
        'emoji': '🔥',
        'title': 'First Streak',
        'description': 'Complete 3 days in a row',
        'isUnlocked': currentStreak >= 3 || longestStreak >= 3,
      },
      {
        'emoji': '📚',
        'title': 'Bookworm',
        'description': 'Complete 10 activities',
        'isUnlocked': totalActivities >= 10,
      },
      {
        'emoji': '⭐',
        'title': 'Weekly Star',
        'description': 'Complete 7 days streak',
        'isUnlocked': currentStreak >= 7 || longestStreak >= 7,
      },
      // Time-based achievement
      {
        'emoji': timeBadge['badge'],
        'title': timeBadge['title'],
        'description': timeBadge['description'],
        'isUnlocked': timeBadge['isUnlocked'],
      },
      {
        'emoji': '🏆',
        'title': 'Grammar Champion',
        'description': 'Complete 50 activities',
        'isUnlocked': totalActivities >= 50,
      },
      {
        'emoji': '🎯',
        'title': 'Dedication',
        'description': '14 days streak',
        'isUnlocked': currentStreak >= 14 || longestStreak >= 14,
      },
      {
        'emoji': '👑',
        'title': 'Learning Legend',
        'description': 'Complete 100 activities',
        'isUnlocked': totalActivities >= 100,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: LColors.background,
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          backgroundColor: LColors.blueDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadProfileData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(
              userName: _userName,
              userLevel: _levelData['title'] ?? 'Learning Explorer',
              userBadge:
                  _userAvatar, // Use selected avatar instead of level badge
              currentStreak: _streakData['currentStreak'] ?? 0,
              streakEmoji: _streakData['streakEmoji'] ?? '🔥',
            ),

            // Motivation Message
            if (_streakData['motivationMessage'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MotivationCard(
                  message: _streakData['motivationMessage'],
                  icon: Icons.lightbulb,
                  color: LColors.highlight,
                ),
              ),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.local_fire_department,
                          title: 'Current Streak',
                          value: '${_streakData['currentStreak'] ?? 0}',
                          subtitle: 'days',
                          color: LColors.streak,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.star,
                          title: 'Longest Streak',
                          value: '${_streakData['longestStreak'] ?? 0}',
                          subtitle: 'days',
                          color: LColors.achievement,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.school,
                          title: 'Level ${_levelData['level'] ?? 1}',
                          value: '${_levelData['totalActivities'] ?? 0}',
                          subtitle: 'activities completed',
                          color: LColors.levelUp,
                          progress:
                              (_levelData['progressToNext'] ?? 0).toDouble(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.access_time,
                          title: 'Study Time',
                          value:
                              '${(_streakData['totalHours'] ?? 0.0).toStringAsFixed(1)}h',
                          subtitle: 'total hours',
                          color: LColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Achievement Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getAchievements(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final achievements = snapshot.data!;
                  final unlockedCount =
                      achievements.where((a) => a['isUnlocked']).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: LColors.achievement),
                          const SizedBox(width: 8),
                          Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LColors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: LColors.achievement.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$unlockedCount/${achievements.length}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: LColors.achievement,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = achievements[index];
                          return AchievementBadge(
                            emoji: achievement['emoji'],
                            title: achievement['title'],
                            description: achievement['description'],
                            isUnlocked: achievement['isUnlocked'],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Settings and Info - Updated with navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person_outline,
                            color: LColors.blue,
                          ),
                          title: Text('Profile Details'),
                          subtitle: Text('Last login: $_lastLogin'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: LColors.grey,
                          ),
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/profile/details',
                            );
                            if (result == true) {
                              // Profile was updated, refresh data
                              await _loadProfileData();
                            }
                          },
                        ),
                        Divider(height: 1, color: LColors.greyLight),
                        ListTile(
                          leading: Icon(
                            Icons.psychology,
                            color: LColors.vocabulary,
                          ),
                          title: Text('Assessment Results'),
                          subtitle: Text('View your cognitive skills analysis'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: LColors.grey,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/assessment/results');
                          },
                        ),
                        Divider(height: 1, color: LColors.greyLight),

                        ListTile(
                          leading: Icon(
                            Icons.info_outline,
                            color: LColors.highlight,
                          ),
                          title: Text('About Learn-IT'),
                          subtitle: Text('Version 2.0 • Grammar Made Simple'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: LColors.grey,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/profile/about');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text('Logout'),
                                content: Text(
                                  'Are you sure you want to logout? Your progress will be saved.',
                                  style: TextStyle(color: LColors.greyDark),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: LColors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _logout();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(color: LColors.error),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: Icon(Icons.logout, color: LColors.error),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: LColors.error, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

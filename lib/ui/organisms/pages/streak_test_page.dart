import 'package:flutter/material.dart';
import 'package:learnit/services/streak_service.dart';
import 'package:learnit/ui/atoms/colors.dart';

class StreakTestPage extends StatefulWidget {
  const StreakTestPage({Key? key}) : super(key: key);

  @override
  State<StreakTestPage> createState() => _StreakTestPageState();
}

class _StreakTestPageState extends State<StreakTestPage> {
  Map<String, dynamic> _streakData = {};
  Map<String, dynamic> _levelData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final streakData = await StreakService.getStreakStatus();
    final levelData = await StreakService.getLearningLevel();

    setState(() {
      _streakData = streakData;
      _levelData = levelData;
      _isLoading = false;
    });
  }

  Future<void> _recordActivity() async {
    await StreakService.recordActivity();
    await _loadData();
    _showSnackBar('Activity recorded! 🎉');
  }

  Future<void> _resetData() async {
    await StreakService.resetAllData();
    await _loadData();
    _showSnackBar('All data reset! 🔄');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: LColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: const Text(
          'Streak Tracker Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: LColors.blueDark,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Streak Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: LColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              'Current Streak',
                              '${_streakData['currentStreak']} days',
                            ),
                            _buildInfoRow(
                              'Longest Streak',
                              '${_streakData['longestStreak']} days',
                            ),
                            _buildInfoRow(
                              'Weekly Progress',
                              '${_streakData['weeklyProgress']}/${_streakData['weeklyGoal']}',
                            ),
                            _buildInfoRow(
                              'Weekly %',
                              '${_streakData['weeklyPercentage']}%',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _streakData['motivationMessage'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: LColors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Level Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learning Level',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: LColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  _levelData['badge'] ?? '🌱',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level ${_levelData['level']} - ${_levelData['title']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: LColors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_levelData['totalActivities']} activities completed',
                                        style: TextStyle(
                                          color: LColors.greyDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: (_levelData['progressToNext'] ?? 0) / 100,
                              backgroundColor: LColors.greyLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                LColors.levelUp,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_levelData['progressToNext']}% to next level',
                              style: TextStyle(
                                fontSize: 12,
                                color: LColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _recordActivity,
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        label: const Text(
                          'Record Learning Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _resetData,
                        icon: Icon(Icons.refresh, color: LColors.error),
                        label: Text(
                          'Reset All Data (Testing)',
                          style: TextStyle(
                            color: LColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: LColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instructions
                    Card(
                      color: LColors.highlight.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info, color: LColors.highlight),
                                const SizedBox(width: 8),
                                Text(
                                  'How it works',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: LColors.highlight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Tap "Record Activity" to simulate completing a learning task\n'
                              '• Streaks count consecutive days of learning\n'
                              '• Complete activities to gain levels and unlock achievements\n'
                              '• Weekly goals help maintain consistency\n'
                              '• Your progress is automatically saved offline',
                              style: TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: LColors.greyDark)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: LColors.black),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learnit/ui/atoms/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _dailyReminders = true;
  bool _achievementAlerts = true;
  bool _streakReminders = true;
  int _weeklyGoal = 5;
  String _reminderTime = '19:00';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _dailyReminders = prefs.getBool('daily_reminders') ?? true;
      _achievementAlerts = prefs.getBool('achievement_alerts') ?? true;
      _streakReminders = prefs.getBool('streak_reminders') ?? true;
      _weeklyGoal = prefs.getInt('weekly_goal') ?? 5;
      _reminderTime = prefs.getString('reminder_time') ?? '19:00';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('daily_reminders', _dailyReminders);
    await prefs.setBool('achievement_alerts', _achievementAlerts);
    await prefs.setBool('streak_reminders', _streakReminders);
    await prefs.setInt('weekly_goal', _weeklyGoal);
    await prefs.setString('reminder_time', _reminderTime);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved successfully!'),
        backgroundColor: LColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_reminderTime.split(':')[0]),
        minute: int.parse(_reminderTime.split(':')[1]),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: LColors.blue)),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _reminderTime =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      });
      await _saveSettings();
    }
  }

  void _showWeeklyGoalDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Set Weekly Goal',
              style: TextStyle(
                color: LColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How many days per week do you want to learn?',
                  style: TextStyle(color: LColors.greyDark),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      [1, 2, 3, 4, 5, 6, 7].map((goal) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _weeklyGoal = goal;
                            });
                            Navigator.pop(context);
                            _saveSettings();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  goal == _weeklyGoal
                                      ? LColors.blue
                                      : LColors.greyLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                goal.toString(),
                                style: TextStyle(
                                  color:
                                      goal == _weeklyGoal
                                          ? Colors.white
                                          : LColors.greyDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: LColors.grey)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: LColors.background,
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(color: Colors.white)),
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
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Learning Goals Section
            _buildSectionCard(
              title: 'Learning Goals',
              icon: Icons.flag,
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_view_week, color: LColors.blue),
                  title: const Text('Weekly Goal'),
                  subtitle: Text('Learn $_weeklyGoal days per week'),
                  trailing: Icon(Icons.edit, color: LColors.grey),
                  onTap: _showWeeklyGoalDialog,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notifications Section
            _buildSectionCard(
              title: 'Notifications',
              icon: Icons.notifications,
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Allow app to send you notifications'),
                  value: _notificationsEnabled,
                  activeColor: LColors.blue,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                      if (!value) {
                        _dailyReminders = false;
                        _achievementAlerts = false;
                        _streakReminders = false;
                      }
                    });
                    _saveSettings();
                  },
                ),
                if (_notificationsEnabled) ...[
                  SwitchListTile(
                    title: const Text('Daily Reminders'),
                    subtitle: const Text('Remind me to practice daily'),
                    value: _dailyReminders,
                    activeColor: LColors.blue,
                    onChanged: (value) {
                      setState(() {
                        _dailyReminders = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Achievement Alerts'),
                    subtitle: const Text(
                      'Notify me when I unlock achievements',
                    ),
                    value: _achievementAlerts,
                    activeColor: LColors.blue,
                    onChanged: (value) {
                      setState(() {
                        _achievementAlerts = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Streak Reminders'),
                    subtitle: const Text('Alert me when my streak is at risk'),
                    value: _streakReminders,
                    activeColor: LColors.blue,
                    onChanged: (value) {
                      setState(() {
                        _streakReminders = value;
                      });
                      _saveSettings();
                    },
                  ),
                  if (_dailyReminders)
                    ListTile(
                      leading: Icon(Icons.schedule, color: LColors.blue),
                      title: const Text('Reminder Time'),
                      subtitle: Text('Daily reminder at $_reminderTime'),
                      trailing: Icon(Icons.edit, color: LColors.grey),
                      onTap: _selectReminderTime,
                    ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // App Preferences Section
            _buildSectionCard(
              title: 'App Preferences',
              icon: Icons.tune,
              children: [
                ListTile(
                  leading: Icon(Icons.color_lens, color: LColors.blue),
                  title: const Text('Theme'),
                  subtitle: const Text('Light theme'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: LColors.grey,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Theme customization coming soon!'),
                        backgroundColor: LColors.highlight,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language, color: LColors.blue),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: LColors.grey,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Multiple languages coming soon!'),
                        backgroundColor: LColors.highlight,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Data & Privacy Section
            _buildSectionCard(
              title: 'Data & Privacy',
              icon: Icons.security,
              children: [
                ListTile(
                  leading: Icon(Icons.cloud_download, color: LColors.blue),
                  title: const Text('Export Data'),
                  subtitle: const Text('Download your learning progress'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: LColors.grey,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Data export feature coming soon!'),
                        backgroundColor: LColors.highlight,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: LColors.error),
                  title: Text(
                    'Reset Progress',
                    style: TextStyle(color: LColors.error),
                  ),
                  subtitle: const Text('Clear all learning data'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: LColors.grey,
                  ),
                  onTap: _showResetConfirmation,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: LColors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LColors.black,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning, color: LColors.error),
                const SizedBox(width: 8),
                const Text('Reset Progress'),
              ],
            ),
            content: const Text(
              'Are you sure you want to reset all your learning progress? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: LColors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Here you would call StreakService.resetAllData()
                  // For now, just show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Progress reset feature will be implemented',
                      ),
                      backgroundColor: LColors.highlight,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: Text('Reset', style: TextStyle(color: LColors.error)),
              ),
            ],
          ),
    );
  }
}

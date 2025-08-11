import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/services/recent_activities_service.dart';

class RecentActivitiesPage extends StatefulWidget {
  const RecentActivitiesPage({super.key});

  @override
  State<RecentActivitiesPage> createState() => _RecentActivitiesPageState();
}

class _RecentActivitiesPageState extends State<RecentActivitiesPage> {
  List<ActivityItem> _activities = [];
  ActivityType? _selectedFilter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);

    List<ActivityItem> activities;
    if (_selectedFilter != null) {
      activities = await RecentActivitiesService.getActivitiesByType(
        _selectedFilter!,
      );
    } else {
      activities = await RecentActivitiesService.getRecentActivities();
    }

    setState(() {
      _activities = activities;
      _isLoading = false;
    });
  }

  void _filterActivities(ActivityType? filter) {
    setState(() => _selectedFilter = filter);
    _loadActivities();
  }

  String _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.videoWatched:
        return '📹';
      case ActivityType.testCompleted:
        return '📝';
      case ActivityType.grammarLearned:
        return '📚';
      case ActivityType.gamePlayed:
        return '🎮';
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.videoWatched:
        return LColors.error;
      case ActivityType.testCompleted:
        return LColors.success;
      case ActivityType.grammarLearned:
        return LColors.blue;
      case ActivityType.gamePlayed:
        return LColors.exercises;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: const Column(
          children: [
            Text(
              'RECENT ACTIVITIES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Track Your Learning Journey',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Clear All Activities'),
                      content: const Text(
                        'Are you sure you want to clear all recent activities?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                await RecentActivitiesService.clearAllActivities();
                _loadActivities();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == null,
                    onTap: () => _filterActivities(null),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _FilterChip(
                    label: 'Videos',
                    isSelected: _selectedFilter == ActivityType.videoWatched,
                    onTap: () => _filterActivities(ActivityType.videoWatched),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _FilterChip(
                    label: 'Tests',
                    isSelected: _selectedFilter == ActivityType.testCompleted,
                    onTap: () => _filterActivities(ActivityType.testCompleted),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _FilterChip(
                    label: 'Grammar',
                    isSelected: _selectedFilter == ActivityType.grammarLearned,
                    onTap: () => _filterActivities(ActivityType.grammarLearned),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _FilterChip(
                    label: 'Games',
                    isSelected: _selectedFilter == ActivityType.gamePlayed,
                    onTap: () => _filterActivities(ActivityType.gamePlayed),
                  ),
                ),
              ],
            ),
          ),

          // Activities List
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _activities.isEmpty
                    ? _EmptyState(filter: _selectedFilter)
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final activity = _activities[index];
                        return _ActivityTile(
                          activity: activity,
                          icon: _getActivityIcon(activity.type),
                          color: _getActivityColor(activity.type),
                          timeAgo: _getTimeAgo(activity.timestamp),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? LColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? LColors.blue : LColors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : LColors.greyDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem activity;
  final String icon;
  final Color color;
  final String timeAgo;

  const _ActivityTile({
    required this.activity,
    required this.icon,
    required this.color,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: const TextStyle(color: LColors.greyDark, fontSize: 13),
                ),
                if (activity.additionalData != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Score: ${activity.additionalData}',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgo,
                style: const TextStyle(color: LColors.grey, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                '${activity.timestamp.month}/${activity.timestamp.day}',
                style: const TextStyle(color: LColors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ActivityType? filter;

  const _EmptyState({this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    String icon;

    switch (filter) {
      case ActivityType.videoWatched:
        message =
            'No videos watched yet.\nWatch explanation videos to see them here!';
        icon = '📹';
        break;
      case ActivityType.testCompleted:
        message =
            'No tests completed yet.\nTake some grammar tests to track your progress!';
        icon = '📝';
        break;
      case ActivityType.grammarLearned:
        message =
            'No grammar topics studied yet.\nExplore grammar lessons to see your learning journey!';
        icon = '📚';
        break;
      case ActivityType.gamePlayed:
        message =
            'No games played yet.\nPlay interactive games to see them here!';
        icon = '🎮';
        break;
      default:
        message =
            'No activities yet.\nStart learning to see your recent activities here!';
        icon = '🚀';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: LColors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

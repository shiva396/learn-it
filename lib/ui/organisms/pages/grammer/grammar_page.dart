import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({Key? key}) : super(key: key);

  @override
  GrammarPageState createState() => GrammarPageState();
}

class GrammarPageState extends State<GrammarPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _topics = [
    {'title': 'Adjective', 'passed': 1, 'total': 36, 'progress': 20},
    {'title': 'Adverb', 'passed': 0, 'total': 6, 'progress': 0},
    {'title': 'Articles', 'passed': 0, 'total': 42, 'progress': 0},
    {'title': 'Conditional sentences', 'passed': 0, 'total': 18, 'progress': 0},
    {'title': 'Gerund and Infinitive', 'passed': 0, 'total': 34, 'progress': 0},
    {
      'title': 'Modals and Modal Auxiliaries',
      'passed': 0,
      'total': 22,
      'progress': 0,
    },
    {'title': 'Nouns', 'passed': 0, 'total': 12, 'progress': 0},
  ];

  List<Map<String, dynamic>> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _filteredTopics = _topics;
  }

  void _filterTopics(String query) {
    setState(() {
      _filteredTopics =
          _topics
              .where(
                (topic) =>
                    topic['title'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _navigateToTopic(String topic) {
    String topicLower = topic.toLowerCase().replaceAll(' ', '_');
    Navigator.pushNamed(
      context,
      '/grammar/$topicLower',
      arguments: (double progress) {
        setState(() {
          final index = _topics.indexWhere((t) => t['title'] == topic);
          if (index != -1) {
            _topics[index]['progress'] = progress;
          }
        });
      },
    );
  }

  void updateProgress(String topic, double progress) {
    setState(() {
      final index = _topics.indexWhere((t) => t['title'] == topic);
      if (index != -1) {
        // Ensure progress only moves forward
        _topics[index]['progress'] =
            progress > _topics[index]['progress']
                ? progress
                : _topics[index]['progress'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'GRAMMAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Learn Grammar Easily',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: _filterTopics,
                decoration: InputDecoration(
                  hintText: 'SEARCH',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: LColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'RECENT TOPICS',
                style: TextStyle(
                  color: LColors.greyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ..._filteredTopics.map(
                (topic) => GestureDetector(
                  onTap: () => _navigateToTopic(topic['title']),
                  child: _GrammarTile(
                    progress: topic['progress'],
                    title: topic['title'],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrammarTile extends StatelessWidget {
  final int progress;
  final String title;

  const _GrammarTile({required this.progress, required this.title, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            backgroundColor: LColors.greyLight,
            valueColor: AlwaysStoppedAnimation<Color>(LColors.blue),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: LColors.greyDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: LColors.grey, size: 16),
        ],
      ),
    );
  }
}

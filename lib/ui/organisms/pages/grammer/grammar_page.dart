import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({Key? key}) : super(key: key);

  @override
  _GrammarPageState createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _topics = [
    {'title': 'Nouns', 'minutes': 5, 'progress': 0},
    {'title': 'Pronouns', 'minutes': 4, 'progress': 0},
    {'title': 'Verbs', 'minutes': 6, 'progress': 0},
    {'title': 'Adjectives', 'minutes': 3, 'progress': 0},
    {'title': 'Adverbs', 'minutes': 2, 'progress': 0},
    {'title': 'Prepositions', 'minutes': 4, 'progress': 0},
    {'title': 'Conjunctions', 'minutes': 3, 'progress': 0},
    {'title': 'Interjections', 'minutes': 2, 'progress': 0},
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
              .map(
                (topic) => {
                  'title': topic['title'],
                  'minutes':
                      topic['minutes'] ?? 0, // Ensure minutes is non-null
                  'progress':
                      topic['progress'] ?? 0, // Ensure progress is non-null
                },
              )
              .toList();
    });
  }

  void _navigateToTopic(String topic) {
    String topicLower = topic.toLowerCase().replaceAll(' ', '_');
    Navigator.pushNamed(context, '/grammar/$topicLower');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TopicCard(
                    title: 'The adverbs – Summary',
                    daysAgo: '29 days ago',
                    color: Colors.orange,
                  ),
                  _TopicCard(
                    title: 'Comparison of adjectives',
                    daysAgo: '1 months ago',
                    color: Colors.green,
                  ),
                  _TopicCard(
                    title: 'Demonstrative Adjectives',
                    daysAgo: '1 months ago',
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 16),
              ..._filteredTopics.map(
                (topic) => GestureDetector(
                  onTap: () => _navigateToTopic(topic['title']),
                  child: _GrammarTile(
                    progress: topic['progress'] ?? 0,
                    title: topic['title'],
                    minutes: topic['minutes'] ?? 0,
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

class _TopicCard extends StatelessWidget {
  final String title;
  final String daysAgo;
  final Color color;

  const _TopicCard({
    required this.title,
    required this.daysAgo,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 24,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Text(
            daysAgo,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrammarTile extends StatelessWidget {
  final int progress;
  final String title;
  final int minutes;

  const _GrammarTile({
    required this.progress,
    required this.title,
    required this.minutes,
    Key? key,
  }) : super(key: key);

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
                Text(
                  '$minutes minutes to read',
                  style: TextStyle(color: LColors.grey, fontSize: 12),
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

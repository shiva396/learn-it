import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'adjective/adjective_deck.dart';

class SlideDecksPage extends StatefulWidget {
  const SlideDecksPage({Key? key}) : super(key: key);

  @override
  _SlideDecksPageState createState() => _SlideDecksPageState();
}

class _SlideDecksPageState extends State<SlideDecksPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _topics = [
    {'title': 'Adjectives', 'minutes': 3, 'progress': 0, 'isAvailable': true},
    {'title': 'Nouns', 'minutes': 5, 'progress': 0, 'isAvailable': false},
    {'title': 'Pronouns', 'minutes': 4, 'progress': 0, 'isAvailable': false},
    {'title': 'Verbs', 'minutes': 6, 'progress': 0, 'isAvailable': false},
    {'title': 'Adverbs', 'minutes': 2, 'progress': 0, 'isAvailable': false},
    {
      'title': 'Prepositions',
      'minutes': 4,
      'progress': 0,
      'isAvailable': false,
    },
    {
      'title': 'Conjunctions',
      'minutes': 3,
      'progress': 0,
      'isAvailable': false,
    },
    {
      'title': 'Interjections',
      'minutes': 2,
      'progress': 0,
      'isAvailable': false,
    },
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
                  'minutes': topic['minutes'] ?? 0,
                  'progress': topic['progress'] ?? 0,
                  'isAvailable': topic['isAvailable'] ?? false,
                },
              )
              .toList();
    });
  }

  void _navigateToTopic(String topic, bool isAvailable) {
    if (!isAvailable) {
      _showComingSoonDialog(topic);
      return;
    }

    String topicLower = topic.toLowerCase();
    switch (topicLower) {
      case 'adjectives':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SlideModulePage(
                  moduleType: 'adjectives',
                  onComplete: () {
                    setState(() {
                      // Update progress when completed
                      int index = _topics.indexWhere(
                        (t) => t['title'] == topic,
                      );
                      if (index != -1) {
                        _topics[index]['progress'] = 100;
                      }
                    });
                  },
                ),
          ),
        );
        break;
      default:
        _showComingSoonDialog(topic);
    }
  }

  void _showComingSoonDialog(String topic) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.slideshow, color: LColors.blue, size: 30),
                const SizedBox(width: 12),
                Text(
                  topic,
                  style: TextStyle(
                    color: LColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction,
                  size: 50,
                  color: Colors.orange.shade300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Coming Soon!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'This ${topic.toLowerCase()} slide deck is currently under development. Stay tuned for more amazing learning experiences!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
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
              'SLIDE DECKS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Interactive Learning Slides',
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
                'SLIDES',
                style: TextStyle(
                  color: LColors.greyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 8),
              ..._filteredTopics.map(
                (topic) => GestureDetector(
                  onTap:
                      () => _navigateToTopic(
                        topic['title'],
                        topic['isAvailable'],
                      ),
                  child: _SlideDeckTile(
                    progress: topic['progress'] ?? 0,
                    title: topic['title'],
                    minutes: topic['minutes'] ?? 0,
                    isAvailable: topic['isAvailable'] ?? false,
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

class _SlideDeckTile extends StatelessWidget {
  final int progress;
  final String title;
  final int minutes;
  final bool isAvailable;

  const _SlideDeckTile({
    required this.progress,
    required this.title,
    required this.minutes,
    required this.isAvailable,
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
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                backgroundColor: LColors.greyLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isAvailable ? LColors.blue : LColors.grey,
                ),
              ),
              if (!isAvailable) Icon(Icons.lock, color: LColors.grey, size: 16),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isAvailable ? LColors.greyDark : LColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ),
                      // if (!isAvailable)
                      //   Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 6,
                      //       vertical: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.orange.shade100,
                      //       borderRadius: BorderRadius.circular(4),
                      //     ),
                      //     child: Text(
                      //       'Coming Soon',
                      //       style: TextStyle(
                      //         color: Colors.orange.shade700,
                      //         fontSize: 10,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                    ),
                  ],
                ),
                Text(
                  '${minutes} minutes to complete',
                  style: TextStyle(
                    color: isAvailable ? LColors.grey : LColors.greyLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isAvailable ? Icons.arrow_forward_ios : Icons.schedule,
            color: isAvailable ? LColors.grey : LColors.greyLight,
            size: 16,
          ),
        ],
      ),
    );
  }
}

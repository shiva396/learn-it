import 'package:flutter/material.dart';
import 'package:learnit/data/test_packs_data/test_packs_data.dart';
import 'package:learnit/data/test_packs_data/test_pack_models.dart';
import 'package:learnit/ui/atoms/colors.dart';

class TestPacksPage extends StatefulWidget {
  const TestPacksPage({super.key});

  @override
  State<TestPacksPage> createState() => _TestPacksPageState();
}

class _TestPacksPageState extends State<TestPacksPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<TopicInfo> _topics = TestPacksData.getTopicsList();
  List<TopicInfo> _filteredTopics = [];

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
                    topic.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _showDifficultyDialog(TopicInfo topic) {
    final difficultyInfo = TestPacksData.getDifficultyInfo();
    Color topicColor = _getTopicColor(topic.color);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(topic.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: topicColor,
                            ),
                          ),
                          Text(
                            topic.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: LColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose Difficulty Level',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: LColors.black,
                  ),
                ),
                const SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                  children:
                      DifficultyLevel.values.map((difficulty) {
                        final info = difficultyInfo[difficulty]!;
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test_packs/test',
                              arguments: {
                                'topic': topic.topic,
                                'difficulty': difficulty,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  topicColor.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: topicColor.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: topicColor.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(info['icon'], color: topicColor, size: 24),
                                const SizedBox(height: 4),
                                Text(
                                  info['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: topicColor,
                                  ),
                                ),
                                Text(
                                  '${info['timeInMinutes']} min',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: LColors.greyDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTopicColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return LColors.blue;
      case 'green':
        return LColors.success;
      case 'purple':
        return LColors.achievement;
      case 'orange':
        return LColors.warning;
      case 'red':
        return LColors.error;
      case 'teal':
        return LColors.highlight;
      case 'indigo':
        return LColors.levelUp;
      case 'pink':
        return Colors.pinkAccent;
      default:
        return LColors.blue;
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
              'TEST PACKS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Test Your Grammar Knowledge',
              style: TextStyle(color: Colors.white70, fontSize: 14),
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
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: LColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'GRAMMAR TOPICS',
                style: TextStyle(
                  color: LColors.greyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ..._filteredTopics.map(
                (topic) => GestureDetector(
                  onTap: () => _showDifficultyDialog(topic),
                  child: _TestPackTile(
                    topic: topic,
                    color: _getTopicColor(topic.color),
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

class _TestPackTile extends StatelessWidget {
  final TopicInfo topic;
  final Color color;

  const _TestPackTile({required this.topic, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
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
              child: Text(topic.emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: const TextStyle(
                    color: LColors.greyDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  topic.description,
                  style: const TextStyle(color: LColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: LColors.grey, size: 16),
        ],
      ),
    );
  }
}

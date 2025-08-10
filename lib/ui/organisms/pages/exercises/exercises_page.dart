import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({Key? key}) : super(key: key);

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _questionTypes = [
    {
      'title': 'Jumbled Words',
      'description': 'Rearrange the letters to form a correct word.',
      'icon': Icons.shuffle,
      'minutes': 5,
      'progress': 0,
    },
    {
      'title': 'Odd One Out',
      'description': 'Pick the word that does not belong in the group.',
      'icon': Icons.remove_circle_outline,
      'minutes': 4,
      'progress': 0,
    },
    {
      'title': 'Analogies',
      'description': 'Complete the logical comparison between two items.',
      'icon': Icons.compare_arrows,
      'minutes': 6,
      'progress': 0,
    },
    {
      'title': 'Arithmetic Word Problems',
      'description': 'Solve real-life math questions using basic operations.',
      'icon': Icons.calculate,
      'minutes': 8,
      'progress': 0,
    },
    {
      'title': 'Number Series',
      'description': 'Identify and continue numeric patterns.',
      'icon': Icons.format_list_numbered,
      'minutes': 5,
      'progress': 0,
    },
    {
      'title': 'Vocabulary & Definitions',
      'description': 'Choose the correct term based on a given definition.',
      'icon': Icons.book,
      'minutes': 7,
      'progress': 0,
    },
    {
      'title': 'Image-Based Questions',
      'description': 'Answer based on images or visual cues.',
      'icon': Icons.image,
      'minutes': 6,
      'progress': 0,
    },
  ];

  List<Map<String, dynamic>> _filteredQuestionTypes = [];

  @override
  void initState() {
    super.initState();
    _filteredQuestionTypes = _questionTypes;
  }

  void _filterQuestionTypes(String query) {
    setState(() {
      _filteredQuestionTypes =
          _questionTypes
              .where(
                (questionType) => questionType['title'].toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .map(
                (questionType) => {
                  'title': questionType['title'],
                  'description': questionType['description'],
                  'icon': questionType['icon'],
                  'minutes': questionType['minutes'] ?? 0,
                  'progress': questionType['progress'] ?? 0,
                },
              )
              .toList();
    });
  }

  void _navigateToExercise(String title) {
    switch (title) {
      case 'Jumbled Words':
        Navigator.pushNamed(context, '/exercises/jumbled_words');
        break;
      case 'Odd One Out':
        Navigator.pushNamed(context, '/exercises/odd_one_out');
        break;
      case 'Analogies':
        Navigator.pushNamed(context, '/exercises/analogies');
        break;
      case 'Arithmetic Word Problems':
        Navigator.pushNamed(context, '/exercises/arithmetic_word_problems');
        break;
      case 'Number Series':
        Navigator.pushNamed(context, '/exercises/number_series');
        break;
      case 'Vocabulary & Definitions':
        Navigator.pushNamed(context, '/exercises/vocabulary_definitions');
        break;
      case 'Image-Based Questions':
        Navigator.pushNamed(context, '/exercises/image_based_questions');
        break;
      default:
        break;
    }
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
              'EXERCISES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Practice & Improve',
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
                onChanged: _filterQuestionTypes,
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
                'EXERCISE TYPES',
                style: TextStyle(
                  color: LColors.greyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ..._filteredQuestionTypes.map(
                (questionType) => GestureDetector(
                  onTap: () => _navigateToExercise(questionType['title']),
                  child: _ExerciseTile(
                    progress: questionType['progress'] ?? 0,
                    title: questionType['title'],
                    description: questionType['description'],
                    minutes: questionType['minutes'] ?? 0,
                    icon: questionType['icon'],
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

class _ExerciseTile extends StatelessWidget {
  final int progress;
  final String title;
  final String description;
  final int minutes;
  final IconData icon;

  const _ExerciseTile({
    required this.progress,
    required this.title,
    required this.description,
    required this.minutes,
    required this.icon,
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: LColors.blue, size: 24),
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
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: LColors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '$minutes minutes to complete',
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

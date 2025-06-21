import 'package:flutter/material.dart';

class ExcercisesPage extends StatelessWidget {
  const ExcercisesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionTypes = [
      {
        'title': 'Jumbled Words',
        'description': 'Rearrange the letters to form a correct word.',
        'icon': Icons.shuffle,
      },
      {
        'title': 'Odd One Out',
        'description': 'Pick the word that does not belong in the group.',
        'icon': Icons.remove_circle_outline,
      },
      {
        'title': 'Analogies',
        'description': 'Complete the logical comparison between two items.',
        'icon': Icons.compare_arrows,
      },
      {
        'title': 'Arithmetic Word Problems',
        'description': 'Solve real-life math questions using basic operations.',
        'icon': Icons.calculate,
      },
      {
        'title': 'Number Series',
        'description': 'Identify and continue numeric patterns.',
        'icon': Icons.format_list_numbered,
      },
      {
        'title': 'Vocabulary & Definitions',
        'description': 'Choose the correct term based on a given definition.',
        'icon': Icons.book,
      },
      {
        'title': 'Image-Based Questions',
        'description': 'Answer based on images or visual cues.',
        'icon': Icons.image,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Types'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: questionTypes.length,
        itemBuilder: (context, index) {
          final questionType = questionTypes[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                questionType['icon'] as IconData,
                color: Colors.blue,
                size: 32,
              ),
              title: Text(
                questionType['title'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                questionType['description'] as String,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                switch (questionType['title']) {
                  case 'Jumbled Words':
                    Navigator.pushNamed(context, '/excercises/jumbled_words');
                    break;
                  case 'Odd One Out':
                    Navigator.pushNamed(context, '/excercises/odd_one_out');
                    break;
                  case 'Analogies':
                    Navigator.pushNamed(context, '/excercises/analogies');
                    break;
                  case 'Arithmetic Word Problems':
                    Navigator.pushNamed(
                      context,
                      '/excercises/arithmetic_word_problems',
                    );
                    break;
                  case 'Number Series':
                    Navigator.pushNamed(context, '/excercises/number_series');
                    break;
                  case 'Vocabulary & Definitions':
                    Navigator.pushNamed(
                      context,
                      '/excercises/vocabulary_definitions',
                    );
                    break;
                  case 'Image-Based Questions':
                    Navigator.pushNamed(
                      context,
                      '/excercises/image_based_questions',
                    );
                    break;
                  default:
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }
}

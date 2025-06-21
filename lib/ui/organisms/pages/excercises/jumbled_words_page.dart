import 'package:flutter/material.dart';
import 'package:learnit/data/excercises/jumbled_words_data.dart';

class JumbledWordsPage extends StatefulWidget {
  const JumbledWordsPage({Key? key}) : super(key: key);

  @override
  State<JumbledWordsPage> createState() => _JumbledWordsPageState();
}

class _JumbledWordsPageState extends State<JumbledWordsPage> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    final question = jumbledWordsData[currentQuestionIndex];
    final totalQuestions = jumbledWordsData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumbled Words'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isCorrect == null
                      ? Colors.white
                      : isCorrect == true
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedAnswer ?? '_________',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 3,
                        ),
                        itemCount: question['options']?.length ?? 0,
                        itemBuilder: (context, index) {
                          final option = question['options']![index];
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor: selectedAnswer == option
                                  ? (isCorrect == true
                                      ? Colors.green
                                      : Colors.red)
                                  : Colors.blue,
                            ),
                            onPressed: selectedAnswer == null
                                ? () {
                                    setState(() {
                                      selectedAnswer = option;
                                      isCorrect = option == question['answer'];
                                    });
                                  }
                                : null,
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      if (selectedAnswer != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            isCorrect == true
                                ? '✅ Well done!'
                                : '❌ Correct Answer: ${question['answer']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalQuestions,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    size: 12.0,
                    color: index == currentQuestionIndex
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of $totalQuestions',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  onPressed: currentQuestionIndex < totalQuestions - 1
                      ? () {
                          setState(() {
                            currentQuestionIndex++;
                            selectedAnswer = null;
                            isCorrect = null;
                          });
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

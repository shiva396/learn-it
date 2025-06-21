import 'package:flutter/material.dart';
import 'package:learnit/data/excercises/jumbled_words_data.dart';

class JumbledWordsPage extends StatefulWidget {
  const JumbledWordsPage({Key? key}) : super(key: key);

  @override
  State<JumbledWordsPage> createState() => _JumbledWordsPageState();
}

class _JumbledWordsPageState extends State<JumbledWordsPage> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  List<bool?> questionResults = List.filled(jumbledQuestions.length, null);

  @override
  Widget build(BuildContext context) {
    final question = jumbledQuestions[currentQuestionIndex];
    final totalQuestions = jumbledQuestions.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'JUMBLED WORDS',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rearrange the letters to form a correct word',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selectedOptionIndex == null
                          ? Colors.white
                          : selectedOptionIndex == question.correctIndex
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedOptionIndex == null
                            ? question.questionLabel
                            : question.options[selectedOptionIndex!],
                        textAlign: TextAlign.center,
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
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio: 3,
                            ),
                        itemCount: question.options.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor:
                                  selectedOptionIndex == index
                                      ? (index == question.correctIndex
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                            ),
                            onPressed:
                                selectedOptionIndex == null
                                    ? () {
                                      setState(() {
                                        selectedOptionIndex = index;
                                        questionResults[currentQuestionIndex] =
                                            index == question.correctIndex;
                                      });
                                    }
                                    : null,
                            child: Text(
                              question.options[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      if (selectedOptionIndex != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            selectedOptionIndex == question.correctIndex
                                ? '✅ Well done!'
                                : '❌ Correct Answer: ${question.options[question.correctIndex]}',
                            textAlign: TextAlign.center,
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
              children: List.generate(totalQuestions, (index) {
                Color? dotColor;
                if (questionResults[index] == true) {
                  dotColor = Colors.green;
                } else if (questionResults[index] == false) {
                  dotColor = Colors.red;
                } else {
                  dotColor = Colors.grey.withOpacity(
                    0.3,
                  ); // No color for unanswered
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.circle, size: 12.0, color: dotColor),
                );
              }),
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
                  onPressed:
                      currentQuestionIndex < totalQuestions - 1
                          ? () {
                            setState(() {
                              currentQuestionIndex++;
                              selectedOptionIndex = null;
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

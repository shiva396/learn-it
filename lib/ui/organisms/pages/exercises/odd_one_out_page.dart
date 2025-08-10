import 'package:flutter/material.dart';
import 'package:learnit/data/excercises/odd_one_out_data.dart';

class OddOneOutPage extends StatefulWidget {
  const OddOneOutPage({Key? key}) : super(key: key);

  @override
  State<OddOneOutPage> createState() => _OddOneOutPageState();
}

class _OddOneOutPageState extends State<OddOneOutPage> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool isAnswered = false;

  @override
  Widget build(BuildContext context) {
    final question = oddOneOutData[currentQuestionIndex];
    final totalQuestions = oddOneOutData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Odd One Out',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question['questionText'],
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: question['options'].length,
                itemBuilder: (context, index) {
                  final isCorrect = index == question['correctIndex'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color:
                              selectedOptionIndex == index
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      child: InkWell(
                        onTap:
                            isAnswered
                                ? null
                                : () {
                                  setState(() {
                                    selectedOptionIndex = index;
                                    isAnswered = true;
                                  });
                                },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    selectedOptionIndex == index
                                        ? (isCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.grey.shade300,
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  question['options'][index],
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isAnswered)
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      selectedOptionIndex == question['correctIndex']
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color:
                        selectedOptionIndex == question['correctIndex']
                            ? Colors.green
                            : Colors.red,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color:
                            selectedOptionIndex == question['correctIndex']
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      selectedOptionIndex == question['correctIndex']
                          ? question['explanation']
                          : question['wrongExplanation'],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                  onPressed:
                      currentQuestionIndex < totalQuestions - 1
                          ? () {
                            setState(() {
                              currentQuestionIndex++;
                              selectedOptionIndex = null;
                              isAnswered = false;
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

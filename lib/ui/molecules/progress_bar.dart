import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestionIndex;
  final List<bool?>
  questionResults; // null for unanswered, true for correct, false for incorrect

  const ProgressBar({
    Key? key,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.questionResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalQuestions, (index) {
        Color? dotColor;
        if (index < currentQuestionIndex) {
          dotColor = questionResults[index] == true ? Colors.green : Colors.red;
        } else {
          dotColor = null; // No color for unanswered
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.circle,
            size: 12.0,
            color:
                dotColor ??
                Colors.grey.withOpacity(
                  0.3,
                ), // Default to light grey for unanswered
          ),
        );
      }),
    );
  }
}

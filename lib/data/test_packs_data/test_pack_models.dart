enum GrammarTopic {
  adjective,
  noun,
  pronoun,
  verb,
  adverb,
  preposition,
  conjunction,
  interjection,
}

enum DifficultyLevel { easy, medium, hard }

class TestQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  TestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

class TestPack {
  final GrammarTopic topic;
  final DifficultyLevel difficulty;
  final String title;
  final String description;
  final List<TestQuestion> questions;
  final int timeInMinutes;

  TestPack({
    required this.topic,
    required this.difficulty,
    required this.title,
    required this.description,
    required this.questions,
    required this.timeInMinutes,
  });
}

class TopicInfo {
  final GrammarTopic topic;
  final String name;
  final String description;
  final String emoji;
  final String color;

  TopicInfo({
    required this.topic,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

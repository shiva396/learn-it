import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Enum for test types
enum TestType {
  jumbledWords,
  oddOneOut,
  analogies,
  arithmetic,
  numberSeries,
  generalKnowledge,
  visualRecognition,
}

// Model for individual question
class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imagePath; // For visual questions
  final TestType testType;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.imagePath,
    required this.testType,
  });
}

// Model for test section
class TestSection {
  final TestType type;
  final String title;
  final String description;
  final int timeInMinutes;
  final List<AssessmentQuestion> questions;
  final Color themeColor;
  final IconData icon;

  TestSection({
    required this.type,
    required this.title,
    required this.description,
    required this.timeInMinutes,
    required this.questions,
    required this.themeColor,
    required this.icon,
  });
}

// Model for assessment result
class AssessmentResult {
  final String studentId;
  final DateTime completedAt;
  final Map<TestType, int> sectionScores; // Score out of total questions
  final Map<TestType, int> timeSpent; // Time spent in seconds
  final int totalScore;
  final int totalPossibleScore;
  final double overallPercentage;
  final Map<String, double> cognitiveAnalysis;

  AssessmentResult({
    required this.studentId,
    required this.completedAt,
    required this.sectionScores,
    required this.timeSpent,
    required this.totalScore,
    required this.totalPossibleScore,
    required this.overallPercentage,
    required this.cognitiveAnalysis,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'completedAt': completedAt.toIso8601String(),
      'sectionScores': sectionScores.map((key, value) => MapEntry(key.name, value)),
      'timeSpent': timeSpent.map((key, value) => MapEntry(key.name, value)),
      'totalScore': totalScore,
      'totalPossibleScore': totalPossibleScore,
      'overallPercentage': overallPercentage,
      'cognitiveAnalysis': cognitiveAnalysis,
    };
  }

  // Create from JSON
  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      studentId: json['studentId'],
      completedAt: DateTime.parse(json['completedAt']),
      sectionScores: (json['sectionScores'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(TestType.values.firstWhere((e) => e.name == key), value as int),
      ),
      timeSpent: (json['timeSpent'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(TestType.values.firstWhere((e) => e.name == key), value as int),
      ),
      totalScore: json['totalScore'],
      totalPossibleScore: json['totalPossibleScore'],
      overallPercentage: json['overallPercentage'].toDouble(),
      cognitiveAnalysis: Map<String, double>.from(json['cognitiveAnalysis']),
    );
  }
}

// Cognitive ability model
class CognitiveAbility {
  final String name;
  final String description;
  final double percentage;
  final String feedback;
  final Color color;
  final IconData icon;

  CognitiveAbility({
    required this.name,
    required this.description,
    required this.percentage,
    required this.feedback,
    required this.color,
    required this.icon,
  });
}

// Assessment data provider
class AssessmentData {
  // Test section configurations
  static List<TestSection> getTestSections() {
    return [
      TestSection(
        type: TestType.jumbledWords,
        title: "Word Puzzle",
        description: "Unscramble the jumbled words!",
        timeInMinutes: 8,
        themeColor: const Color(0xFF6366F1),
        icon: Icons.text_rotation_none,
        questions: _getJumbledWordsQuestions(),
      ),
      TestSection(
        type: TestType.oddOneOut,
        title: "Odd One Out",
        description: "Find the word that doesn't belong!",
        timeInMinutes: 6,
        themeColor: const Color(0xFF8B5CF6),
        icon: Icons.psychology,
        questions: _getOddOneOutQuestions(),
      ),
      TestSection(
        type: TestType.analogies,
        title: "Think & Connect",
        description: "Complete the word relationships!",
        timeInMinutes: 5,
        themeColor: const Color(0xFF06B6D4),
        icon: Icons.link,
        questions: _getAnalogiesQuestions(),
      ),
      TestSection(
        type: TestType.arithmetic,
        title: "Math Challenge",
        description: "Solve these fun math problems!",
        timeInMinutes: 12,
        themeColor: const Color(0xFF10B981),
        icon: Icons.calculate,
        questions: _getArithmeticQuestions(),
      ),
      TestSection(
        type: TestType.numberSeries,
        title: "Number Patterns",
        description: "Find the missing numbers!",
        timeInMinutes: 8,
        themeColor: const Color(0xFFF59E0B),
        icon: Icons.trending_up,
        questions: _getNumberSeriesQuestions(),
      ),
      TestSection(
        type: TestType.generalKnowledge,
        title: "Smart Facts",
        description: "Test your knowledge!",
        timeInMinutes: 6,
        themeColor: const Color(0xFF9333EA),
        icon: Icons.school,
        questions: _getGeneralKnowledgeQuestions(),
      ),
      TestSection(
        type: TestType.visualRecognition,
        title: "Picture Perfect",
        description: "Look carefully and choose!",
        timeInMinutes: 4,
        themeColor: const Color(0xFFFF6B35),
        icon: Icons.visibility,
        questions: _getVisualRecognitionQuestions(),
      ),
    ];
  }

  // Jumbled Words Questions
  static List<AssessmentQuestion> _getJumbledWordsQuestions() {
    return [
      AssessmentQuestion(
        id: "jw1",
        question: "Unscramble this word: BLATO",
        options: ["BLATO", "BATLO", "BOLAT", "BLOAT"],
        correctAnswerIndex: 3,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw2",
        question: "Unscramble this word: YKE",
        options: ["KYE", "KEY", "EKY", "YKE"],
        correctAnswerIndex: 1,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw3",
        question: "Unscramble this word: DISE",
        options: ["SIDE", "DISE", "ISDE", "ESDI"],
        correctAnswerIndex: 0,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw4",
        question: "Unscramble this word: AHCPE",
        options: ["PEACH", "AHCPE", "CAPHE", "HCAEP"],
        correctAnswerIndex: 0,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw5",
        question: "Unscramble this word: RUCOLO",
        options: ["COLOUR", "RUCOLO", "OCULOR", "LORUCO"],
        correctAnswerIndex: 0,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw6",
        question: "Unscramble this word: DRIPAMY",
        options: ["PYRAMID", "DRIPAMY", "MAYIDRP", "MIRYPAD"],
        correctAnswerIndex: 0,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw7",
        question: "Unscramble this word: WORDN",
        options: ["ROWND", "WORDN", "DROWN", "WDRON"],
        correctAnswerIndex: 2,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw8",
        question: "Unscramble this word: BYOHB",
        options: ["HOBBY", "BYOHB", "BYOHB", "BOYHB"],
        correctAnswerIndex: 0,
        testType: TestType.jumbledWords,
      ),
      AssessmentQuestion(
        id: "jw9",
        question: "Unscramble this word: CBLAK",
        options: ["CBALK", "BKCAL", "CBLAK", "BLACK"],
        correctAnswerIndex: 3,
        testType: TestType.jumbledWords,
      ),
    ];
  }

  // Odd One Out Questions
  static List<AssessmentQuestion> _getOddOneOutQuestions() {
    return [
      AssessmentQuestion(
        id: "ooo1",
        question: "Which word is out of place in this group?",
        options: ["Apple", "Banana", "Mango", "Carrot"],
        correctAnswerIndex: 3,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo2",
        question: "Choose the word that doesn't fit:",
        options: ["River", "Lake", "Rain", "Ocean"],
        correctAnswerIndex: 2,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo3",
        question: "Identify the word that doesn't belong in this group:",
        options: ["Algebra", "Geometry", "Measurement", "Acids and Bases"],
        correctAnswerIndex: 3,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo4",
        question: "Which word is the odd one out?",
        options: ["Lion", "Elephant", "Giraffe", "Dolphin"],
        correctAnswerIndex: 3,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo5",
        question: "Which word is the odd one out?",
        options: ["Red", "Blue", "Green", "Yellow"],
        correctAnswerIndex:
            -1, // All are colors, this seems to be a trick question
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo6",
        question: "Which word is the odd one out?",
        options: ["Mercury", "Venus", "Moon", "Mars"],
        correctAnswerIndex: 2,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo7",
        question: "Which word is out of place in this group?",
        options: ["Piano", "Violin", "Trumpet", "Bicycle"],
        correctAnswerIndex: 3,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo8",
        question: "Which word is out of place in this group?",
        options: ["Spring", "Rainfall", "Summer", "Winter"],
        correctAnswerIndex: 1,
        testType: TestType.oddOneOut,
      ),
      AssessmentQuestion(
        id: "ooo9",
        question: "Which word is the odd one out?",
        options: ["January", "February", "March", "Monday"],
        correctAnswerIndex: 3,
        testType: TestType.oddOneOut,
      ),
    ];
  }

  // Analogies Questions
  static List<AssessmentQuestion> _getAnalogiesQuestions() {
    return [
      AssessmentQuestion(
        id: "ana1",
        question: "Pen is to write as knife is to ___",
        options: ["Cut", "Write", "Squeeze", "Carve"],
        correctAnswerIndex: 0,
        testType: TestType.analogies,
      ),
      AssessmentQuestion(
        id: "ana2",
        question: "Book is to pages as necklace is to ___",
        options: ["Beads", "Chain", "Pendant", "Gemstone"],
        correctAnswerIndex: 0,
        testType: TestType.analogies,
      ),
      AssessmentQuestion(
        id: "ana3",
        question: "Clock is to time as thermometer is to ___",
        options: ["Temperature", "Weather", "Heat", "Season"],
        correctAnswerIndex: 0,
        testType: TestType.analogies,
      ),
      AssessmentQuestion(
        id: "ana4",
        question: "Tree is to bark as human is to ___",
        options: ["Clothes", "Skin", "Hair", "Muscles"],
        correctAnswerIndex: 1,
        testType: TestType.analogies,
      ),
      AssessmentQuestion(
        id: "ana5",
        question: "Spoon is to stir as broom is to ___",
        options: ["Clean", "Dust", "Sweep", "Scrub"],
        correctAnswerIndex: 2,
        testType: TestType.analogies,
      ),
      AssessmentQuestion(
        id: "ana6",
        question: "Mountain is to peak as ocean is to ___",
        options: ["Beach", "Wave", "Sand", "Shore"],
        correctAnswerIndex: 1,
        testType: TestType.analogies,
      ),
    ];
  }

  // Arithmetic Questions
  static List<AssessmentQuestion> _getArithmeticQuestions() {
    return [
      AssessmentQuestion(
        id: "math1",
        question:
            "If each notebook costs 7 rupees and you have 3 notebooks, how much money do you need in total?",
        options: ["21 rupees", "24 rupees", "18 rupees", "28 rupees"],
        correctAnswerIndex: 0,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math2",
        question:
            "If a bag contains 6 candies and each candy costs 2 rupees, how much money is needed to buy all the candies?",
        options: ["12 rupees", "14 rupees", "10 rupees", "8 rupees"],
        correctAnswerIndex: 0,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math3",
        question:
            "If a toy costs 5 rupees and you have 2 rupees, how many more rupees do you need to buy the toy?",
        options: ["2 rupees", "4 rupees", "3 rupees", "5 rupees"],
        correctAnswerIndex: 2,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math4",
        question:
            "If a box contains 8 pencils and each pencil costs 4 rupees, how much do all the pencils cost?",
        options: ["32 rupees", "36 rupees", "40 rupees", "28 rupees"],
        correctAnswerIndex: 0,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math5",
        question:
            "If a packet of erasers costs 10 rupees and you want to buy 2 packets, how much will you spend?",
        options: ["20 rupees", "25 rupees", "15 rupees", "18 rupees"],
        correctAnswerIndex: 0,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math6",
        question:
            "If there are 15 chocolates, and they need to be shared equally among 3 friends, how many chocolates will each friend get?",
        options: [
          "3 chocolates",
          "5 chocolates",
          "4 chocolates",
          "6 chocolates",
        ],
        correctAnswerIndex: 1,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math7",
        question:
            "If a packet of crayons costs 9 rupees and you have 3 rupees, how many more rupees do you need to buy the crayons?",
        options: ["4 rupees", "5 rupees", "6 rupees", "7 rupees"],
        correctAnswerIndex: 2,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math8",
        question:
            "If a bookshelf has 20 books and each shelf can hold 5 books, how many shelves are needed for all the books?",
        options: ["3 shelves", "4 shelves", "5 shelves", "6 shelves"],
        correctAnswerIndex: 1,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math9",
        question:
            "If a bag has 24 marbles and they need to be divided equally into 4 groups, how many marbles are in each group?",
        options: ["6 marbles", "5 marbles", "7 marbles", "8 marbles"],
        correctAnswerIndex: 0,
        testType: TestType.arithmetic,
      ),
      AssessmentQuestion(
        id: "math10",
        question:
            "If a box contains 30 chocolates, and you want to share them with 5 friends, how many chocolates will each friend get?",
        options: [
          "4 chocolates",
          "5 chocolates",
          "6 chocolates",
          "7 chocolates",
        ],
        correctAnswerIndex: 2,
        testType: TestType.arithmetic,
      ),
    ];
  }

  // Number Series Questions
  static List<AssessmentQuestion> _getNumberSeriesQuestions() {
    return [
      AssessmentQuestion(
        id: "ns1",
        question: "Number Series: 101, 111, ____, 131, ____",
        options: ["121, 141", "121, 151", "131, 141", "121, 131"],
        correctAnswerIndex: 0,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns2",
        question: "Number Series: 2, 5, 11, ____, 47, ____",
        options: ["15, 20", "12, 18", "23, 95", "18, 24"],
        correctAnswerIndex: 2,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns3",
        question: "Number Series: 3, 6, 12, ____, 48, ____",
        options: ["20, 30", "18, 24", "24, 96", "24, 42"],
        correctAnswerIndex: 2,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns4",
        question: "Number Series: 50, 45, _____, 35, 30, ______",
        options: ["40, 25", "38, 33", "35, 30", "32, 27"],
        correctAnswerIndex: 0,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns5",
        question: "Number Series: 3, 6, 9, ____, 15, ____",
        options: ["11, 14", "12, 18", "10, 13", "15, 21"],
        correctAnswerIndex: 1,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns6",
        question: "Number Series: 7, 14, ______, 28, 35, ______",
        options: ["20, 27", "18, 25", "21, 42", "16, 23"],
        correctAnswerIndex: 2,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns7",
        question: "Number Series: 4, 8, ____, 16, ____",
        options: ["10, 12", "12, 20", "14, 18", "15, 20"],
        correctAnswerIndex: 1,
        testType: TestType.numberSeries,
      ),
      AssessmentQuestion(
        id: "ns8",
        question: "Number Series: 12, 24, ____, 48, 60, ______",
        options: ["36, 72", "30, 42", "28, 38", "32, 44"],
        correctAnswerIndex: 0,
        testType: TestType.numberSeries,
      ),
    ];
  }

  // General Knowledge Questions
  static List<AssessmentQuestion> _getGeneralKnowledgeQuestions() {
    return [
      AssessmentQuestion(
        id: "gk1",
        question: "What is the term for a person who writes a book?",
        options: ["Biographer", "Author", "Historian", "Novelist"],
        correctAnswerIndex: 1,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk2",
        question:
            "What is the term for a person who studies and writes about history?",
        options: ["Philosopher", "Archaeologist", "Historian", "Biographer"],
        correctAnswerIndex: 2,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk3",
        question:
            "What is the term for a work in which people write about their own life?",
        options: ["Autobiography", "Novel", "Biography", "Memory"],
        correctAnswerIndex: 0,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk4",
        question: "What is the term for a person who writes fictional stories?",
        options: ["Playwright", "Poet", "Novelist", "Essayist"],
        correctAnswerIndex: 2,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk5",
        question: "What is the term for a person who writes plays?",
        options: ["Novelist", "Poet", "Playwright", "Screenwriter"],
        correctAnswerIndex: 2,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk6",
        question:
            "What is the term for the process of plants making their own food using sunlight?",
        options: [
          "Respiration",
          "Photosynthesis",
          "Decomposition",
          "Transpiration",
        ],
        correctAnswerIndex: 1,
        testType: TestType.generalKnowledge,
      ),
      AssessmentQuestion(
        id: "gk7",
        question:
            "What is the term for a sudden, violent shaking of the ground, often causing destruction?",
        options: ["Hurricane", "Tornado", "Earthquake", "Tsunami"],
        correctAnswerIndex: 2,
        testType: TestType.generalKnowledge,
      ),
    ];
  }

  // Visual Recognition Questions
  static List<AssessmentQuestion> _getVisualRecognitionQuestions() {
    return [
      AssessmentQuestion(
        id: "vr1",
        question: "Count the objects in the image:",
        options: ["12", "19", "14", "15"],
        correctAnswerIndex: 0, // Placeholder - will need actual image
        testType: TestType.visualRecognition,
        imagePath: "assets/images/assessment/q1.png",
      ),
      AssessmentQuestion(
        id: "vr2",
        question: "What do you see in the sky in this image?",
        options: ["A bird", "A cloud", "A kite", "A plane"],
        correctAnswerIndex: 2, // Placeholder - will need actual image
        testType: TestType.visualRecognition,
        imagePath: "assets/images/assessment/q2.png",
      ),
      AssessmentQuestion(
        id: "vr3",
        question: "Identify the object in the image:",
        options: ["Potato", "Potato", "Tomato", "Pumpkin"],
        correctAnswerIndex: 2, // Placeholder - will need actual image
        testType: TestType.visualRecognition,
        imagePath: "assets/images/assessment/q3.png",
      ),
    ];
  }

  // Calculate cognitive analysis
  static Map<String, double> calculateCognitiveAnalysis(
    AssessmentResult result,
  ) {
    Map<String, double> analysis = {};

    // Word Processing & Language Skills
    int languageScore =
        (result.sectionScores[TestType.jumbledWords] ?? 0) +
        (result.sectionScores[TestType.analogies] ?? 0) +
        (result.sectionScores[TestType.generalKnowledge] ?? 0);
    int languageTotal = 9 + 6 + 7; // Total questions for language sections
    analysis['Language Skills'] = (languageScore / languageTotal * 100);

    // Logical Reasoning & Pattern Recognition
    int reasoningScore =
        (result.sectionScores[TestType.oddOneOut] ?? 0) +
        (result.sectionScores[TestType.numberSeries] ?? 0);
    int reasoningTotal = 9 + 8;
    analysis['Logical Reasoning'] = (reasoningScore / reasoningTotal * 100);

    // Mathematical Thinking
    int mathScore = result.sectionScores[TestType.arithmetic] ?? 0;
    int mathTotal = 10;
    analysis['Mathematical Thinking'] = (mathScore / mathTotal * 100);

    // Visual Processing
    int visualScore = result.sectionScores[TestType.visualRecognition] ?? 0;
    int visualTotal = 3;
    analysis['Visual Processing'] = (visualScore / visualTotal * 100);

    // Time Management (based on average time per question)
    double avgTimePerQuestion = 0;
    int totalQuestions = 0;
    result.timeSpent.forEach((testType, timeInSeconds) {
      TestSection section = getTestSections().firstWhere(
        (s) => s.type == testType,
      );
      totalQuestions += section.questions.length;
      avgTimePerQuestion += timeInSeconds;
    });
    avgTimePerQuestion = avgTimePerQuestion / totalQuestions;

    // Good time management if average is under 45 seconds per question
    analysis['Time Management'] =
        avgTimePerQuestion <= 45 ? 85.0 : (45 / avgTimePerQuestion * 85);

    return analysis;
  }

  // Generate feedback based on cognitive analysis
  static List<CognitiveAbility> generateCognitiveFeedback(
    Map<String, double> analysis,
  ) {
    return [
      CognitiveAbility(
        name: "Language Skills",
        description: "Word recognition and vocabulary",
        percentage: analysis['Language Skills'] ?? 0,
        feedback: _getLanguageFeedback(analysis['Language Skills'] ?? 0),
        color: const Color(0xFF6366F1),
        icon: Icons.text_fields,
      ),
      CognitiveAbility(
        name: "Logical Reasoning",
        description: "Pattern recognition and logical thinking",
        percentage: analysis['Logical Reasoning'] ?? 0,
        feedback: _getReasoningFeedback(analysis['Logical Reasoning'] ?? 0),
        color: const Color(0xFF8B5CF6),
        icon: Icons.psychology,
      ),
      CognitiveAbility(
        name: "Math Skills",
        description: "Problem solving and calculations",
        percentage: analysis['Mathematical Thinking'] ?? 0,
        feedback: _getMathFeedback(analysis['Mathematical Thinking'] ?? 0),
        color: const Color(0xFF10B981),
        icon: Icons.calculate,
      ),
      CognitiveAbility(
        name: "Visual Skills",
        description: "Image recognition and observation",
        percentage: analysis['Visual Processing'] ?? 0,
        feedback: _getVisualFeedback(analysis['Visual Processing'] ?? 0),
        color: const Color(0xFFFF6B35),
        icon: Icons.visibility,
      ),
      CognitiveAbility(
        name: "Time Management",
        description: "Speed and efficiency",
        percentage: analysis['Time Management'] ?? 0,
        feedback: _getTimeFeedback(analysis['Time Management'] ?? 0),
        color: const Color(0xFFF59E0B),
        icon: Icons.timer,
      ),
    ];
  }

  static String _getLanguageFeedback(double percentage) {
    if (percentage >= 80)
      return "Excellent vocabulary and word skills! Keep reading! 📚";
    if (percentage >= 60)
      return "Good language skills! Try reading more stories! 📖";
    if (percentage >= 40)
      return "Keep practicing with word games and reading! 💪";
    return "Let's work on building vocabulary together! 🌟";
  }

  static String _getReasoningFeedback(double percentage) {
    if (percentage >= 80)
      return "Amazing logical thinking! You're a pattern detective! 🕵️";
    if (percentage >= 60) return "Good reasoning skills! Try more puzzles! 🧩";
    if (percentage >= 40) return "Keep practicing logical thinking games! 🎯";
    return "Let's practice with fun logic puzzles! 🎪";
  }

  static String _getMathFeedback(double percentage) {
    if (percentage >= 80) return "Math superstar! You're great with numbers! ⭐";
    if (percentage >= 60) return "Good math skills! Practice makes perfect! 🔢";
    if (percentage >= 40) return "Keep working on math problems! 📊";
    return "Let's make math fun with games and practice! 🎲";
  }

  static String _getVisualFeedback(double percentage) {
    if (percentage >= 80) return "Sharp eyes! You notice everything! 👀";
    if (percentage >= 60) return "Good observation skills! 🔍";
    if (percentage >= 40) return "Practice looking at details! 🎨";
    return "Let's play visual games to improve! 🖼️";
  }

  static String _getTimeFeedback(double percentage) {
    if (percentage >= 80) return "Great time management! You're efficient! ⏰";
    if (percentage >= 60) return "Good timing! Keep practicing! ⏱️";
    if (percentage >= 40) return "Work on solving problems faster! 🚀";
    return "Take your time, but try to be quicker! 🐇";
  }

  // Data persistence methods
  static const String _resultsKey = 'assessment_results';

  // Save assessment result
  static Future<void> saveAssessmentResult(AssessmentResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingResults = prefs.getStringList(_resultsKey) ?? [];
    
    // Add new result
    existingResults.add(jsonEncode(result.toJson()));
    
    // Keep only last 10 results to prevent storage overflow
    if (existingResults.length > 10) {
      existingResults.removeAt(0);
    }
    
    await prefs.setStringList(_resultsKey, existingResults);
  }

  // Load all assessment results
  static Future<List<AssessmentResult>> loadAssessmentResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> resultsJson = prefs.getStringList(_resultsKey) ?? [];
    
    return resultsJson.map((jsonString) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return AssessmentResult.fromJson(json);
    }).toList();
  }

  // Get latest assessment result
  static Future<AssessmentResult?> getLatestResult() async {
    final results = await loadAssessmentResults();
    if (results.isEmpty) return null;
    
    // Sort by completion date and get latest
    results.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return results.first;
  }

  // Check if user has taken assessment
  static Future<bool> hasUserTakenAssessment() async {
    final results = await loadAssessmentResults();
    return results.isNotEmpty;
  }

  // Get assessment count
  static Future<int> getAssessmentCount() async {
    final results = await loadAssessmentResults();
    return results.length;
  }

  // Delete all assessment results (for reset)
  static Future<void> clearAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resultsKey);
  }
}

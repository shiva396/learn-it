import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'test_pack_models.dart';

class TestPacksData {
  // Topic Information
  static List<TopicInfo> getTopicsList() {
    return [
      TopicInfo(
        topic: GrammarTopic.adjective,
        name: 'Adjectives',
        description: 'Words that describe nouns',
        emoji: '🎨',
        color: 'blue',
      ),
      TopicInfo(
        topic: GrammarTopic.noun,
        name: 'Nouns',
        description: 'Names of people, places, things',
        emoji: '🏠',
        color: 'green',
      ),
      TopicInfo(
        topic: GrammarTopic.pronoun,
        name: 'Pronouns',
        description: 'Words that replace nouns',
        emoji: '👤',
        color: 'purple',
      ),
      TopicInfo(
        topic: GrammarTopic.verb,
        name: 'Verbs',
        description: 'Action and doing words',
        emoji: '🏃',
        color: 'orange',
      ),
      TopicInfo(
        topic: GrammarTopic.adverb,
        name: 'Adverbs',
        description: 'Words that describe verbs',
        emoji: '⚡',
        color: 'red',
      ),
      TopicInfo(
        topic: GrammarTopic.preposition,
        name: 'Prepositions',
        description: 'Words that show position',
        emoji: '📍',
        color: 'teal',
      ),
      TopicInfo(
        topic: GrammarTopic.conjunction,
        name: 'Conjunctions',
        description: 'Words that connect sentences',
        emoji: '🔗',
        color: 'indigo',
      ),
      TopicInfo(
        topic: GrammarTopic.interjection,
        name: 'Interjections',
        description: 'Words that express emotions',
        emoji: '🎭',
        color: 'pink',
      ),
    ];
  }

  // Difficulty Information
  static Map<DifficultyLevel, Map<String, dynamic>> getDifficultyInfo() {
    return {
      DifficultyLevel.easy: {
        'name': 'Easy',
        'description': 'Perfect for beginners',
        'color': LColors.success,
        'icon': Icons.sentiment_satisfied,
        'timeInMinutes': 5,
      },
      DifficultyLevel.medium: {
        'name': 'Medium',
        'description': 'Good challenge',
        'color': LColors.warning,
        'icon': Icons.sentiment_neutral,
        'timeInMinutes': 8,
      },
      DifficultyLevel.hard: {
        'name': 'Hard',
        'description': 'Expert level',
        'color': LColors.error,
        'icon': Icons.sentiment_very_dissatisfied,
        'timeInMinutes': 10,
      },
    };
  }

  // Get test pack for specific topic and difficulty with exactly 10 questions
  static TestPack? getTestPack(GrammarTopic topic, DifficultyLevel difficulty) {
    TestPack? pack;
    switch (topic) {
      case GrammarTopic.adjective:
        pack = _getAdjectiveTestPack(difficulty);
        break;
      case GrammarTopic.noun:
        pack = _getNounTestPack(difficulty);
        break;
      case GrammarTopic.pronoun:
        pack = _getPronounTestPack(difficulty);
        break;
      case GrammarTopic.verb:
        pack = _getVerbTestPack(difficulty);
        break;
      case GrammarTopic.adverb:
        pack = _getAdverbTestPack(difficulty);
        break;
      case GrammarTopic.preposition:
        pack = _getPrepositionTestPack(difficulty);
        break;
      case GrammarTopic.conjunction:
        pack = _getConjunctionTestPack(difficulty);
        break;
      case GrammarTopic.interjection:
        pack = _getInterjectionTestPack(difficulty);
        break;
    }

    // Ensure exactly 10 questions by shuffling and taking first 10
    if (pack != null && pack.questions.length > 10) {
      final shuffledQuestions = List<TestQuestion>.from(pack.questions);
      shuffledQuestions.shuffle();
      return TestPack(
        topic: pack.topic,
        difficulty: pack.difficulty,
        title: pack.title,
        description: pack.description,
        timeInMinutes: pack.timeInMinutes,
        questions: shuffledQuestions.take(10).toList(),
      );
    }

    return pack;
  }

  // Adjective test packs (you'll provide the questions)
  static TestPack? _getAdjectiveTestPack(DifficultyLevel difficulty) {
    final difficultyInfo = getDifficultyInfo()[difficulty]!;

    switch (difficulty) {
      case DifficultyLevel.easy:
        return TestPack(
          topic: GrammarTopic.adjective,
          difficulty: difficulty,
          title: 'Adjectives - Easy',
          description: 'Basic adjective identification and usage',
          timeInMinutes: difficultyInfo['timeInMinutes'],
          questions: _getAdjectiveEasyQuestions(),
        );
      case DifficultyLevel.medium:
        return TestPack(
          topic: GrammarTopic.adjective,
          difficulty: difficulty,
          title: 'Adjectives - Medium',
          description: 'Moderate adjective challenges',
          timeInMinutes: difficultyInfo['timeInMinutes'],
          questions: _getAdjectiveMediumQuestions(),
        );
      case DifficultyLevel.hard:
        return TestPack(
          topic: GrammarTopic.adjective,
          difficulty: difficulty,
          title: 'Adjectives - Hard',
          description: 'Advanced adjective mastery',
          timeInMinutes: difficultyInfo['timeInMinutes'],
          questions: _getAdjectiveHardQuestions(),
        );
    }
  }

  // Adjective question methods
  static List<TestQuestion> _getAdjectiveEasyQuestions() {
    return [
      TestQuestion(
        id: 'adj_easy_1',
        question: 'What is an adjective?',
        options: [
          'A word that denotes a name of a person, place, or thing.',
          'A word that describes a noun.',
          'A type of action word.',
          'A word used to show emotions.',
        ],
        correctAnswerIndex: 1,
        explanation:
            'An adjective is a word that describes or modifies a noun by providing more information about its qualities, characteristics, or attributes.',
      ),
      TestQuestion(
        id: 'adj_easy_2',
        question:
            'Which of the following is an adjective in the sentence: "The green grass grew tall"?',
        options: ['The', 'Grew', 'Green', 'Grass'],
        correctAnswerIndex: 2,
        explanation:
            '"Green" is an adjective that describes the color of the grass.',
      ),
      TestQuestion(
        id: 'adj_easy_3',
        question:
            'Identify the adjective in the sentence: "She found a tiny seashell on the beach."',
        options: ['She', 'Found', 'Beach', 'Tiny'],
        correctAnswerIndex: 3,
        explanation:
            '"Tiny" is an adjective that describes the size of the seashell.',
      ),
      TestQuestion(
        id: 'adj_easy_4',
        question:
            'Choose the correct adjective to complete the sentence: "The cat is very ____."',
        options: ['Run', 'Running', 'Playful', 'Played'],
        correctAnswerIndex: 2,
        explanation:
            '"Playful" is an adjective that describes the cat\'s personality or behavior.',
      ),
      TestQuestion(
        id: 'adj_easy_5',
        question:
            'Which of the following sentences uses an adjective to compare two things?',
        options: [
          'The sun shines brightly.',
          'She danced gracefully.',
          'Hari is taller than any other boy in the class.',
          'He ran quickly.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"Taller" is a comparative adjective that compares Hari\'s height to other boys.',
      ),
      TestQuestion(
        id: 'adj_easy_6',
        question:
            'What does the adjective "fuzzy" describe in the sentence: "The fuzzy teddy bear was cuddly"?',
        options: ['Teddy bear', 'Was', 'Fuzzy', 'Cuddly'],
        correctAnswerIndex: 0,
        explanation: '"Fuzzy" describes the texture of the teddy bear.',
      ),
      TestQuestion(
        id: 'adj_easy_7',
        question: 'Which of the following is a comparative adjective?',
        options: ['Fast', 'Fun', 'Faster', 'Beautiful'],
        correctAnswerIndex: 2,
        explanation:
            '"Faster" is a comparative adjective used to compare the speed of two things.',
      ),
      TestQuestion(
        id: 'adj_easy_8',
        question:
            'In the sentence, "The hungry cat meowed loudly," what does the word "hungry" describe?',
        options: ['Cat', 'Meowed', 'The', 'Cat'],
        correctAnswerIndex: 0,
        explanation: '"Hungry" describes the state or condition of the cat.',
      ),
      TestQuestion(
        id: 'adj_easy_9',
        question:
            'Which kind of adjective is used to denote a particular thing or person we are talking about?',
        options: [
          'Descriptive adjective',
          'Comparative adjective',
          'Demonstrative adjective',
          'Possessive adjective',
        ],
        correctAnswerIndex: 2,
        explanation:
            'Demonstrative adjectives (this, that, these, those) point out specific things or people.',
      ),
      TestQuestion(
        id: 'adj_easy_10',
        question:
            'What type of adjective is used to show ownership or possession?',
        options: [
          'Descriptive adjective',
          'Comparative adjective',
          'Demonstrative adjective',
          'Possessive adjective',
        ],
        correctAnswerIndex: 3,
        explanation:
            'Possessive adjectives (my, your, his, her, its, our, their) show ownership.',
      ),
      TestQuestion(
        id: 'adj_easy_11',
        question:
            'Identify the adjective in the sentence: "The old library is near to the school."',
        options: ['Near', 'Has', 'Old', 'School'],
        correctAnswerIndex: 2,
        explanation:
            '"Old" is an adjective that describes the age of the library.',
      ),
      TestQuestion(
        id: 'adj_easy_12',
        question:
            'Choose the correct adjective to complete the sentence: "The ____ flowers in the garden are blooming."',
        options: ['Beautifully', 'Colourful', 'Laughed', 'Jumped'],
        correctAnswerIndex: 1,
        explanation:
            '"Colourful" is an adjective that describes the appearance of the flowers.',
      ),
      TestQuestion(
        id: 'adj_easy_13',
        question:
            '"They found a spooky house in the woods" The adjective in the sentence is ____.',
        options: ['Wood', 'Found', 'House', 'Spooky'],
        correctAnswerIndex: 3,
        explanation:
            '"Spooky" is an adjective that describes the atmosphere or appearance of the house.',
      ),
      TestQuestion(
        id: 'adj_easy_14',
        question:
            'Which of the following sentences contains adjective of quantity?',
        options: [
          'The sun sets in the west.',
          'The foolish old crow tried to sing.',
          'He claimed his half share of the booty.',
          'The bird sings beautifully.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"Half" is an adjective of quantity that tells us how much of the share he claimed.',
      ),
    ];
  }

  static List<TestQuestion> _getAdjectiveMediumQuestions() {
    return [
      TestQuestion(
        id: 'adj_med_1',
        question:
            'Which word in the sentence "The smiling child waved at the passing train" is the adjective?',
        options: ['Waved', 'Train', 'Child', 'Smiling'],
        correctAnswerIndex: 3,
        explanation:
            '"Smiling" is an adjective (participial adjective) that describes the child.',
      ),
      TestQuestion(
        id: 'adj_med_2',
        question:
            'Choose the correct adjective to complete the sentence: "The room was very ____."',
        options: ['Gracefully', 'Talented', 'Cluttered', 'Play'],
        correctAnswerIndex: 2,
        explanation:
            '"Cluttered" is an adjective that describes the state of the room.',
      ),
      TestQuestion(
        id: 'adj_med_3',
        question:
            'In the sentence, "The tallest giraffe reached for the leaves," what does the word "tallest" describe?',
        options: ['Giraffe', 'Reached', 'The', 'Leaves'],
        correctAnswerIndex: 0,
        explanation:
            '"Tallest" is a superlative adjective that describes the height of the giraffe.',
      ),
      TestQuestion(
        id: 'adj_med_4',
        question:
            'Which is the adjective in the sentence: "The happy puppy wagged its tail"?',
        options: ['Puppy', 'Wagged', 'Tail', 'Happy'],
        correctAnswerIndex: 3,
        explanation:
            '"Happy" is an adjective that describes the emotional state of the puppy.',
      ),
      TestQuestion(
        id: 'adj_med_5',
        question:
            'Identify the adjective in the sentence: "The giant elephant had tusks."',
        options: ['Elephant', 'Had', 'Giant', 'Tusks'],
        correctAnswerIndex: 2,
        explanation:
            '"Giant" is an adjective that describes the size of the elephant.',
      ),
      TestQuestion(
        id: 'adj_med_6',
        question:
            'Which of the following sentences uses an adjective to show possession?',
        options: [
          'They played outside.',
          'The sun is shining.',
          'My bicycle is red.',
          'The river flows smoothly.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"My" is a possessive adjective that shows ownership of the bicycle.',
      ),
      TestQuestion(
        id: 'adj_med_7',
        question:
            'Which type of adjective is used to compare one thing with the other?',
        options: [
          'Descriptive adjective',
          'Comparative adjective',
          'Demonstrative adjective',
          'Possessive adjective',
        ],
        correctAnswerIndex: 1,
        explanation:
            'Comparative adjectives are used to compare two things (e.g., taller, faster, better).',
      ),
      TestQuestion(
        id: 'adj_med_8',
        question:
            'In the sentence, "The three friends went to the park," what does the word "three" describe?',
        options: ['Friends', 'Went', 'Park', 'Three'],
        correctAnswerIndex: 0,
        explanation:
            '"Three" is a numeral adjective that tells us how many friends there are.',
      ),
      TestQuestion(
        id: 'adj_med_9',
        question:
            'Which of the following sentences contains a superlative adjective?',
        options: [
          'She is very friendly.',
          'The river is long.',
          'Mount Everest is the highest peak in the world.',
          'The cat is sleeping.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"Highest" is a superlative adjective that compares Mount Everest to all other peaks.',
      ),
      TestQuestion(
        id: 'adj_med_10',
        question:
            'Which is the adjective in the sentence: "The red balloon floated in the sky"?',
        options: ['Sky', 'Floated', 'Balloon', 'Red'],
        correctAnswerIndex: 3,
        explanation:
            '"Red" is an adjective that describes the color of the balloon.',
      ),
      TestQuestion(
        id: 'adj_med_11',
        question:
            'Identify the adjective in the sentence: "The pillow provided a comfortable sleep."',
        options: ['Sleep', 'Provided', 'Pillow', 'Comfortable'],
        correctAnswerIndex: 3,
        explanation:
            '"Comfortable" is an adjective that describes the quality of the sleep.',
      ),
      TestQuestion(
        id: 'adj_med_12',
        question:
            'In the sentence, "The old clock struck midnight," what does the word "old" describe?',
        options: ['Clock', 'Struck', 'The', 'Midnight'],
        correctAnswerIndex: 0,
        explanation:
            '"Old" is an adjective that describes the age of the clock.',
      ),
      TestQuestion(
        id: 'adj_med_13',
        question:
            'Choose the correct adjective to complete the sentence: "The baby has a ____ smile."',
        options: ['Tired', 'Plenty', 'Cute', 'Old'],
        correctAnswerIndex: 2,
        explanation:
            '"Cute" is an adjective that describes the quality of the baby\'s smile.',
      ),
      TestQuestion(
        id: 'adj_med_14',
        question:
            'Which of the following sentences contains an adjective that indicates "how many"?',
        options: [
          'The river flows calmly.',
          'The cat is friendly.',
          'He has three apples.',
          'She sings beautifully.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"Three" is a numeral adjective that indicates the quantity of apples.',
      ),
    ];
  }

  static List<TestQuestion> _getAdjectiveHardQuestions() {
    return [
      TestQuestion(
        id: 'adj_hard_1',
        question:
            'In the sentence, "The gigantic cake was a hit," what does the word "gigantic" describe?',
        options: ['Hit', 'Was', 'The', 'Cake'],
        correctAnswerIndex: 3,
        explanation:
            '"Gigantic" is an adjective that describes the enormous size of the cake.',
      ),
      TestQuestion(
        id: 'adj_hard_2',
        question:
            'Identify the adjective in the sentence: "The brave knight fought the dragon."',
        options: ['Dragon', 'Fought', 'Knight', 'Brave'],
        correctAnswerIndex: 3,
        explanation:
            '"Brave" is an adjective that describes the courage of the knight.',
      ),
      TestQuestion(
        id: 'adj_hard_3',
        question: 'Which of the following is a demonstrative adjective?',
        options: ['Beautiful', 'First', 'This', 'Little'],
        correctAnswerIndex: 2,
        explanation:
            '"This" is a demonstrative adjective that points out a specific thing.',
      ),
      TestQuestion(
        id: 'adj_hard_4',
        question:
            'In the sentence, "The green apple fell from the tree," what does the word "green" describe?',
        options: ['Tree', 'Fell', 'The', 'Apple'],
        correctAnswerIndex: 3,
        explanation:
            '"Green" is an adjective that describes the color of the apple.',
      ),
      TestQuestion(
        id: 'adj_hard_5',
        question:
            'Which is the adjective in the sentence: "The shimmering stars lit up the night sky."',
        options: ['Sky', 'Lit-up', 'Stars', 'Shimmering'],
        correctAnswerIndex: 3,
        explanation:
            '"Shimmering" is an adjective that describes how the stars appear.',
      ),
      TestQuestion(
        id: 'adj_hard_6',
        question:
            'Identify the adjective in the sentence: "The jolly clown made the children laugh."',
        options: ['Children', 'Made', 'Clown', 'Jolly'],
        correctAnswerIndex: 3,
        explanation:
            '"Jolly" is an adjective that describes the cheerful nature of the clown.',
      ),
      TestQuestion(
        id: 'adj_hard_7',
        question:
            'Which type of adjective is used to question about the nouns?',
        options: [
          'Demonstrative adjective',
          'Quantitative adjective',
          'Interrogative adjective',
          'Possessive adjective',
        ],
        correctAnswerIndex: 2,
        explanation:
            'Interrogative adjectives (which, what, whose) are used to ask questions about nouns.',
      ),
      TestQuestion(
        id: 'adj_hard_8',
        question:
            'In the sentence, "The thirsty traveller drank from the well," what does the word "thirsty" describe?',
        options: ['Well', 'Drank', 'From', 'Traveller'],
        correctAnswerIndex: 3,
        explanation:
            '"Thirsty" is an adjective that describes the condition of the traveller.',
      ),
      TestQuestion(
        id: 'adj_hard_9',
        question:
            'Which is the adjective in the sentence: "The mysterious box sat in the corner."',
        options: ['Corner', 'Sat', 'Box', 'Mysterious'],
        correctAnswerIndex: 3,
        explanation:
            '"Mysterious" is an adjective that describes the intriguing nature of the box.',
      ),
      TestQuestion(
        id: 'adj_hard_10',
        question:
            'Which of the following sentences contains a superlative adjective?',
        options: [
          'The flowers are colourful.',
          'The mountain is higher than a hill.',
          'She is the best singer in the choir.',
          'The bird sings sweetly.',
        ],
        correctAnswerIndex: 2,
        explanation:
            '"Best" is a superlative adjective that compares the singer to all others in the choir.',
      ),
      TestQuestion(
        id: 'adj_hard_11',
        question:
            'In the sentence, "The gloomy weather ruined the picnic," what does the word "gloomy" describe?',
        options: ['Picnic', 'Ruined', 'The', 'Weather'],
        correctAnswerIndex: 3,
        explanation:
            '"Gloomy" is an adjective that describes the dark and depressing nature of the weather.',
      ),
      TestQuestion(
        id: 'adj_hard_12',
        question:
            'What type of adjective is used to describe an action or state?',
        options: [
          'Descriptive adjective',
          'Comparative adjective',
          'Participial adjective',
          'Possessive adjective',
        ],
        correctAnswerIndex: 2,
        explanation:
            'Participial adjectives are formed from verbs and describe actions or states (e.g., running water, broken glass).',
      ),
      TestQuestion(
        id: 'adj_hard_13',
        question:
            'Identify the adjective in the sentence: "The frightened child ran to her mother."',
        options: ['Mother', 'Ran', 'Child', 'Frightened'],
        correctAnswerIndex: 3,
        explanation:
            '"Frightened" is an adjective that describes the emotional state of the child.',
      ),
    ];
  }

  // Placeholder methods for other topics (we'll implement these later)
  static TestPack? _getNounTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide noun questions
    return null;
  }

  static TestPack? _getPronounTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide pronoun questions
    return null;
  }

  static TestPack? _getVerbTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide verb questions
    return null;
  }

  static TestPack? _getAdverbTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide adverb questions
    return null;
  }

  static TestPack? _getPrepositionTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide preposition questions
    return null;
  }

  static TestPack? _getConjunctionTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide conjunction questions
    return null;
  }

  static TestPack? _getInterjectionTestPack(DifficultyLevel difficulty) {
    // TODO: Implement when you provide interjection questions
    return null;
  }
}

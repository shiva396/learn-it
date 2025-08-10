import 'package:flutter/material.dart';
import 'package:learnit/ui/organisms/pages/confused_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/exercises_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/explanation_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adjective_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adverb_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/grammar_page.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/pages/profile/profile_page.dart';
import 'package:learnit/ui/organisms/pages/profile/profile_details_page.dart';
import 'package:learnit/ui/organisms/pages/profile/settings_page.dart';
import 'package:learnit/ui/organisms/pages/profile/about_page.dart';
import 'package:learnit/ui/organisms/pages/mistakes_page.dart';
import 'package:learnit/ui/organisms/pages/tests_page.dart';
import 'package:learnit/ui/organisms/pages/streak_test_page.dart';
import 'package:learnit/ui/organisms/welcome/splash_screen.dart';
import 'package:learnit/ui/organisms/pages/grammer/nouns_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/adjective/adjective_explanation_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/noun_explanation_page.dart';
import 'package:learnit/ui/organisms/welcome/welcome_screen.dart';
import 'package:learnit/ui/organisms/welcome/onboarding_screen.dart';
import 'package:learnit/ui/organisms/pages/exercises/jumbled_words_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/odd_one_out_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/analogies_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/arithmetic_word_problems_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/number_series_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/vocabulary_definitions_page.dart';
import 'package:learnit/ui/organisms/pages/exercises/image_based_questions_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/pronouns_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/verbs_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/prepositions_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/conjunctions_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/interjections_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/adjective/paint_the_cat.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Splash(),
  '/explanation': (context) => const ExplanationPage(),
  '/grammar': (context) => const GrammarPage(),
  '/grammar/nouns': (context) => const NounsPage(),
  '/grammar/pronouns': (context) => const PronounsPage(),
  '/grammar/verbs': (context) => const VerbsPage(),
  '/grammar/adjectives': (context) => const AdjectivePage(),
  '/grammar/adverbs': (context) => const AdverbPage(),
  '/grammar/prepositions': (context) => const PrepositionsPage(),
  '/grammar/conjunctions': (context) => const ConjunctionsPage(),
  '/grammar/interjections': (context) => const InterjectionsPage(),
  '/exercises': (context) => const ExercisesPage(),
  '/tests': (context) => const TestsPage(),
  '/mistakes': (context) => const MistakesPage(),
  '/confused': (context) => const ConfusedPage(),
  '/home': (context) => const HomeScreen(),
  '/menu': (context) => const MenuPage(),
  '/explanation/adjective': (context) => const AdjectiveExplanationPage(),
  '/explanation/noun': (context) => const NounExplanationPage(),
  '/welcome': (context) => const WelcomeScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/exercises/jumbled_words': (context) => const JumbledWordsPage(),
  '/exercises/odd_one_out': (context) => const OddOneOutPage(),
  '/exercises/analogies': (context) => const AnalogiesPage(),
  '/exercises/arithmetic_word_problems':
      (context) => const ArithmeticWordProblemsPage(),
  '/exercises/number_series': (context) => const NumberSeriesPage(),
  '/exercises/vocabulary_definitions':
      (context) => const VocabularyDefinitionsPage(),
  '/exercises/image_based_questions':
      (context) => const ImageBasedQuestionsPage(),
  '/explanation/paint_the_cat': (context) => const PaintTheCatPage(),
  '/streak_test': (context) => const StreakTestPage(),
  '/profile/details': (context) => const ProfileDetailsPage(),
  '/profile/settings': (context) => const SettingsPage(),
  '/profile/about': (context) => const AboutPage(),
};

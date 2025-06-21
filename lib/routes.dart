import 'package:flutter/material.dart';
import 'package:learnit/ui/organisms/pages/confused_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/excercises_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/explanation_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adjective_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adverb_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/articles_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/conditional_sentences_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/gerund_infinitive_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/modals_auxiliaries_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/grammar_page.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/pages/profile/profile_page.dart';
import 'package:learnit/ui/organisms/pages/mistakes_page.dart';
import 'package:learnit/ui/organisms/pages/tests_page.dart';
import 'package:learnit/ui/organisms/welcome/splash_screen.dart';
import 'package:learnit/ui/organisms/pages/grammer/nouns_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/adjective_explanation_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/noun_explanation_page.dart';
import 'package:learnit/ui/organisms/welcome/welcome_screen.dart';
import 'package:learnit/ui/organisms/welcome/onboarding_screen.dart';
import 'package:learnit/ui/organisms/pages/excercises/jumbled_words_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/odd_one_out_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/analogies_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/arithmetic_word_problems_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/number_series_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/vocabulary_definitions_page.dart';
import 'package:learnit/ui/organisms/pages/excercises/image_based_questions_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Splash(),
  '/explanation': (context) => const ExplanationPage(),
  '/grammar': (context) => const GrammarPage(),
  '/excercises': (context) => const ExcercisesPage(),
  '/tests': (context) => const TestsPage(),
  '/mistakes': (context) => const MistakesPage(),
  '/confused': (context) => const ConfusedPage(),
  '/home': (context) => const HomeScreen(),
  '/menu': (context) => const MenuPage(),
  '/grammar/adjective': (context) => const AdjectivePage(),
  '/grammar/adverb': (context) => const AdverbPage(),
  '/grammar/articles': (context) => const ArticlesPage(),
  '/grammar/conditional_sentences':
      (context) => const ConditionalSentencesPage(),
  '/grammar/gerund_and_infinitive': (context) => const GerundInfinitivePage(),
  '/grammar/modals_and_modal_auxiliaries':
      (context) => const ModalsAuxiliariesPage(),
  '/grammar/nouns': (context) => const NounsPage(),
  '/explanation/adjective': (context) => const AdjectiveExplanationPage(),
  '/explanation/noun': (context) => const NounExplanationPage(),
  '/welcome': (context) => const WelcomeScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/excercises/jumbled_words': (context) => const JumbledWordsPage(),
  '/excercises/odd_one_out': (context) => const OddOneOutPage(),
  '/excercises/analogies': (context) => const AnalogiesPage(),
  '/excercises/arithmetic_word_problems':
      (context) => const ArithmeticWordProblemsPage(),
  '/excercises/number_series': (context) => const NumberSeriesPage(),
  '/excercises/vocabulary_definitions':
      (context) => const VocabularyDefinitionsPage(),
  '/excercises/image_based_questions':
      (context) => const ImageBasedQuestionsPage(),
};

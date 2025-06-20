import 'package:flutter/material.dart';
import 'package:learnit/ui/organisms/pages/confused_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/explanation_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adjective_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adverb_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/articles_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/conditional_sentences_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/gerund_infinitive_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/modals_auxiliaries_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/grammar_page.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/pages/profile_page.dart';
import 'package:learnit/ui/organisms/pages/mistakes_page.dart';
import 'package:learnit/ui/organisms/pages/tenses_page.dart';
import 'package:learnit/ui/organisms/pages/tests_page.dart';
import 'package:learnit/ui/organisms/welcome/login_screen.dart';
import 'package:learnit/ui/organisms/welcome/signup_screen.dart';
import 'package:learnit/ui/organisms/welcome/splash_screen.dart';
import 'package:learnit/ui/organisms/pages/grammer/nouns_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/adjective_explanation_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/noun_explanation_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Splash(),
  '/explanation': (context) => const ExplanationPage(),
  '/grammar': (context) => const GrammarPage(),
  '/tenses': (context) => const TensesPage(),
  '/tests': (context) => const TestsPage(),
  '/mistakes': (context) => const MistakesPage(),
  '/confused': (context) => const ConfusedPage(),
  '/login': (context) => const LogIn(),
  '/signup': (context) => const SignUp(),
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
};

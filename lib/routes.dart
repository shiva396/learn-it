import 'package:flutter/material.dart';
import 'package:learnit/ui/organisms/pages/explanation/explanation_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adjective_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/adverb_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/grammar_page.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/pages/profile/profile_page.dart';
import 'package:learnit/ui/organisms/pages/profile/profile_details_page.dart';
import 'package:learnit/ui/organisms/pages/profile/about_page.dart';
import 'package:learnit/ui/organisms/pages/test_packs/tests_page.dart';
import 'package:learnit/ui/organisms/pages/test_packs/test_page.dart';
import 'package:learnit/ui/organisms/pages/test_packs/test_results_page.dart';
import 'package:learnit/ui/organisms/welcome/splash_screen.dart';
import 'package:learnit/ui/organisms/pages/grammer/nouns_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/adjective/adjective_explanation_page.dart';
import 'package:learnit/ui/organisms/pages/explanation/noun_explanation_page.dart';
import 'package:learnit/ui/organisms/welcome/welcome_screen.dart';
import 'package:learnit/ui/organisms/welcome/onboarding_screen.dart';
import 'package:learnit/ui/organisms/pages/grammer/pronouns_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/verbs_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/prepositions_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/conjunctions_page.dart';
import 'package:learnit/ui/organisms/pages/grammer/interjections_page.dart';
import 'package:learnit/ui/organisms/pages/interactive/paint_the_cat.dart';
import 'package:learnit/ui/organisms/pages/assessment/assessment_intro_page.dart';
import 'package:learnit/ui/organisms/pages/assessment/assessment_test_page.dart';
import 'package:learnit/ui/organisms/pages/assessment/assessment_analytics_page.dart';
import 'package:learnit/ui/organisms/pages/assessment/assessment_results_page.dart';
import 'package:learnit/ui/organisms/pages/recent_activities_page.dart';
import 'package:learnit/ui/organisms/pages/interactive/interactive_games_page.dart';
import 'package:learnit/ui/organisms/pages/interactive/magical_garden_grower.dart';
import 'package:learnit/ui/organisms/pages/slide_deck/slide_decks_page.dart';

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
  '/tests': (context) => const TestPacksPage(),
  '/test_packs/test': (context) => const TestPackTestPage(),
  '/test_packs/results': (context) => const TestResultsPage(),
  '/home': (context) => const HomeScreen(),
  '/menu': (context) => const MenuPage(),
  '/explanation/adjective': (context) => const AdjectiveExplanationPage(),
  '/explanation/noun': (context) => const NounExplanationPage(),
  '/welcome': (context) => const WelcomeScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/explanation/paint_the_cat': (context) => const PaintTheCatPage(),
  '/recent_activities': (context) => const RecentActivitiesPage(),
  '/profile/details': (context) => const ProfileDetailsPage(),
  '/profile/about': (context) => const AboutPage(),
  // Assessment routes
  '/assessment/intro': (context) => const AssessmentIntroPage(),
  '/assessment/test': (context) => const AssessmentTestPage(),
  '/assessment/analytics': (context) => const AssessmentAnalyticsPage(),
  '/assessment/results': (context) => const AssessmentResultsPage(),
  '/interactive_games': (context) => const InteractiveGamesPage(),
  '/magical-garden-grower': (context) => const MagicalGardenGrowerPage(),
  '/slide_decks': (context) => const SlideDecksPage(),
};

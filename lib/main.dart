import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnit/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MainApp(initialRoute: '/splash'));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: initialRoute, routes: appRoutes);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnit/routes.dart';
import 'package:learnit/services/streak_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await StreakService.startSession();

  runApp(const MainApp(initialRoute: '/'));
}

class MainApp extends StatefulWidget {
  final String initialRoute;

  const MainApp({required this.initialRoute, super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed - start new session
      StreakService.startSession();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App paused or closed - end session
      StreakService.endSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: widget.initialRoute, routes: appRoutes);
  }
}

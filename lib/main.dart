import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash.dart';
import '../widgets/no_glow_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodLens',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoGlowScrollBehavior(),
      home: const SplashScreen(),
    );
  }
}

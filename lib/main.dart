import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/splash.dart';
import 'screens/dietist.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/diet_plan_page.dart';
import 'providers/chat_provider.dart';
import 'providers/auth_provider.dart';
import '../widgets/no_glow_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const MyApp(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, auth, chat) {
            if (auth.user != null) {
              chat!..setUserProfile(auth.user!);
            }
            return chat!;
          },
        ),
      ],
      child: MaterialApp(
        title: 'FoodLens',
        debugShowCheckedModeBanner: false,
        scrollBehavior: NoGlowScrollBehavior(),
        theme: ThemeData(
          primaryColor: const Color(0xFF0F3C33),
          scaffoldBackgroundColor: const Color(0xFFFCF6EC),
        ), 
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
          '/diet': (_) => const DietistPage(),
          '/dietPlan': (_) => const DietPlanPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}

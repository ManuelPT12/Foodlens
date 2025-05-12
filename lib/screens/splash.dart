import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _checkLogin);
  }

  void _checkLogin() {
    final auth = context.read<AuthProvider>();
    if (auth.isLogged) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF50B878),
        child: Image.asset(
          'assets/images/initial-screen.png',
          fit: BoxFit.cover, // cubre toda la pantalla proporcionalmente
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

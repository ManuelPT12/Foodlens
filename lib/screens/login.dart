import 'package:flutter/material.dart';
import '../services/api.dart';
import 'register.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Color(0xFF50B878), // verde de éxito
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(userName: 'Sergio'),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6EC), // nuevo fondo blanco hueso
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
            final logoHeight = keyboardOpen ? 100.0 : 200.0;
            final spacing = keyboardOpen ? 16.0 : 32.0;

            return SingleChildScrollView(
              reverse:
                  true, // mantiene el TextField visible cuando aparece el teclado
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/foodlens.png',
                        height: logoHeight,
                      ),
                      SizedBox(height: spacing),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme.of(context).colorScheme
                                    .copyWith(primary: const Color(0xFF0F3C33)),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xFF0F3C33),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Enter your email'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme.of(context).colorScheme
                                    .copyWith(primary: const Color(0xFF0F3C33)),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xFF0F3C33),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Enter your password'
                                            : null,
                              ),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFE94B35),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF68D2E),
                                    foregroundColor: const Color(0xFF0F3C33),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: _login,
                                  child: const Text('Login'),
                                ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Register",
                                style: TextStyle(color: Color(0xFF0F3C33)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(), // empuja hacia arriba cuando hay espacio
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

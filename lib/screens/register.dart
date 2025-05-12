import 'package:flutter/material.dart';
import '../services/api.dart';
import 'login.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGoal;
  String? _selectedDietType;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _goals = [
    'Lose weight',
    'Gain muscle mass',
    'Maintain weight',
    'Improve endurance',
    'Tone body',
  ];

  final List<String> _dietTypes = [
    'Omnivore',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Flexitarian',
    'Keto',
    'Mediterranean',
    'Gluten-free',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      final age = DateTime.now().year - picked.year;
      _ageController.text = age.toString();
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await ApiService().registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDateController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender!,
        goal: _selectedGoal!,
        dietType: _selectedDietType!,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
            backgroundColor: Color(0xFF50B878), // verde de éxito
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Registration failed. Try a different email.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Check your connection.';
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
      backgroundColor: const Color(0xFFFCF6EC),
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF0F3C33),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: Color(0xFF0F3C33)),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        _firstNameController,
                        'First Name',
                        Icons.person,
                      ),
                      _buildTextField(
                        _lastNameController,
                        'Last Name',
                        Icons.person_outline,
                      ),
                      _buildDateField(
                        _birthDateController,
                        'Birth Date',
                        Icons.calendar_today,
                      ),
                      _buildTextField(
                        _ageController,
                        'Age',
                        Icons.numbers,
                        readOnly: true,
                      ),
                      _buildDropdown(
                        'Gender',
                        _selectedGender,
                        _genders,
                        Icons.person_pin,
                        (val) => setState(() => _selectedGender = val),
                      ),
                      _buildTextField(
                        _heightController,
                        'Height (cm)',
                        Icons.height,
                        isNumber: true,
                        minValue: 50,
                        maxValue: 250,
                      ),
                      _buildTextField(
                        _weightController,
                        'Weight (kg)',
                        Icons.monitor_weight,
                        isNumber: true,
                        minValue: 20,
                        maxValue: 300,
                      ),
                      _buildDropdown(
                        'Goal',
                        _selectedGoal,
                        _goals,
                        Icons.flag,
                        (val) => setState(() => _selectedGoal = val),
                      ),
                      _buildDropdown(
                        'Diet Type',
                        _selectedDietType,
                        _dietTypes,
                        Icons.fastfood,
                        (val) => setState(() => _selectedDietType = val),
                      ),
                      _buildTextField(
                        _emailController,
                        'Email',
                        Icons.email,
                        isEmail: true,
                      ),
                      _buildTextField(
                        _passwordController,
                        'Password',
                        Icons.lock,
                        obscureText: true,
                      ),
                      _buildTextField(
                        _confirmPasswordController,
                        'Confirm Password',
                        Icons.lock_outline,
                        obscureText: true,
                        isConfirmation: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Color(0xFFE94B35)),
                    ),
                  ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF68D2E),
                        foregroundColor: const Color(0xFF0F3C33),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _register,
                      icon: const Icon(Icons.check),
                      label: const Text('Register'),
                    ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFF0F3C33)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    bool isEmail = false,
    bool obscureText = false,
    bool readOnly = false,
    bool isConfirmation = false,
    int? minValue,
    int? maxValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isNumber
                ? TextInputType.number
                : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        obscureText: obscureText,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter $label';
          if (isEmail &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (isNumber) {
            final number = int.tryParse(value);
            if (number == null) return 'Enter a valid number';
            if (minValue != null && number < minValue)
              return '$label must be at least $minValue';
            if (maxValue != null && number > maxValue)
              return '$label must be less than $maxValue';
          }
          if (isConfirmation && value != _passwordController.text)
            return 'Passwords do not match';
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Select your $label' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Select your $label' : null,
      ),
    );
  }
}

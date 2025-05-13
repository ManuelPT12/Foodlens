import 'package:flutter/material.dart';
import '../services/api.dart';
import 'login.dart';
import 'package:intl/intl.dart';
import '../models/allergen.dart';

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
  String? _selectedGender;
  bool _isDiabetic = false;
  String? _selectedActivity;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasAllergies = false;
  List<Allergen> _allergens = [];
  Set<int> _selectedAllergens = {};

  final List<String> _goals = [
    'Perder peso',
    'Ganar masa muscular',
    'Mantener peso',
    'Mejorar resistencia',
    'Tonificar cuerpo',
  ];

  final List<String> _dietTypes = [
    'Omnívoro',
    'Vegetariano',
    'Vegano',
    'Pescetariano',
    'Flexitariano',
    'Cetogénica',
    'Mediterránea',
    'Sin gluten',
  ];

  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _activities = ['Sedentario', 'Moderado', 'Activo'];

  @override
  void initState() {
    super.initState();
    ApiService().fetchAllergens().then((list) {
      setState(() => _allergens = list);
    });
  }

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
        _errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newUserId = await ApiService().registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDateController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender!,
        goal: _selectedGoal!,
        dietType: _selectedDietType!,
        isDiabetic: _isDiabetic,
        activityLevel: _selectedActivity!,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (newUserId != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada con éxito'),
            backgroundColor: Color(0xFF50B878),
            duration: Duration(seconds: 2),
          ),
        );
        if (_hasAllergies && _selectedAllergens.isNotEmpty) {
          for (var allergenId in _selectedAllergens) {
            await ApiService().registerUserAllergen(
              userId: newUserId,
              allergenId: allergenId,
            );
          }
        }

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Error en el registro. Prueba con otro correo.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Algo salió mal. Comprueba tu conexión.';
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
        title: const Text('Registro'),
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
                    ).colorScheme.copyWith(primary: const Color(0xFF0F3C33)),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        _firstNameController,
                        'Nombre',
                        Icons.person,
                      ),
                      _buildTextField(
                        _lastNameController,
                        'Apellido',
                        Icons.person_outline,
                      ),
                      _buildTextField(
                        _emailController,
                        'Correo electrónico',
                        Icons.email,
                        isEmail: true,
                      ),
                      _buildTextField(
                        _passwordController,
                        'Contraseña',
                        Icons.lock,
                        obscureText: true,
                      ),
                      _buildTextField(
                        _confirmPasswordController,
                        'Confirmar contraseña',
                        Icons.lock_outline,
                        obscureText: true,
                        isConfirmation: true,
                      ),
                      _buildDateField(
                        _birthDateController,
                        'Fecha de nacimiento',
                        Icons.calendar_today,
                      ),
                      _buildTextField(
                        _ageController,
                        'Edad',
                        Icons.numbers,
                        readOnly: true,
                      ),
                      _buildDropdown(
                        'Género',
                        _selectedGender,
                        _genders,
                        Icons.person_pin,
                        (val) => setState(() => _selectedGender = val),
                      ),
                      _buildTextField(
                        _heightController,
                        'Altura (cm)',
                        Icons.height,
                        isNumber: true,
                        minValue: 50,
                        maxValue: 250,
                      ),
                      _buildTextField(
                        _weightController,
                        'Peso (kg)',
                        Icons.monitor_weight,
                        isNumber: true,
                        minValue: 20,
                        maxValue: 300,
                      ),
                      _buildDropdown(
                        'Objetivo',
                        _selectedGoal,
                        _goals,
                        Icons.flag,
                        (val) => setState(() => _selectedGoal = val),
                      ),
                      _buildDropdown(
                        'Tipo de dieta',
                        _selectedDietType,
                        _dietTypes,
                        Icons.fastfood,
                        (val) => setState(() => _selectedDietType = val),
                      ),
                      _buildDropdown(
                        'Nivel de actividad física',
                        _selectedActivity,
                        _activities,
                        Icons.fitness_center,
                        (val) => setState(() => _selectedActivity = val),
                      ),
                      CheckboxListTile(
                        title: const Text('¿Eres diabético?'),
                        value: _isDiabetic,
                        onChanged:
                            (val) => setState(() => _isDiabetic = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text('¿Eres alérgico a algo?'),
                        value: _hasAllergies,
                        onChanged:
                            (val) => setState(() => _hasAllergies = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      if (_hasAllergies) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Selecciona tus alérgenos:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        // Mostrar scrollable list de checkboxes:
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white, // fondo blanco
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView(
                            padding:
                                EdgeInsets.zero, // quitar padding por defecto
                            children:
                                _allergens.map((a) {
                                  return CheckboxListTile(
                                    dense: true, // hace el tile más compacto
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, // reduce margen lateral
                                      vertical: 0, // margén vertical mínimo
                                    ),
                                    title: Text(
                                      a.name,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    secondary:
                                        a.iconUrl != null
                                            ? Image.network(
                                              a.iconUrl!,
                                              width: 24,
                                            )
                                            : null,
                                    value: _selectedAllergens.contains(a.id),
                                    onChanged: (sel) {
                                      setState(() {
                                        if (sel == true)
                                          _selectedAllergens.add(a.id);
                                        else
                                          _selectedAllergens.remove(a.id);
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
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
                        foregroundColor: const Color(0xFFFFFFFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _register,
                      icon: const Icon(Icons.check),
                      label: const Text('Registrarse'),
                    ),
                TextButton(
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                  child: const Text(
                    '¿Ya tienes una cuenta? Iniciar sesión',
                    style: TextStyle(color: Color(0xFF0F3C33)),
                  ),
                ),
                const SizedBox(height: 30),
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
          prefixIcon: Icon(icon, color: const Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Ingrese $label';
          if (isEmail && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value))
            return 'Ingrese un correo válido';
          if (isNumber) {
            final number = int.tryParse(value);
            if (number == null) return 'Ingrese un número válido';
            if (minValue != null && number < minValue)
              return '$label debe ser al menos $minValue';
            if (maxValue != null && number > maxValue)
              return '$label debe ser menor que $maxValue';
          }
          if (isConfirmation && value != _passwordController.text)
            return 'Las contraseñas no coinciden';
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
          prefixIcon: Icon(icon, color: const Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Seleccione $label' : null,
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
          prefixIcon: Icon(icon, color: const Color(0xFF0F3C33)),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Seleccione $label' : null,
      ),
    );
  }
}

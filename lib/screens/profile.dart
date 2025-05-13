// lib/screens/profile.dart

import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Controladores para los campos del usuario
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _birthDateCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  String? _gender;
  String? _goal;
  String? _dietType;
  String? _activityLevel;
  bool _isDiabetic = false;

  // Listas de opciones (puedes extraerlas a un lugar central)
  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];
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
  final List<String> _activities = ['Moderado', 'Activo', 'Sedentario'];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    // Inicializa los controladores con los datos del usuario logueado:
    _firstNameCtrl.text = user.firstName;
    _lastNameCtrl.text = user.lastName;
    _birthDateCtrl.text = DateFormat('yyyy-MM-dd').format(user.birthDate);
    _ageCtrl.text = user.age.toString();
    _heightCtrl.text = user.height.toString();
    _weightCtrl.text = user.weight.toString();
    _gender = user.gender;
    _goal = user.goal;
    _dietType = user.dietType;
    _activityLevel = user.activityLevel;
    _isDiabetic = user.isDiabetic;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    setState(() => _isLoading = true);
    try {
      // 2) Llama a ApiService.updateUser como antes:
      await ApiService().updateUser(
        id: auth.user!.id,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        birthDate: DateTime.parse(_birthDateCtrl.text),
        weight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        age: int.parse(_ageCtrl.text),
        gender: _gender!,
        goal: _goal!,
        dietType: _dietType!,
        activityLevel: _activityLevel!,
        isDiabetic: _isDiabetic,
      );

      // 3) Actualiza también el usuario en el AuthProvider
      // auth.user = auth.user!.copyWith(
      //   firstName: _firstNameCtrl.text.trim(),
      //   lastName:  _lastNameCtrl.text.trim(),
      //   birthDate: DateTime.parse(_birthDateCtrl.text),
      //   weight:    double.parse(_weightCtrl.text),
      //   height:    double.parse(_heightCtrl.text),
      //   age:       int.parse(_ageCtrl.text),
      //   gender:    _gender!,
      //   goal:      _goal!,
      //   dietType:  _dietType!,
      //   activityLevel: _activityLevel!,
      //   isDiabetic: _isDiabetic,
      // );
      // auth.notifyListeners();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    } catch (e) {
      setState(() => _error = 'Error al actualizar perfil');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_birthDateCtrl.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dt != null) {
      _birthDateCtrl.text = DateFormat('yyyy-MM-dd').format(dt);
      _ageCtrl.text = (DateTime.now().year - dt.year).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Conserva solo el AppBar de tu Navbar:
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF6EC),
        foregroundColor: const Color(0xFF0F3C33),
        elevation: 0,
        title: const Text('Mi Perfil'),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      _buildTextField(_firstNameCtrl, 'Nombre'),
                      _buildTextField(_lastNameCtrl, 'Apellido'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          controller: _birthDateCtrl,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'Seleccione Fecha de nacimiento'
                                      : null,
                        ),
                      ),
                      _buildTextField(_ageCtrl, 'Edad', readOnly: true),
                      _buildTextField(
                        _heightCtrl,
                        'Altura (cm)',
                        isNumber: true,
                      ),
                      _buildTextField(_weightCtrl, 'Peso (kg)', isNumber: true),
                      _buildDropdown(
                        'Género',
                        _gender,
                        _genders,
                        (v) => setState(() => _gender = v),
                      ),
                      _buildDropdown(
                        'Objetivo',
                        _goal,
                        _goals,
                        (v) => setState(() => _goal = v),
                      ),
                      _buildDropdown(
                        'Dieta',
                        _dietType,
                        _dietTypes,
                        (v) => setState(() => _dietType = v),
                      ),
                      _buildDropdown(
                        'Actividad física',
                        _activityLevel,
                        _activities,
                        (v) => setState(() => _activityLevel = v),
                      ),
                      CheckboxListTile(
                        title: const Text('¿Es diabético?'),
                        value: _isDiabetic,
                        onChanged: (v) => setState(() => _isDiabetic = v!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF68D2E),
                          foregroundColor: const Color(0xFFFFFFFF),
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController c,
    String label, {
    bool isNumber = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.edit, size: 20),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          if ((v == null || v.isEmpty) && !readOnly) return 'Ingrese $label';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? current,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: current,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items:
            options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? 'Seleccione $label' : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'register_food.dart';
import '../models/meal_log.dart';
import 'package:intl/intl.dart';
import 'calendar_slider.dart';
import '../services/api.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/no_glow_scroll_behavior.dart';

class DiaryPage extends StatefulWidget {
  final List<DateTime> days;
  final int selectedDayIndex;
  final ValueChanged<int> onSelectDay;
  final void Function(int) shiftWindow;

  const DiaryPage({
    Key? key,
    required this.days,
    required this.selectedDayIndex,
    required this.onSelectDay,
    required this.shiftWindow,
  }) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<MealLog> _breakfastLogs = [];
  List<MealLog> _lunchLogs = [];
  List<MealLog> _snackLogs = [];
  List<MealLog> _dinnerLogs = [];
  late int _userId;
  bool _loading = true;
  int _objective = 0;
  int _eaten = 0;
  int _remaining = 0;

  final ApiService _api = ApiService();
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _userId = auth.user!.id;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final date = widget.days[widget.selectedDayIndex];

    // 1) Carga dieta
    final diet = await _api.fetchUserDiet(userId: _userId);
    _objective = diet.dailyCalories;

    // 2) Logs del día
    final logs = await _api.fetchMealLogsByDate(userId: _userId, date: date);

    // debug
    debugPrint('Logs($date): count=${logs.length}');
    logs.forEach((l) {
      debugPrint(' → ${l.mealType}: ${l.dishName} (${l.calories}kcal)');
    });

    // 3) Calcula consumido
    _eaten = logs.fold<int>(0, (sum, l) => sum + (l.calories ?? 0));

    // 4) Agrupa por tipo
    _breakfastLogs = logs.where((l) => l.mealType == 'desayuno').toList();
    _lunchLogs = logs.where((l) => l.mealType == 'almuerzo').toList();
    _snackLogs = logs.where((l) => l.mealType == 'merienda').toList();
    _dinnerLogs = logs.where((l) => l.mealType == 'cena').toList();

    // 5) Calcula restante (exercise por ahora 0)
    _remaining = _objective - _eaten;

    setState(() => _loading = false);
  }

  void _onDaySelected(int idx) {
    widget.onSelectDay(idx);
    _loadData();
  }

  void _onShift(int days) {
    widget.shiftWindow(days);
    _loadData();
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<MealLog> logs,
    required String mealType,
  }) {
    if (_loading) return const CircularProgressIndicator();

    // Si no hay logs, mostramos el botón
    if (logs.isEmpty) {
      return _RegisterSection(
        icon: icon,
        title: title,
        subtitle: 'No se registraron alimentos',
        buttonText: 'Registrar comida',
        onPressed: () => _goToRegister(mealType),
      );
    }

    // Si hay logs, mostramos una lista dentro de la tarjeta
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: const Color(0xFF0F3C33)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F3C33),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Lista de MealCard reducidos
            Column(
              children:
                  logs
                      .map(
                        (log) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MealCard(log: log),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _goToRegister(mealType),
                child: const Text('Añadir más'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToRegister(String mealType) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => RegisterFoodPage(mealType: mealType),
          ),
        )
        .then((_) {
          // cuando regrese, recargamos datos
          _loadData();
        });
  }

  @override
  Widget build(BuildContext context) {
    // datos de ejemplo; en producción vendrán de tu servicio/API
    final objective = _objective;
    const exercise  = 0;
    final eaten     = _eaten;
    final remaining = _remaining;

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Calendario deslizante
              CalendarSlider(
                days: widget.days, // usa widget.days
                selectedIndex:
                    widget.selectedDayIndex, // widget.selectedDayIndex
                onSelect: _onDaySelected,
                onPrev: () => _onShift(-1),
                onNext: () => _onShift(1),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Calorías restantes
                    _CaloriesRemaining(
                      objective: objective,
                      exercise: exercise,
                      eaten: eaten,
                      remaining: remaining,
                    ),
                    const SizedBox(height: 24),
                    // Secciones de registro
                    _RegisterSection(
                      icon: Icons.fitness_center,
                      title: 'Ejercicio',
                      subtitle: '',
                      buttonText: 'Registrar ejercicio',
                      onPressed: () {
                        // TODO: Navegar a página de ejercicio...
                      },
                    ),
                    // ...
                    _buildSection(
                      icon: Icons.free_breakfast,
                      title: 'Desayuno',
                      logs: _breakfastLogs,
                      mealType: 'Desayuno',
                    ),
                    _buildSection(
                      icon: Icons.lunch_dining,
                      title: 'Almuerzo',
                      logs: _lunchLogs,
                      mealType: 'Almuerzo',
                    ),
                    // Merienda
                    _buildSection(
                      icon: Icons.emoji_food_beverage,
                      title: 'Merienda',
                      logs: _snackLogs,
                      mealType: 'Merienda',
                    ),
                    // Cena
                    _buildSection(
                      icon: Icons.dinner_dining,
                      title: 'Cena',
                      logs: _dinnerLogs,
                      mealType: 'Cena',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar objetivo + ejercicio – comida = restante
class _CaloriesRemaining extends StatelessWidget {
  final int objective, exercise, eaten, remaining;
  const _CaloriesRemaining({
    required this.objective,
    required this.exercise,
    required this.eaten,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calorías Restantes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F3C33),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CalcBox(label: 'Objetivo', value: objective.toString()),
            _CalcBox(label: 'Ejercicio', value: exercise.toString()),
            _CalcBox(label: 'Comida', value: eaten.toString()),
            _CalcBox(label: 'Restante', value: remaining.toString()),
          ],
        ),
      ],
    );
  }
}

class _CalcBox extends StatelessWidget {
  final String label, value;
  const _CalcBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF68D2E),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

/// Tarjeta genérica para registrar ejercicio o comida
class _RegisterSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const _RegisterSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centra todo verticalmente
            children: [
              Icon(icon, size: 32, color: const Color(0xFF0F3C33)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centra el título/subtítulo
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F3C33),
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF68D2E),
                  foregroundColor: Color(0xFFFCF6EC), // texto en blanco
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ), // tamaño de letra reducido
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, // botón más pequeño
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 0),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final MealLog log;
  const MealCard({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatea la hora, p.ej. "17:26"
    final time = DateFormat('HH:mm').format(log.mealDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.only(left: 8, right: 0, top: 2, bottom: 2),
        child: Row(
          children: [
            // Imagen: si log.imageUrl existe la carga de red, si no un asset de fallback
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(log.imageUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del plato + menú “más”
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.dishName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF0F3C33),
                        ),
                        onSelected: (value) {
                          // manejar acciones edit/delete/copy
                        },
                        itemBuilder:
                            (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar'),
                              ),
                            ],
                        constraints: const BoxConstraints(minWidth: 50),
                      ),
                    ],
                  ),
                  // Tipo de comida y hora
                  Text(
                    '${log.mealType} · $time',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  // Nutrientes
                  Row(
                    children: [
                      Text(
                        '${log.calories} kcal',
                        style: const TextStyle(
                          color: Color(0xFFE94B35),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${log.protein.toStringAsFixed(0)} g',
                        style: const TextStyle(
                          color: Color(0xFF0F3C33),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${log.fat.toStringAsFixed(0)} g',
                        style: const TextStyle(
                          color: Color(0xFFF68D2E),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${log.carbs.toStringAsFixed(0)} g',
                        style: const TextStyle(
                          color: Color(0xFF4DB879),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImage(String? url) {
  const placeholder = 'assets/images/sample_meal.jpeg';
  if (url == null) {
    return Image.asset(placeholder, width: 60, height: 60, fit: BoxFit.cover);
  }
  // Si empieza por “http” lo tratamos como red
  if (url.startsWith('http')) {
    return Image.network(
      url,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        // si falla la red, caemos al asset
        return Image.asset(
          placeholder,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        );
      },
    );
  }
  // Si no, asumimos un asset local (quita “file://” si viene así)
  final assetPath = url.replaceFirst(RegExp(r'^file://'), '');
  return Image.asset(assetPath, width: 60, height: 60, fit: BoxFit.cover);
}

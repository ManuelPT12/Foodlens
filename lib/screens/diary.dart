import 'package:flutter/material.dart';
import 'register_food.dart';
import 'calendar_slider.dart';
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
  @override
  Widget build(BuildContext context) {
    // datos de ejemplo; en producción vendrán de tu servicio/API
    const objective = 2019;
    const exercise = 0;
    const eaten = 0;
    final remaining = objective + exercise - eaten;

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
                selectedIndex: widget.selectedDayIndex, // widget.selectedDayIndex
                onSelect: widget.onSelectDay, // widget.onSelectDay
                onPrev: () => widget.shiftWindow(-1), // widget.shiftWindow
                onNext: () => widget.shiftWindow(1),
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
                    _RegisterSection(
                      icon: Icons.free_breakfast,
                      title: 'Desayuno',
                      subtitle: '',
                      buttonText: 'Registrar comida',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const RegisterFoodPage(
                                  mealType: 'Desayuno',
                                ),
                          ),
                        );
                      },
                    ),
                    _RegisterSection(
                      icon: Icons.lunch_dining,
                      title: 'Almuerzo',
                      subtitle: '',
                      buttonText: 'Registrar comida',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const RegisterFoodPage(
                                  mealType: 'Almuerzo',
                                ),
                          ),
                        );
                      },
                    ),
                    _RegisterSection(
                      icon: Icons.emoji_food_beverage,
                      title: 'Merienda',
                      subtitle: '',
                      buttonText: 'Registrar comida',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const RegisterFoodPage(
                                  mealType: 'Merienda',
                                ),
                          ),
                        );
                      },
                    ),
                    _RegisterSection(
                      icon: Icons.dinner_dining,
                      title: 'Cena',
                      subtitle: '',
                      buttonText: 'Registrar comida',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const RegisterFoodPage(mealType: 'Cena'),
                          ),
                        );
                      },
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

// lib/screens/diet_plan_page.dart
import 'package:flutter/material.dart';

class DietPlanPage extends StatefulWidget {
  const DietPlanPage({Key? key}) : super(key: key);

  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  // Índice del día seleccionado (0 = lunes)
  int _selectedDay = 0;
  final _days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan dietético'),
        backgroundColor: const Color(0xFFFCF6EC),
        foregroundColor: const Color(0xFF0F3C33),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Selector de días
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              itemBuilder:
                  (_, i) => GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            i == _selectedDay
                                ? const Color(0xFFF68D2E)
                                : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _days[i],
                        style: TextStyle(
                          color:
                              i == _selectedDay
                                  ? Colors.white
                                  : const Color(0xFF0F3C33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            ),
          ),

          // Scroll de contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _MealCard(
                    mealName: 'Desayuno',
                    calories: 450,
                    protein: 20,
                    fat: 15,
                    carbs: 60,
                    title: 'Avena con frutos rojos',
                    ingredients: [
                      '60 g de avena',
                      '150 ml de leche desnatada',
                      '50 g de frutos rojos',
                      '1 cucharadita de miel',
                    ],
                    preparation:
                        'Mezcla la avena con la leche, calienta 5 min y añade frutos rojos y miel.',
                    benefits:
                        'Energético y rico en fibra para un buen arranque de día.',
                  ),
                  const SizedBox(height: 12),
                  _MealCard(
                    mealName: 'Almuerzo',
                    calories: 600,
                    protein: 40,
                    fat: 20,
                    carbs: 70,
                    title: 'Pechuga de pollo con quinoa',
                    ingredients: [
                      '150 g de pechuga de pollo',
                      '100 g de quinoa cocida',
                      'Ensalada variada',
                    ],
                    preparation:
                        'A la plancha la pechuga, sirve con quinoa y ensalada.',
                    benefits:
                        'Alto contenido proteico y gran aporte de nutrientes.',
                  ),
                  const SizedBox(height: 12),
                  _MealCard(
                    mealName: 'Merienda',
                    calories: 300,
                    protein: 12,
                    fat: 10,
                    carbs: 35,
                    title: 'Yogur griego con nueces',
                    ingredients: [
                      '125 g de yogur griego',
                      '20 g de nueces picadas',
                      '1 cucharadita de semillas de chía',
                    ],
                    preparation: 'Mezcla todo y disfruta de un snack rápido.',
                    benefits:
                        'Proteína y grasas saludables para mantenerte saciado.',
                  ),
                  const SizedBox(height: 12),
                  _MealCard(
                    mealName: 'Cena',
                    calories: 500,
                    protein: 35,
                    fat: 15,
                    carbs: 50,
                    title: 'Salmón al horno con verduras',
                    ingredients: [
                      '150 g de salmón',
                      'Brócoli al vapor',
                      'Zanahoria al vapor',
                    ],
                    preparation:
                        'Hornea el salmón a 180 °C 20 min y sirve con verduras.',
                    benefits: 'Omega-3 y vitaminas para una cena ligera.',
                  ),
                  const SizedBox(height: 80), // espacio para botón “Guardar”
                ],
              ),
            ),
          ),
        ],
      ),

      // Botón “Guardar” fijo abajo
      // Al final de tu Scaffold:
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              /* TODO: guardar */
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF68D2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta genérica de comida
class _MealCard extends StatelessWidget {
  final String mealName, title, preparation, benefits;
  final int calories, protein, fat, carbs;
  final List<String> ingredients;

  const _MealCard({
    required this.mealName,
    required this.title,
    required this.ingredients,
    required this.preparation,
    required this.benefits,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3C33),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _MacroChip(
                  icon: Icons.local_fire_department,
                  text: '${calories}kcal',
                ),
                const SizedBox(width: 8),
                _MacroChip(icon: Icons.fitness_center, text: '${protein}g'),
                const SizedBox(width: 8),
                _MacroChip(icon: Icons.opacity, text: '${fat}g'),
                const SizedBox(width: 8),
                _MacroChip(icon: Icons.grass, text: '${carbs}g'),
              ],
            ),
            const SizedBox(height: 12),
            // Título receta
            Text(
              '🍴 $title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),
            ...ingredients.map((i) => Text('• $i')).toList(),

            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.restaurant, size: 16, color: Color(0xFF0F3C33)),
                SizedBox(width: 4),
                Text(
                  'Cómo preparar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(preparation),

            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.favorite, size: 16, color: Color(0xFF0F3C33)),
                SizedBox(width: 4),
                Text(
                  'Beneficios para la salud',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(benefits),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  /* TODO */
                },
                icon: const Icon(Icons.autorenew, color: Colors.white),
                label: const Text(
                  'Reemplazo IA',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3C33),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip sencillo para macros
class _MacroChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MacroChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFFE94B35)),
          const SizedBox(width: 2),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

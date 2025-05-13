import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import 'diary.dart';
import 'dietist.dart';
import '../models/meal_log.dart';
import '../models/user_diet.dart';
import 'what_to_eat.dart';
import 'calendar_slider.dart';
import '../services/api.dart';
import '../widgets/no_glow_scroll_behavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Índice de la pestaña activa
  int _currentIndex = 0;
  late int _userId;
  late String _userName;

  final ApiService _api = ApiService();
  List<MealLog> _todayLogs = [];
  UserDiet? _diet;
  bool _loading = true;

  // Controles de animación del pulso
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Datos para el calendario deslizante
  late DateTime _startDate;
  int _selectedDayIndex = 3;

  // Etiquetas e íconos de navegación
  final _labels = ['Home', 'Qué comer', 'Diario', 'Dietista'];
  final _icons = [
    Icons.home,
    Icons.restaurant_menu,
    Icons.library_books,
    Icons.support_agent,
  ];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _userId = auth.user!.id;
    _userName = auth.user!.firstName;
    // Center today in the window by subtracting 3 days
    _loadData();
    final today = DateTime.now();
    _startDate = today.subtract(const Duration(days: 3));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  List<DateTime> get _days =>
      List.generate(7, (i) => _startDate.add(Duration(days: i)));

  void _shiftWindow(int days) {
    setState(() {
      _startDate = _startDate.add(Duration(days: days));
    });
    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // 1) dieta del usuario
    final diet = await _api.fetchUserDiet(userId: _userId);
    // 2) meal logs sólo para el día seleccionado
    final date = _days[_selectedDayIndex];
    final todayLogs = await _api.fetchMealLogsByDate(
      userId: _userId,
      date: date,
    );

    setState(() {
      _diet = diet;
      _todayLogs = todayLogs;
      _loading = false;
    });
  }

  void _onDaySelected(int idx) {
    setState(() => _selectedDayIndex = idx);
    _loadData(); // recarga al cambiar fecha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        shadowColor: const Color(0xFFFCF6EC),
        surfaceTintColor: const Color(0xFFFCF6EC),
        foregroundColor: const Color(0xFFFCF6EC),
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/foodlens-horizontal.png', height: 38),
            Row(
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Color(0xFF0F3C33),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Color(0xFF0F3C33)),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
              ],
            ),
          ],
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : IndexedStack(
                index: _currentIndex,
                children: [
                  HomePageContent(
                    days: _days,
                    selectedDayIndex: _selectedDayIndex,
                    onSelectDay: _onDaySelected,
                    shiftWindow: _shiftWindow,
                    logs: _todayLogs,
                    diet: _diet!,
                    onGoToDiary: () => setState(() => _currentIndex = 2),
                  ),
                  const WhatToEatPage(),
                  DiaryPage(
                    days: _days,
                    selectedDayIndex: _selectedDayIndex,
                    onSelectDay:
                        (idx) => setState(() => _selectedDayIndex = idx),
                    shiftWindow: _shiftWindow,
                  ),
                  const DietistPage(),
                ],
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          _currentIndex == 3
              ? null
              : AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1) El pulso: tamaño fijo, sombra animada
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF68D2E).withOpacity(0.5),
                              blurRadius: _pulseAnimation.value,
                              spreadRadius: _pulseAnimation.value,
                            ),
                          ],
                        ),
                      ),
                      // 2) El botón: tamaño a medida, sin afectar al pulso
                      SizedBox(
                        width: 75, // aquí defines el nuevo tamaño
                        height: 75,
                        child: FloatingActionButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/camera'),
                          backgroundColor: const Color(0xFFF68D2E),
                          elevation: 4,
                          shape: const CircleBorder(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // const Icon(
                              //   Icons.crop_free_outlined,     // cuatro L apuntando hacia fuera
                              //   size: 60,            // ajústalo para que encaje perfectamente
                              //   color: Colors.white, // mismo color que el icono
                              // ),
                              CustomPaint(
                                size: const Size(48, 48),
                                painter: CornerLPainter(
                                  strokeWidth: 2, // aquí el grosor que quieras
                                  color: Colors.white,
                                ),
                              ),
                              // Icono en el centro
                              const Icon(
                                Icons.fastfood,
                                size: 32,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      // 3) El BottomAppBar con notch
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFCF6EC),
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              // Primer bloque con Home y Qué comer
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildNavItem(0), _buildNavItem(1)],
                ),
              ),

              // Sólo dejamos hueco cuando NO estamos en Dietista (_currentIndex != 3)
              if (_currentIndex != 3) const SizedBox(width: 90),

              // Segundo bloque con Diario y Dietista
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildNavItem(2), _buildNavItem(3)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool selected = index == _currentIndex;
    final Color activeColor = const Color(0xFFF68D2E);
    final Color inactiveColor = const Color(0xFF0F3C33);
    final color = selected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap:
          () => setState(() {
            _currentIndex = index;
          }),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1) Ícono con sombra si está activo
          Container(
            decoration:
                selected
                    ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                    : null,
            child: Icon(_icons[index], color: color),
          ),
          const SizedBox(height: 4),
          // 2) Label debajo
          Text(_labels[index], style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

// Contenido de la página Home
class HomePageContent extends StatelessWidget {
  final List<DateTime> days;
  final int selectedDayIndex;
  final ValueChanged<int> onSelectDay;
  final void Function(int) shiftWindow;
  final List<MealLog> logs;
  final UserDiet diet;
  final VoidCallback onGoToDiary;

  const HomePageContent({
    Key? key,
    required this.days,
    required this.selectedDayIndex,
    required this.onSelectDay,
    required this.shiftWindow,
    required this.logs,
    required this.diet,
    required this.onGoToDiary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumedCalories = logs.fold<int>(0, (sum, m) => sum + m.calories);
    final consumedProtein = logs.fold<double>(0, (sum, m) => sum + m.protein);
    final consumedFat = logs.fold<double>(0, (sum, m) => sum + m.fat);
    final consumedCarbs = logs.fold<double>(0, (sum, m) => sum + m.carbs);

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
                days: days,
                selectedIndex: selectedDayIndex,
                onSelect: onSelectDay,
                onPrev: () => shiftWindow(-1),
                onNext: () => shiftWindow(1),
              ),
              const SizedBox(height: 8),
              // Alimentos registrados con padding horizontal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alimentos registrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F3C33),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF0F3C33),
                      ),
                      onPressed: onGoToDiary,
                    ),
                  ],
                ),
              ),
              if (logs.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        'No se registraron alimentos',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF68D2E),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: onGoToDiary,
                        child: const Text('Registrar alimentos'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: logs.length,
                      itemBuilder: (ctx, i) => MealCard(log: logs[i]),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Resumen de Nutrientes con padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Resumen de Nutrientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F3C33),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CircleInfo(
                      label: 'Calorías',
                      value: consumedCalories,
                      unit: diet.dailyCalories.toString(),
                      color: const Color(0xFFE94B35),
                    ),
                    _CircleInfo(
                      label: 'Proteínas',
                      value: consumedProtein.toInt(),
                      unit: diet.dailyProtein.toStringAsFixed(0),
                      color: const Color(0xFF0F3C33),
                    ),
                    _CircleInfo(
                      label: 'Grasas',
                      value: consumedFat.toInt(),
                      unit: diet.dailyFat.toStringAsFixed(0),
                      color: const Color(0xFFF68D2E),
                    ),
                    _CircleInfo(
                      label: 'Carbohidratos',
                      value: consumedCarbs.toInt(),
                      unit: diet.dailyCarbs.toStringAsFixed(0),
                      color: const Color(0xFF4DB879),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/dietPlan'),
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.event_note,
                                size: 32,
                                color: Color(0xFF0F3C33),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Plan dietético',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F3C33),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            () => Navigator.pushNamed(context, '/restaurants'),
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.store,
                                size: 32,
                                color: Color(0xFF0F3C33),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Restaurantes',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F3C33),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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

class _CircleInfo extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final Color color;
  const _CircleInfo({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / double.parse(unit),
                color: color,
                backgroundColor: color.withOpacity(0.2),
                strokeWidth: 6,
              ),
            ),
            Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text('/$unit', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class CornerLPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  CornerLPainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeJoin =
              StrokeJoin
                  .bevel // ¡IMPORTANTE para quitar el pico!
          ..strokeCap = StrokeCap.butt; // cortes cuadrados

    final double inset = 4 + strokeWidth / 2; // separación icono ↔ L
    final double len = 12; // longitud de cada brazo

    // ┌ Superior-izquierda ┐
    Path tl =
        Path()
          ..moveTo(inset, inset + len)
          ..lineTo(inset, inset)
          ..lineTo(inset + len, inset);
    canvas.drawPath(tl, paint);

    // ┐ Superior-derecha ┌
    Path tr =
        Path()
          ..moveTo(size.width - inset - len, inset)
          ..lineTo(size.width - inset, inset)
          ..lineTo(size.width - inset, inset + len);
    canvas.drawPath(tr, paint);

    // └ Inferior-izquierda ┘
    Path bl =
        Path()
          ..moveTo(inset, size.height - inset - len)
          ..lineTo(inset, size.height - inset)
          ..lineTo(inset + len, size.height - inset);
    canvas.drawPath(bl, paint);

    // ┘ Inferior-derecha └
    Path br =
        Path()
          ..moveTo(size.width - inset - len, size.height - inset)
          ..lineTo(size.width - inset, size.height - inset)
          ..lineTo(size.width - inset, size.height - inset - len);
    canvas.drawPath(br, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

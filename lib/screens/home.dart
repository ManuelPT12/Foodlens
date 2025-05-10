import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({Key? key, this.userName = 'Sergio'}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Start date for the 7-day window
  late DateTime _startDate;
  // Selected index within the window (0..6)
  int _selectedDayIndex = 3;

  @override
  void initState() {
    super.initState();
    // Center today in the window by subtracting 3 days
    final today = DateTime.now();
    _startDate = today.subtract(const Duration(days: 3));
  }

  List<DateTime> get _days =>
      List.generate(7, (i) => _startDate.add(Duration(days: i)));

  void _shiftWindow(int days) {
    setState(() {
      _startDate = _startDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    final selectedDate = days[_selectedDayIndex];
    final monthLabel = DateFormat.yMMMM('es').format(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/foodlens-horizontal.png', height: 38),
            Row(
              children: [
                Text(
                  widget.userName,
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
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month label
            Center(
              child: Text(
                monthLabel,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            // Days slider row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0F3C33)),
                  onPressed: () => _shiftWindow(-1),
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      // separatorBuilder: (_, __) => const SizedBox(width: 2),
                      itemBuilder: (context, idx) {
                        final day = days[idx];
                        final isSelected = idx == _selectedDayIndex;
                        final weekday = DateFormat.E('es').format(day);
                        // Disable future days beyond today + 2
                        final tooFuture = day.isAfter(
                          DateTime.now().add(const Duration(days: 0)),
                        );
                        return GestureDetector(
                          onTap:
                              tooFuture
                                  ? null
                                  : () =>
                                      setState(() => _selectedDayIndex = idx),
                          child: Container(
                            width: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFFF68D2E)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Opacity(
                              opacity: tooFuture ? 0.4 : 1.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    weekday,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF0F3C33),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF0F3C33),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF0F3C33),
                  ),
                  // Sólo habilita "adelante" si el último día es <= hoy+2
                  onPressed:
                      _days.last.isBefore(
                            DateTime.now().add(const Duration(days: 2)),
                          )
                          ? () => _shiftWindow(1)
                          : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
           const SizedBox(height: 16),
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (ctx, i) => const _MealCard(),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _CircleInfo(
                    label: 'Calorías',
                    value: 586,
                    unit: '2019',
                    color: Color(0xFFE94B35),
                  ),
                  _CircleInfo(
                    label: 'Proteína',
                    value: 37,
                    unit: '151',
                    color: Color(0xFF0F3C33),
                  ),
                  _CircleInfo(
                    label: 'Grasa',
                    value: 31,
                    unit: '67',
                    color: Color(0xFFF68D2E),
                  ),
                  _CircleInfo(
                    label: 'Carbohidr',
                    value: 40,
                    unit: '201',
                    color: Color(0xFF4DB879),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/camera'),
        backgroundColor: const Color(0xFFF68D2E),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Analizar comida'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF4DB879),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.home, color: Colors.white)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.book, color: Colors.white)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 250,
        padding: const EdgeInsets.only(left: 4, right: 0, top: 2, bottom: 2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/sample_meal.jpeg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Bowl de pollo con arroz y verduras',
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
                        icon: const Icon(Icons.more_vert, color: Color(0xFF0F3C33)),
                        onSelected: (value) {},
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('Editar')),
                          const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                          const PopupMenuItem(value: 'copy', child: Text('Copiar')),
                        ],
                        constraints: const BoxConstraints(minWidth: 50),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 2),
                  Text(
                    'Cena · Hoy 17:26',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  // const Spacer(),
                  Row(
                    children: const [
                      Text(
                        '586kcal',
                        style: TextStyle(
                          color: Color(0xFFE94B35),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '37g',
                        style: TextStyle(
                          color: Color(0xFF0F3C33),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '31g',
                        style: TextStyle(
                          color: Color(0xFFF68D2E),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '40g',
                        style: TextStyle(
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
        Text('/\$unit', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

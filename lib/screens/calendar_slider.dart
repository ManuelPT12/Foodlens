import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarSlider extends StatelessWidget {
  final List<DateTime> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const CalendarSlider({
    Key? key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
    required this.onPrev,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // fecha de hoy sin hora
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // tope para avanzar: hoy + 2 días
    final limitDate = today.add(const Duration(days: 3));

    // permitimos avanzar si el último día de la ventana no supera el tope
    final canNext = !days.last.isAfter(limitDate);
    // siempre permitimos retroceder; si se desea tope atrás, similar lógica a canNext
    const canPrev = true;

    final selectedDate = days[selectedIndex];
    final monthLabel = DateFormat.yMMMM('es').format(selectedDate);

    return Column(
      children: [
        Center(
          child: Text(
            monthLabel,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F3C33)),
              onPressed: canPrev ? onPrev : null,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (ctx, idx) {
                    final day = days[idx];
                    final isSel = idx == selectedIndex;
                    final tooFuture = day.isAfter(DateTime.now());
                    return GestureDetector(
                      onTap: tooFuture ? null : () => onSelect(idx),
                      child: Container(
                        width: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFF68D2E) : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Opacity(
                          opacity: tooFuture ? 0.4 : 1.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.E('es').format(day),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSel
                                      ? Colors.white
                                      : const Color(0xFF0F3C33),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSel
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
              icon: const Icon(Icons.arrow_forward, color: Color(0xFF0F3C33)),
              onPressed: canNext ? onNext : null,
            ),
          ],
        ),
      ],
    );
  }
}

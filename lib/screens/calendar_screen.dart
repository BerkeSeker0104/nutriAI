import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<String, List<Map<String, String>>> sampleData = {
    '2025-05-15': [
      {'meal': 'Tatlı + kahve', 'mood': '😔'},
      {'meal': 'Makarna', 'mood': '😐'},
    ],
    '2025-05-16': [
      {'meal': 'Tavuk salata', 'mood': '😊'},
    ],
    '2025-05-17': [
      {'meal': 'Pizza', 'mood': '😴'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final String selectedKey = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDay ?? _focusedDay);
    final List<Map<String, String>>? meals = sampleData[selectedKey];

    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.green.shade900 : Colors.green.shade50;

    return Scaffold(
      appBar: AppBar(title: const Text('📅 Takvim')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: primaryColor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.redAccent),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child:
                meals == null
                    ? const Center(
                      child: Text('Seçilen tarihte kayıt bulunamadı.'),
                    )
                    : ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return Card(
                          color: cardColor,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Text(
                              meal['mood']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(meal['meal']!),
                            subtitle: Text('Ruh hali: ${meal['mood']}'),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

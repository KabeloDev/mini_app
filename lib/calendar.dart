import 'package:flutter/material.dart';
import 'package:mini_app/moodentry.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final List<MoodEntry> moodEntries;

  const CalendarScreen({super.key, required this.moodEntries});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<MoodEntry> _selectedMoods = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _updateMoodsForSelectedDay(_focusedDay);
  }

  void _updateMoodsForSelectedDay(DateTime day) {
    final dateOnly = DateTime(day.year, day.month, day.day);
    setState(() {
      _selectedMoods = widget.moodEntries
          .where((entry) =>
              entry.date.year == dateOnly.year &&
              entry.date.month == dateOnly.month &&
              entry.date.day == dateOnly.day)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _updateMoodsForSelectedDay(selectedDay);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedMoods.isEmpty
                ? Center(child: Text('No mood entry for this day.'))
                : ListView.builder(
                    itemCount: _selectedMoods.length,
                    itemBuilder: (context, index) {
                      final mood = _selectedMoods[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text('${mood.mood} - ${mood.timeOfDay}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reason: ${mood.reason}'),
                              Text('Description: ${mood.description}'),
                            ],
                          ),
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

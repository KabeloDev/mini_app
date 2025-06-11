import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/moodentry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_cubit.dart'; // import your cubit here

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
      _selectedMoods = widget.moodEntries.where((entry) {
        return entry.date.year == dateOnly.year &&
            entry.date.month == dateOnly.month &&
            entry.date.day == dateOnly.day;
      }).toList();
    });
  }

  Future<void> _editMoodEntry(MoodEntry mood) async {
    final updatedMood = await showModalBottomSheet<MoodEntry>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final reasonController = TextEditingController(text: mood.reason);
        final descriptionController = TextEditingController(text: mood.description);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Wrap(
            children: [
              Text("Edit Mood Entry", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MoodEntry(
                          mood: mood.mood,
                          date: mood.date,
                          reason: reasonController.text,
                          description: descriptionController.text,
                          timeOfDay: mood.timeOfDay,
                        ),
                      );
                    },
                    child: Text('Save'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    if (updatedMood != null) {
      // call cubit update with the new mood entry
      context.read<CalendarCubit>().updateMoodEntry(updatedMood);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarCubit, MoodEntry>(
      listener: (context, updatedEntry) {
        // Update the list and UI when a mood entry is updated
        final index = widget.moodEntries.indexWhere((e) =>
            e.date == updatedEntry.date && e.timeOfDay == updatedEntry.timeOfDay);
        if (index != -1) {
          setState(() {
            widget.moodEntries[index] = updatedEntry;
            _updateMoodsForSelectedDay(_selectedDay!);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Mood Calendar')),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                            onTap: () => _editMoodEntry(mood),
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
      ),
    );
  }
}

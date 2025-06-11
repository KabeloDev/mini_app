import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/calendar_cubit.dart';
import 'package:mini_app/moodentry.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  const CalendarScreen({super.key, required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();
    DateTime selectedDay = focusedDay;

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selDay, focDay) {
              selectedDay = selDay;
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: moodEntries.length,
              itemBuilder: (context, index) {
                final mood = moodEntries[index];

                return BlocBuilder<CalendarCubit, MoodEntry>(
                  
                  builder: (context, state) {
                    final moodSelected = (state.date == mood.date &&
                            state.timeOfDay == mood.timeOfDay)
                        ? state
                        : mood;

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () => _editMoodEntry(context, moodSelected),
                        title: Text('${moodSelected.mood} - ${moodSelected.timeOfDay}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reason: ${moodSelected.reason}'),
                            Text('Description: ${moodSelected.description}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editMoodEntry(BuildContext context, MoodEntry mood) async {
    final reasonController = TextEditingController();
    final descriptionController = TextEditingController();

    final updatedMood = await showModalBottomSheet<MoodEntry>(
      context: context,
      builder: (context) {
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
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
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
                    child: const Text('Save'),
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
      context.read<CalendarCubit>().updateMoodEntry(updatedMood);
    }
  }
}

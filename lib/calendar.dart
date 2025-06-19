import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/calendar_cubit.dart';
import 'package:mini_app/home_cubit.dart';
import 'package:mini_app/moodentry.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime focusedDay;
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = focusedDay;

    final moods = context.read<HomeCubit>().state;
    context.read<CalendarCubit>().setMoods(moods);
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                selectedDay = selDay;
                focusedDay = focDay;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<CalendarCubit, List<MoodEntry>>(
              builder: (context, moods) {
                final dayMoods = moods.where((m) => isSameDay(m.date, selectedDay)).toList();

                if (dayMoods.isEmpty) {
                  return const Center(child: Text('No moods recorded for this day.'));
                }

                return ListView.builder(
                  itemCount: dayMoods.length,
                  itemBuilder: (context, index) {
                    final mood = dayMoods[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () => _editMoodEntry(context, mood),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editMoodEntry(BuildContext context, MoodEntry mood) async {
    final reasonController = TextEditingController(text: mood.reason);
    final descriptionController = TextEditingController(text: mood.description);

    final updatedMood = await showModalBottomSheet<MoodEntry>(
      context: context,
      isScrollControlled: true,
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
      context.read<CalendarCubit>().updateMood(updatedMood);
    }
  }
}

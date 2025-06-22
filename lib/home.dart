import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/calendar.dart';
import 'package:mini_app/home_cubit.dart';
import 'package:mini_app/moodentry.dart';
import 'package:mini_app/stats_noti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMood;
  String _selectedTime = 'Morning';
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _onSave() {
    if (_selectedMood == null ||
        _reasonController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a mood')),
      );
      return;
    }

    final newMood = MoodEntry(
      mood: _selectedMood!,
      reason: _reasonController.text,
      description: _descriptionController.text,
      timeOfDay: _selectedTime,
      date: DateTime.now(),
    );

    log('🟢 New mood created: ${newMood.toJson()}');

    context.read<HomeCubit>().addMood(newMood);

    _reasonController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedMood = null;
      _selectedTime = 'Morning';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Mood:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              _buildMoodSelector(),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedTime,
                items: ['Morning', 'Afternoon', 'Evening']
                    .map((time) => DropdownMenuItem(value: time, child: Text(time)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTime = val!),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _onSave,
                      child: const Text('Save Mood'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CalendarScreen()),
                        );
                      },
                      child: const Text('View Calendar'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final moods = context.read<HomeCubit>().state;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyPieChart(moodEntries: moods),
                          ),
                        );
                      },
                      child: const Text('Stats'),
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

  Widget _buildMoodSelector() {
    final moods = {
      'Happy': Colors.yellow,
      'Sad': Colors.blue,
      'Angry': Colors.red,
      'Calm': Colors.green,
      'Anxious': Colors.purple,
    };

    return Wrap(
      spacing: 10,
      children: moods.entries.map((entry) {
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = entry.key),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: entry.value,
              borderRadius: BorderRadius.circular(12),
              border: _selectedMood == entry.key
                  ? Border.all(width: 3, color: Colors.black)
                  : null,
            ),
            child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mini_app/calendar.dart';
import 'package:mini_app/moodentry.dart';

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

  final List<MoodEntry> _moods = [];

  final Map<String, Color> moods = {
    'Happy': Colors.yellow,
    'Sad': Colors.blue,
    'Angry': Colors.red,
    'Calm': Colors.green,
    'Anxious': Colors.purple,
  };

  void _onSave() {
    if (_selectedMood == null ||
        _reasonController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a mood')),
      );
      return;
    }

    final moodEntry = MoodEntry(
      mood: _selectedMood!,
      reason: _reasonController.text,
      description: _descriptionController.text,
      timeOfDay: _selectedTime,
      date: DateTime.now(),
    );

    setState(() {
      _moods.add(moodEntry);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarScreen(moodEntries: _moods),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Mood:', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 10,
                children: moods.entries.map((entry) {
                  bool isSelected = _selectedMood == entry.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: entry.value,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(width: 3, color: Colors.black)
                            : null,
                      ),
                      child: Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: _selectedTime,
                items: ['Morning', 'Afternoon', 'Evening']
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTime = val!),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: Text('Save Mood & View Calendar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

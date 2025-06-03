import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mini_app/moodentry.dart';

// Map moods to specific colors
const Map<String, Color> moodColorMap = {
  'Angry': Colors.red,
  'Happy': Colors.green,
  'Neutral': Colors.yellow,
  'Sad': Colors.blue,
  'Anxious': Colors.purple,
};

class MyPieChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  const MyPieChart({super.key, required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    // Count how many times each mood appears
    final Map<String, int> moodCounts = {};
    for (var entry in moodEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Build pie chart sections
    final sections = moodCounts.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value.toDouble(),
        color: moodColorMap[entry.key] ?? Colors.grey,
        showTitle: false,
        radius: 42,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Mood Overview')),
      body: Center(
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 85,
            sections: sections,
          ),
        ),
      ),
    );
  }
}

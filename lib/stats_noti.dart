import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/moodentry.dart';
import 'package:mini_app/notifications_cubit.dart';

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
    final sections =
        moodCounts.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value.toDouble(),
            color: moodColorMap[entry.key] ?? Colors.grey,
            showTitle: false,
            radius: 42,
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Mood Overview')),
      body: BlocBuilder<NotificationsCubit, List<String>>(
        builder: (context, state) {
          return Column(
            children: [
              Center(
                child: SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(centerSpaceRadius: 85, sections: sections),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(state[index]), onTap: () {});
                  },
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<NotificationsCubit>().deleteMoods(state);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('All notifications cleared')),
                    );
                  },
                  child: Text('Clear Notifications'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class MoodEntry {
  final String mood;
  final DateTime date;
  final String reason;
  final String description;
  final String timeOfDay;

  MoodEntry({
    required this.mood,
    required this.date,
    required this.reason,
    required this.description,
    required this.timeOfDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'date': date.toIso8601String(),
      'reason': reason,
      'description': description,
      'timeOfDay': timeOfDay,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      mood: map['mood'],
      date: DateTime.parse(map['date']),
      reason: map['reason'],
      description: map['description'],
      timeOfDay: map['timeOfDay'],
    );
  }
}

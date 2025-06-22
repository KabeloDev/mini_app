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

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'date': date.toIso8601String(),
      'reason': reason,
      'description': description,
      'timeOfDay': timeOfDay,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      mood: json['mood'],
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      description: json['description'],
      timeOfDay: json['timeOfDay'],
    );
  }
}

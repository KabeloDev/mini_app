// calendar_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app/moodentry.dart';

class CalendarCubit extends Cubit<MoodEntry> {
  CalendarCubit()
      : super(MoodEntry(
          reason: '',
          description: '',
          mood: '',
          date: DateTime.now(),
          timeOfDay: '0',
        ));

  void updateMoodEntry(MoodEntry entry) {
    emit(entry);
  }
}

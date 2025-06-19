import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'moodentry.dart';

class CalendarCubit extends HydratedCubit<List<MoodEntry>> {
  CalendarCubit() : super([]);

  /// Sync moods from HomeCubit - call this when navigating to calendar.
  void setMoods(List<MoodEntry> homeMoods) {
    emit(homeMoods);
  }

  void updateMood(MoodEntry updatedMood) {
    final updatedList = state.map((mood) {
      if (mood.date == updatedMood.date && mood.timeOfDay == updatedMood.timeOfDay) {
        return updatedMood;
      }
      return mood;
    }).toList();
    emit(updatedList);
  }

  @override
  List<MoodEntry> fromJson(Map<String, dynamic> json) {
    final rawList = json['moods'] as List<dynamic>;
    return rawList.map((item) => MoodEntry.fromMap(item)).toList();
  }

  @override
  Map<String, dynamic> toJson(List<MoodEntry> state) {
    return {'moods': state.map((m) => m.toMap()).toList()};
  }
}

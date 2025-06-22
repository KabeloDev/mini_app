import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'moodentry.dart';

class CalendarCubit extends Cubit<List<MoodEntry>> {
  static const _calendarStorageKey = 'calendar_moods';

  CalendarCubit() : super([]) {
    _loadMoods();
  }

  Future<void> setMoods(List<MoodEntry> homeMoods) async {
    emit(homeMoods);
    await _saveMoods(homeMoods);
  }

  Future<void> updateMood(MoodEntry updatedMood) async {
    final updatedList = state.map((mood) {
      if (mood.date == updatedMood.date && mood.timeOfDay == updatedMood.timeOfDay) {
        return updatedMood;
      }
      return mood;
    }).toList();
    emit(updatedList);
    await _saveMoods(updatedList);
  }

  Future<void> _saveMoods(List<MoodEntry> moods) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = moods.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_calendarStorageKey, jsonList);
  }

  Future<void> _loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_calendarStorageKey);
    if (jsonList != null) {
      final moodList = jsonList
          .map((jsonStr) => MoodEntry.fromJson(jsonDecode(jsonStr)))
          .toList();
      emit(moodList);
    }
  }
}

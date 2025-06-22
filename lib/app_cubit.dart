import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'moodentry.dart';

class AppCubit extends Cubit<List<MoodEntry>> {
  static const _storageKey = 'mood_entries';

  AppCubit() : super([]) {
    _loadMoods();
  }

  Future<void> addMood(MoodEntry newMood) async {
    final updatedList = List<MoodEntry>.from(state);
    updatedList.add(newMood);
    emit(updatedList);
    await _saveMoods(updatedList);
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
    final jsonList = moods.map((mood) => jsonEncode(mood.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> _loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey);
    if (jsonList != null) {
      final moodList = jsonList
          .map((moodStr) => MoodEntry.fromJson(jsonDecode(moodStr)))
          .toList();
      emit(moodList);
    }
  }
}

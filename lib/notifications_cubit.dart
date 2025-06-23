import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsCubit extends Cubit<List<String>> {
  static const _storageKey = 'notification_entries';

  NotificationsCubit() : super([]) {
    _loadNotifications();
  }

  Future<void> addNotification(String newNotification) async {
    final updatedList = List<String>.from(state);
    updatedList.add(newNotification);
    emit(updatedList);
    await _saveNotifications(updatedList);
  }

  Future<void> deleteMoods(List<String> moods) async {
    moods.clear();
    emit(moods);
    await _saveNotifications(moods);
    _loadNotifications();
  }

  Future<void> _saveNotifications(List<String> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notifications.map((notification) => jsonEncode(notification)).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey);
    if (jsonList != null) {
      emit(jsonList
          .map((notificationStr) => jsonDecode(notificationStr) as String)
          .toList());
    }
  }
}

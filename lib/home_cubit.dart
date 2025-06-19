import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'moodentry.dart';

class HomeCubit extends HydratedCubit<List<MoodEntry>> {
  HomeCubit() : super([]);

  void addMood(MoodEntry newMood) {
    final updatedList = List<MoodEntry>.from(state);
    updatedList.add(newMood);
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

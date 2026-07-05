import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class IsarService {
  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  static Future<List<T>> _getAll<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList.map((s) => fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  static Future<void> _put<T>(String key, T item, Map<String, dynamic> Function(T) toJson, String Function(T) getId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key) ?? [];
    final items = jsonList.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
    final id = getId(item);
    final index = items.indexWhere((i) => i['id'] == id);
    if (index >= 0) { items[index] = toJson(item); } else { items.add(toJson(item)); }
    await prefs.setStringList(key, items.map((i) => jsonEncode(i)).toList());
  }

  static Future<List<Habit>> getHabits() => _getAll('habits', Habit.fromJson);
  static Future<void> putHabit(Habit h) => _put('habits', h, (h) => h.toJson(), (h) => h.id);
  static Future<List<HabitLog>> getHabitLogs() => _getAll('habitLogs', HabitLog.fromJson);
  static Future<void> putHabitLog(HabitLog h) => _put('habitLogs', h, (h) => h.toJson(), (h) => h.id);
  static Future<List<Task>> getTasks() => _getAll('tasks', Task.fromJson);
  static Future<void> putTask(Task t) => _put('tasks', t, (t) => t.toJson(), (t) => t.id);
  static Future<List<MoodLog>> getMoodLogs() => _getAll('moodLogs', MoodLog.fromJson);
  static Future<void> putMoodLog(MoodLog m) => _put('moodLogs', m, (m) => m.toJson(), (m) => m.id);
  static Future<List<WaterLog>> getWaterLogs() => _getAll('waterLogs', WaterLog.fromJson);
  static Future<void> putWaterLog(WaterLog w) => _put('waterLogs', w, (w) => w.toJson(), (w) => w.id);
  static Future<List<Goal>> getGoals() => _getAll('goals', Goal.fromJson);
  static Future<void> putGoal(Goal g) => _put('goals', g, (g) => g.toJson(), (g) => g.id);
  static Future<List<JournalEntry>> getJournalEntries() => _getAll('journalEntries', JournalEntry.fromJson);
  static Future<void> putJournalEntry(JournalEntry j) => _put('journalEntries', j, (j) => j.toJson(), (j) => j.id);
  static Future<List<CalendarEvent>> getCalendarEvents() => _getAll('calendarEvents', CalendarEvent.fromJson);
  static Future<void> putCalendarEvent(CalendarEvent e) => _put('calendarEvents', e, (e) => e.toJson(), (e) => e.id);
  static Future<List<Achievement>> getAchievements() => _getAll('achievements', Achievement.fromJson);
  static Future<void> putAchievement(Achievement a) => _put('achievements', a, (a) => a.toJson(), (a) => a.id);
  static Future<UserProfile?> getUserProfile() async {
    final items = await _getAll('userProfile', UserProfile.fromJson);
    return items.isEmpty ? null : items.first;
  }
  static Future<void> putUserProfile(UserProfile p) => _put('userProfile', p, (p) => p.toJson(), (p) => p.id);
  static Future<T> write<T>(Future<T> Function(dynamic db) action) async => await action(null);
}

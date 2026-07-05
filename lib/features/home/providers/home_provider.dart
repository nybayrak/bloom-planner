import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';

final tasksProvider = FutureProvider<List<Task>>((ref) => IsarService.getTasks());
final moodLogsProvider = FutureProvider<List<MoodLog>>((ref) => IsarService.getMoodLogs());
final waterLogsProvider = FutureProvider<List<WaterLog>>((ref) => IsarService.getWaterLogs());
final habitLogsProvider = FutureProvider<List<HabitLog>>((ref) => IsarService.getHabitLogs());
final habitsProvider = FutureProvider<List<Habit>>((ref) => IsarService.getHabits());

class HomeNotifier extends StateNotifier<AsyncValue<void>> {
  HomeNotifier() : super(const AsyncValue.data(null));

  Future<void> addTask(String title, {String? description, TaskPriority priority = TaskPriority.medium, DateTime? dueDate}) async {
    final task = Task(id: const Uuid().v4(), title: title, description: description, priority: priority, dueDate: dueDate);
    await IsarService.putTask(task);
  }

  Future<void> logMood(MoodLevel mood, {String? note}) async {
    final log = MoodLog(id: const Uuid().v4(), mood: mood, note: note, date: DateTime.now());
    await IsarService.putMoodLog(log);
  }

  Future<void> logWater(int amountMl) async {
    final log = WaterLog(id: const Uuid().v4(), amountMl: amountMl, date: DateTime.now());
    await IsarService.putWaterLog(log);
  }

  Future<void> logHabit(String habitId, {String? note}) async {
    final log = HabitLog(id: const Uuid().v4(), habitId: habitId, date: DateTime.now(), note: note);
    await IsarService.putHabitLog(log);
  }

  Future<void> addHabit(String name, {String? emoji, HabitCategory category = HabitCategory.other}) async {
    final habit = Habit(id: const Uuid().v4(), name: name, emoji: emoji, category: category);
    await IsarService.putHabit(habit);
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, AsyncValue<void>>((ref) => HomeNotifier());

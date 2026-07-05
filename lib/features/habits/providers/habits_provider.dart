import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';

final allHabitsProvider = FutureProvider<List<Habit>>((ref) => IsarService.getHabits());
final allHabitLogsProvider = FutureProvider<List<HabitLog>>((ref) => IsarService.getHabitLogs());

class HabitsNotifier extends StateNotifier<AsyncValue<void>> {
  HabitsNotifier() : super(const AsyncValue.data(null));

  Future<void> logHabit(String habitId, {String? note}) async {
    final log = HabitLog(
      id: const Uuid().v4(),
      habitId: habitId,
      date: DateTime.now(),
      note: note,
    );
    await IsarService.putHabitLog(log);
  }

  Future<void> logWater(int amountMl) async {
    final log = WaterLog(
      id: const Uuid().v4(),
      amountMl: amountMl,
      date: DateTime.now(),
    );
    await IsarService.putWaterLog(log);
  }

  Future<void> addHabit(String name, {String? emoji,
      HabitCategory category = HabitCategory.other}) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      category: category,
    );
    await IsarService.putHabit(habit);
  }
}

final habitsNotifierProvider =
    StateNotifierProvider<HabitsNotifier, AsyncValue<void>>(
        (ref) => HabitsNotifier());

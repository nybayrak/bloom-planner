// lib/features/habits/providers/habits_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';
import '../../../core/services/auth_service.dart';
import '../../../features/home/providers/home_provider.dart';

// ── Habits state ──────────────────────────────────────────────

class HabitsState {
  const HabitsState({
    this.habits = const [],
    this.doneToday = const {},
    this.waterCups = 0,
    this.isLoading = false,
    this.bestStreak = 0,
    this.weeklyPct = 0,
  });

  final List<Habit> habits;
  final Set<String> doneToday;
  final int waterCups;
  final bool isLoading;
  final int bestStreak;
  final int weeklyPct;

  HabitsState copyWith({
    List<Habit>? habits,
    Set<String>? doneToday,
    int? waterCups,
    bool? isLoading,
    int? bestStreak,
    int? weeklyPct,
  }) => HabitsState(
    habits: habits ?? this.habits,
    doneToday: doneToday ?? this.doneToday,
    waterCups: waterCups ?? this.waterCups,
    isLoading: isLoading ?? this.isLoading,
    bestStreak: bestStreak ?? this.bestStreak,
    weeklyPct: weeklyPct ?? this.weeklyPct,
  );
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, HabitsState>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid ?? '';
  return HabitsNotifier(uid: uid);
});

class HabitsNotifier extends StateNotifier<HabitsState> {
  HabitsNotifier({required this.uid}) : super(const HabitsState(isLoading: true)) {
    load();
  }

  final String uid;

  Future<void> load() async {
    if (uid.isEmpty) return;
    state = state.copyWith(isLoading: true);

    final db = IsarService.db;
    final today = _today();
    final tomorrow = today.add(const Duration(days: 1));

    final habits = await db.habits
        .where()
        .uidEqualTo(uid)
        .filter()
        .isArchivedEqualTo(false)
        .sortBySortOrder()
        .findAll();

    final logs = await db.habitLogs
        .where()
        .filter()
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(tomorrow)
        .findAll();

    final doneIds = logs.where((l) => l.completed).map((l) => l.habitId).toSet();

    final waterLog = await db.waterLogs
        .where()
        .uidEqualTo(uid)
        .filter()
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(tomorrow)
        .findFirst();

    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);

    state = state.copyWith(
      habits: habits,
      doneToday: doneIds,
      waterCups: waterLog?.cups ?? 0,
      isLoading: false,
      bestStreak: bestStreak,
      weeklyPct: habits.isEmpty ? 0 : ((doneIds.length / habits.length) * 100).round(),
    );
  }

  Future<void> toggleToday(String habitId) async {
    final today = _today();
    final existing = await IsarService.db.habitLogs
        .where()
        .filter()
        .habitIdEqualTo(habitId)
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(today.add(const Duration(days: 1)))
        .findFirst();

    await IsarService.write((db) async {
      final log = existing ?? (HabitLog()
        ..habitId = habitId
        ..date = today
        ..createdAt = DateTime.now());
      log.completed = !(existing?.completed ?? false);
      await db.habitLogs.put(log);
    });

    await load();
  }

  Future<void> setWater(int cups) async {
    final today = _today();
    final existing = await IsarService.db.waterLogs
        .where()
        .uidEqualTo(uid)
        .filter()
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(today.add(const Duration(days: 1)))
        .findFirst();

    await IsarService.write((db) async {
      final log = existing ?? (WaterLog()
        ..uid = uid
        ..date = today
        ..targetCups = 8);
      log.cups = cups.clamp(0, log.targetCups);
      log.updatedAt = DateTime.now();
      await db.waterLogs.put(log);
    });

    state = state.copyWith(waterCups: cups.clamp(0, 8));
  }

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }
}

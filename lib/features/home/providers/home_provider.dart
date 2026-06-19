// lib/features/home/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';
import '../../../core/services/auth_service.dart';
import '../models/home_state.dart';

// ─────────────────────────────────────────────────────────────
// HOME STATE NOTIFIER
// ─────────────────────────────────────────────────────────────

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid ?? '';
  return HomeNotifier(uid: uid, ref: ref);
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier({required this.uid, required this.ref})
      : super(HomeState.loading()) {
    load();
  }

  final String uid;
  final Ref ref;

  Future<void> load() async {
    if (uid.isEmpty) return;
    try {
      state = HomeState.loading();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final db = IsarService.db;

      // ── Today's tasks ─────────────────────────────────────
      final tasks = await db.tasks
          .where()
          .uidEqualTo(uid)
          .filter()
          .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
          .dateLessThan(tomorrow)
          .sortByPriorityDesc()
          .findAll();

      // ── Habits + today's logs ─────────────────────────────
      final habits = await db.habits
          .where()
          .uidEqualTo(uid)
          .filter()
          .isArchivedEqualTo(false)
          .sortBySortOrder()
          .findAll();

      final habitLogs = await db.habitLogs
          .where()
          .filter()
          .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
          .dateLessThan(tomorrow)
          .findAll();

      final doneHabitIds = habitLogs
          .where((l) => l.completed)
          .map((l) => l.habitId)
          .toSet();

      // ── Water log ─────────────────────────────────────────
      final waterLog = await db.waterLogs
          .where()
          .uidEqualTo(uid)
          .filter()
          .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
          .dateLessThan(tomorrow)
          .findFirst();

      // ── Upcoming events (next 7 days) ─────────────────────
      final weekAhead = today.add(const Duration(days: 7));
      final events = await db.calendarEvents
          .where()
          .uidEqualTo(uid)
          .filter()
          .startAtGreaterThan(now)
          .startAtLessThan(weekAhead)
          .sortByStartAt()
          .limit(5)
          .findAll();

      // ── Today's mood ─────────────────────────────────────
      final moodLog = await db.moodLogs
          .where()
          .uidEqualTo(uid)
          .filter()
          .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
          .dateLessThan(tomorrow)
          .findFirst();

      // ── Today's journal ───────────────────────────────────
      final journal = await db.journalEntrys
          .where()
          .uidEqualTo(uid)
          .filter()
          .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
          .dateLessThan(tomorrow)
          .findFirst();

      state = HomeState(
        isLoading: false,
        tasks: tasks,
        habits: habits,
        doneHabitIds: doneHabitIds,
        waterCups: waterLog?.cups ?? 0,
        waterTarget: waterLog?.targetCups ?? 8,
        upcomingEvents: events,
        todayMood: moodLog?.score,
        hasJournalEntry: journal != null,
        date: today,
      );
    } catch (e, st) {
      state = HomeState.error(e.toString());
    }
  }

  Future<void> refresh() => load();

  // ── Toggle task ───────────────────────────────────────────

  Future<void> toggleTask(String taskId) async {
    final task = await IsarService.db.tasks
        .where()
        .filter()
        .taskIdEqualTo(taskId)
        .findFirst();
    if (task == null) return;

    await IsarService.write((db) async {
      task.isDone = !task.isDone;
      task.completedAt = task.isDone ? DateTime.now() : null;
      task.updatedAt = DateTime.now();
      await db.tasks.put(task);
    });
    await load();
  }

  // ── Log mood ─────────────────────────────────────────────

  Future<void> logMood(int score) async {
    final today = _today();

    final existing = await IsarService.db.moodLogs
        .where()
        .uidEqualTo(uid)
        .filter()
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(today.add(const Duration(days: 1)))
        .findFirst();

    await IsarService.write((db) async {
      final log = existing ?? (MoodLog()
        ..uid = uid
        ..date = today
        ..createdAt = DateTime.now());
      log.score = score;
      await db.moodLogs.put(log);
    });

    state = state.copyWith(todayMood: score);
  }

  // ── Log water ────────────────────────────────────────────

  Future<void> setWaterCups(int cups) async {
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

    state = state.copyWith(waterCups: cups.clamp(0, state.waterTarget));
  }

  // ── Toggle habit ─────────────────────────────────────────

  Future<void> toggleHabit(String habitId) async {
    final today = _today();
    final existing = await IsarService.db.habitLogs
        .where()
        .filter()
        .habitIdEqualTo(habitId)
        .dateGreaterThan(today.subtract(const Duration(seconds: 1)))
        .dateLessThan(today.add(const Duration(days: 1)))
        .findFirst();

    final wasCompleted = existing?.completed ?? false;

    await IsarService.write((db) async {
      final log = existing ?? (HabitLog()
        ..habitId = habitId
        ..date = today
        ..createdAt = DateTime.now());
      log.completed = !wasCompleted;
      await db.habitLogs.put(log);
    });

    // Refresh streak
    await _recalculateStreak(habitId);
    await load();
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _recalculateStreak(String habitId) async {
    final habit = await IsarService.db.habits
        .where()
        .filter()
        .habitIdEqualTo(habitId)
        .findFirst();
    if (habit == null) return;

    // Walk backwards from today counting consecutive completed days
    int streak = 0;
    var date = _today();
    while (true) {
      final log = await IsarService.db.habitLogs
          .where()
          .filter()
          .habitIdEqualTo(habitId)
          .dateGreaterThan(date.subtract(const Duration(seconds: 1)))
          .dateLessThan(date.add(const Duration(days: 1)))
          .findFirst();
      if (log?.completed == true) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    await IsarService.write((db) async {
      habit.currentStreak = streak;
      if (streak > habit.longestStreak) habit.longestStreak = streak;
      habit.updatedAt = DateTime.now();
      await db.habits.put(habit);
    });
  }
}

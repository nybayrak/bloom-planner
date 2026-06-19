// lib/core/db/isar_service.dart
import 'package:isar/isar.dart';
import 'models.dart';

class IsarService {
  IsarService._();

  static late final Isar _db;
  static bool _initialized = false;

  /// Call once in main() before runApp.
  static Future<void> init(String directory) async {
    if (_initialized) return;
    _db = await Isar.open(
      [
        UserProfileSchema,
        TaskSchema,
        HabitSchema,
        HabitLogSchema,
        GoalSchema,
        CalendarEventSchema,
        MoodLogSchema,
        JournalEntrySchema,
        VisionBoardItemSchema,
        AchievementSchema,
        WaterLogSchema,
        FamilyMemberSchema,
        BudgetTransactionSchema,
      ],
      directory: directory,
      name: 'bloom_planner',
      inspector: false, // set true during dev to use Isar Inspector
    );
    _initialized = true;
  }

  static Isar get db {
    assert(_initialized, 'IsarService.init() must be called before accessing db');
    return _db;
  }

  // ── Convenience write wrapper ──────────────────────────────
  static Future<T> write<T>(Future<T> Function(Isar isar) action) {
    return _db.writeTxn(() => action(_db));
  }

  // ── Close (useful in tests) ────────────────────────────────
  static Future<void> close() async {
    if (_initialized) {
      await _db.close();
      _initialized = false;
    }
  }

  // ── Clear all (for sign-out) ───────────────────────────────
  static Future<void> clearAll() async {
    await _db.writeTxn(() => _db.clear());
  }
}

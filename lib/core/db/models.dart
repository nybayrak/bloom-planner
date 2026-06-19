// lib/core/db/models.dart
//
// All Isar collection models for Bloom Planner.
// Run:  flutter pub run build_runner build --delete-conflicting-outputs
// to generate the *.g.dart files.
//
// ignore_for_file: non_constant_identifier_names

import 'package:isar/isar.dart';

part 'models.g.dart';

// ─────────────────────────────────────────────────────────────
// USER PROFILE
// ─────────────────────────────────────────────────────────────

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // Firebase UID

  late String displayName;
  String? avatarUrl;
  String? localAvatarPath;
  late String email;

  // Preferences
  @Enumerated(EnumType.name)
  late ThemePreference themePreference;

  @Enumerated(EnumType.name)
  late SeasonPreference seasonPreference;

  bool adhdMode = false;
  bool familyMode = false;
  bool onboardingComplete = false;

  // Subscription
  @Enumerated(EnumType.name)
  late SubscriptionTier subscriptionTier;

  DateTime? subscriptionExpiresAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

enum ThemePreference { system, light, dark }
enum SeasonPreference { auto, spring, summer, autumn, winter }
enum SubscriptionTier { free, pro, family, school }

// ─────────────────────────────────────────────────────────────
// TASK
// ─────────────────────────────────────────────────────────────

@collection
class Task {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid; // owner

  @Index()
  late String taskId; // UUID

  late String title;
  String? notes;

  @Index()
  late DateTime date; // the day this belongs to

  bool isDone = false;
  DateTime? completedAt;

  @Enumerated(EnumType.name)
  late TaskPriority priority;

  @Enumerated(EnumType.name)
  late TaskCategory category;

  String? color; // hex override

  // Recurrence
  bool isRecurring = false;

  @Enumerated(EnumType.name)
  RecurrenceRule? recurrenceRule;

  String? recurrenceParentId; // UUID of the root task
  int? recurrencePosition;    // 0-based index in the series

  // Auto-roll
  bool autoRoll = true; // unfinished tasks roll forward
  DateTime? rolledFromDate;

  // ADHD helpers
  int estimatedMinutes = 25; // Pomodoro default
  bool hasFocus = false;     // pinned for today

  late DateTime createdAt;
  late DateTime updatedAt;
}

enum TaskPriority { low, medium, high, urgent }
enum TaskCategory { personal, work, health, family, learning, finance, social, other }
enum RecurrenceRule { daily, weekdays, weekly, biweekly, monthly, yearly }

// ─────────────────────────────────────────────────────────────
// HABIT
// ─────────────────────────────────────────────────────────────

@collection
class Habit {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index(unique: true)
  late String habitId; // UUID

  late String label;
  late String icon; // emoji
  late String color; // hex

  @Enumerated(EnumType.name)
  late HabitFrequency frequency;

  // For weekly habits: which days (1=Mon … 7=Sun)
  List<int> weekDays = const [1, 2, 3, 4, 5, 6, 7];

  // Goal — e.g. quantity + unit
  double? targetValue;
  String? targetUnit; // cups, pages, minutes …

  // Streak (cached for performance)
  int currentStreak = 0;
  int longestStreak = 0;

  // Display order
  int sortOrder = 0;

  bool isArchived = false;

  late DateTime createdAt;
  late DateTime updatedAt;
}

enum HabitFrequency { daily, weekly, monthly }

// ─────────────────────────────────────────────────────────────
// HABIT LOG  (one row per habit per day)
// ─────────────────────────────────────────────────────────────

@collection
class HabitLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String habitId;

  @Index()
  late DateTime date; // midnight UTC of the logged day

  bool completed = false;
  double? value; // for quantitative habits (e.g. 7 cups)
  String? note;

  late DateTime createdAt;
}

// ─────────────────────────────────────────────────────────────
// GOAL
// ─────────────────────────────────────────────────────────────

@collection
class Goal {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index(unique: true)
  late String goalId;

  late String title;
  String? description;
  String? icon; // emoji

  @Enumerated(EnumType.name)
  late GoalType type;

  @Enumerated(EnumType.name)
  late GoalCategory category;

  // Progress
  double? targetValue;
  double currentValue = 0;
  String? unit; // '$', 'books', 'kg' …

  // Dates
  DateTime? startDate;
  DateTime? deadline;

  bool isCompleted = false;
  DateTime? completedAt;

  // Hierarchy
  String? parentGoalId; // for quarterly → annual roll-up
  int? year;
  int? quarter;
  int? month;

  late DateTime createdAt;
  late DateTime updatedAt;
}

enum GoalType { annual, quarterly, monthly, weekly, oneTime }
enum GoalCategory { health, finance, learning, career, relationship, personal, family, travel }

// ─────────────────────────────────────────────────────────────
// CALENDAR EVENT
// ─────────────────────────────────────────────────────────────

@collection
class CalendarEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index(unique: true)
  late String eventId;

  late String title;
  String? description;
  String? location;

  @Index()
  late DateTime startAt;
  late DateTime endAt;

  bool isAllDay = false;

  @Enumerated(EnumType.name)
  late EventCategory category;

  String? color; // hex override
  String? icon;  // emoji

  // Recurrence
  bool isRecurring = false;

  @Enumerated(EnumType.name)
  RecurrenceRule? recurrenceRule;

  String? recurrenceParentId;

  // Family
  List<String> participantUids = const [];

  // Reminders (minutes before)
  List<int> remindAtMinutes = const [15];

  late DateTime createdAt;
  late DateTime updatedAt;
}

enum EventCategory { personal, work, health, family, social, finance, learning, other }

// ─────────────────────────────────────────────────────────────
// MOOD LOG
// ─────────────────────────────────────────────────────────────

@collection
class MoodLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index()
  late DateTime date; // midnight UTC

  /// 1 = Very low … 5 = Very high
  late int score;

  String? note;
  List<String> tags = const []; // e.g. ['anxious', 'energetic']

  late DateTime createdAt;
}

// ─────────────────────────────────────────────────────────────
// JOURNAL ENTRY
// ─────────────────────────────────────────────────────────────

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index(unique: true)
  late DateTime date; // one per day (midnight UTC)

  String body = '';
  String? gratitude;  // "Three things I'm grateful for"
  String? intention;  // "My intention for today"
  String? reflection; // "End of day reflection"

  // Decoration
  List<String> stickers = const []; // emoji codes
  String? washiTapeColor; // hex
  String? theme; // e.g. 'spring', 'birthday'

  // Prompt used
  String? promptUsed;

  late DateTime createdAt;
  late DateTime updatedAt;
}

// ─────────────────────────────────────────────────────────────
// VISION BOARD ITEM
// ─────────────────────────────────────────────────────────────

@collection
class VisionBoardItem {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late String itemId;
  late String label;
  String? emoji;
  String? imagePath; // local path for offline; synced to Storage
  String? imageUrl;  // remote URL

  String color = '#FCE7F3';
  int sortOrder = 0;

  late DateTime createdAt;
}

// ─────────────────────────────────────────────────────────────
// ACHIEVEMENT / BADGE
// ─────────────────────────────────────────────────────────────

@collection
class Achievement {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index(unique: true)
  late String achievementId; // e.g. 'streak_7', 'goal_first'

  late String title;
  late String description;
  late String badge; // emoji

  bool isEarned = false;
  DateTime? earnedAt;

  late DateTime createdAt;
}

// ─────────────────────────────────────────────────────────────
// WATER LOG  (separate for quick access)
// ─────────────────────────────────────────────────────────────

@collection
class WaterLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  @Index()
  late DateTime date;

  int cups = 0;
  int targetCups = 8;

  late DateTime updatedAt;
}

// ─────────────────────────────────────────────────────────────
// FAMILY MEMBER
// ─────────────────────────────────────────────────────────────

@collection
class FamilyMember {
  Id id = Isar.autoIncrement;

  @Index()
  late String ownerUid;

  late String memberId;
  late String name;
  String? avatarEmoji;
  String? avatarUrl;
  String? email;
  String color = '#FED7AA';

  @Enumerated(EnumType.name)
  late FamilyRole role;

  bool hasAppAccess = false;
  String? linkedUid; // if they also have an account

  late DateTime createdAt;
}

enum FamilyRole { parent, child, partner, other }

// ─────────────────────────────────────────────────────────────
// BUDGET TRANSACTION
// ─────────────────────────────────────────────────────────────

@collection
class BudgetTransaction {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late String transactionId;
  late String title;

  @Index()
  late DateTime date;

  late double amount; // positive = income, negative = expense

  @Enumerated(EnumType.name)
  late BudgetCategory category;

  @Enumerated(EnumType.name)
  late TransactionType type;

  String? notes;
  bool isRecurring = false;

  late DateTime createdAt;
}

enum BudgetCategory { housing, food, transport, health, entertainment, savings, income, other }
enum TransactionType { income, expense, transfer, saving }

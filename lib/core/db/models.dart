enum HabitFrequency { daily, weekly, monthly }
enum HabitCategory { health, fitness, mindfulness, learning, productivity, social, creative, other }
enum TaskPriority { low, medium, high, critical }
enum TaskStatus { pending, inProgress, completed, cancelled }
enum GoalStatus { notStarted, inProgress, completed, abandoned }
enum MoodLevel { veryBad, bad, neutral, good, veryGood }
enum JournalMood { happy, sad, anxious, calm, excited, grateful, angry, neutral }

class UserProfile {
  String id; String? uid; String? name; String? email; String? avatarUrl; DateTime createdAt;
  UserProfile({required this.id, this.uid, this.name, this.email, this.avatarUrl, DateTime? createdAt}) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'uid': uid, 'name': name, 'email': email, 'avatarUrl': avatarUrl, 'createdAt': createdAt.toIso8601String()};
  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(id: j['id'] ?? '', uid: j['uid'], name: j['name'], email: j['email'], avatarUrl: j['avatarUrl'], createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now());
}

class Habit {
  String id; String name; String? description; String? emoji; String? colorHex;
  HabitFrequency frequency; HabitCategory category; int targetCount; bool isActive; DateTime createdAt; String? userId;
  Habit({required this.id, required this.name, this.description, this.emoji, this.colorHex, this.frequency = HabitFrequency.daily, this.category = HabitCategory.other, this.targetCount = 1, this.isActive = true, DateTime? createdAt, this.userId}) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description, 'emoji': emoji, 'colorHex': colorHex, 'frequency': frequency.name, 'category': category.name, 'targetCount': targetCount, 'isActive': isActive, 'createdAt': createdAt.toIso8601String(), 'userId': userId};
  factory Habit.fromJson(Map<String, dynamic> j) => Habit(id: j['id'] ?? '', name: j['name'] ?? '', description: j['description'], emoji: j['emoji'], colorHex: j['colorHex'], frequency: HabitFrequency.values.firstWhere((e) => e.name == j['frequency'], orElse: () => HabitFrequency.daily), category: HabitCategory.values.firstWhere((e) => e.name == j['category'], orElse: () => HabitCategory.other), targetCount: j['targetCount'] ?? 1, isActive: j['isActive'] ?? true, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(), userId: j['userId']);
}

class HabitLog {
  String id; String habitId; DateTime date; int count; String? note;
  HabitLog({required this.id, required this.habitId, required this.date, this.count = 1, this.note});
  Map<String, dynamic> toJson() => {'id': id, 'habitId': habitId, 'date': date.toIso8601String(), 'count': count, 'note': note};
  factory HabitLog.fromJson(Map<String, dynamic> j) => HabitLog(id: j['id'] ?? '', habitId: j['habitId'] ?? '', date: j['date'] != null ? DateTime.parse(j['date']) : DateTime.now(), count: j['count'] ?? 1, note: j['note']);
}

class Task {
  String id; String title; String? description; TaskPriority priority; TaskStatus status; DateTime? dueDate; bool isCompleted; DateTime createdAt; String? userId;
  Task({required this.id, required this.title, this.description, this.priority = TaskPriority.medium, this.status = TaskStatus.pending, this.dueDate, this.isCompleted = false, DateTime? createdAt, this.userId}) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'priority': priority.name, 'status': status.name, 'dueDate': dueDate?.toIso8601String(), 'isCompleted': isCompleted, 'createdAt': createdAt.toIso8601String(), 'userId': userId};
  factory Task.fromJson(Map<String, dynamic> j) => Task(id: j['id'] ?? '', title: j['title'] ?? '', description: j['description'], priority: TaskPriority.values.firstWhere((e) => e.name == j['priority'], orElse: () => TaskPriority.medium), status: TaskStatus.values.firstWhere((e) => e.name == j['status'], orElse: () => TaskStatus.pending), dueDate: j['dueDate'] != null ? DateTime.parse(j['dueDate']) : null, isCompleted: j['isCompleted'] ?? false, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(), userId: j['userId']);
}

class MoodLog {
  String id; MoodLevel mood; String? note; DateTime date; String? userId;
  MoodLog({required this.id, required this.mood, this.note, required this.date, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'mood': mood.name, 'note': note, 'date': date.toIso8601String(), 'userId': userId};
  factory MoodLog.fromJson(Map<String, dynamic> j) => MoodLog(id: j['id'] ?? '', mood: MoodLevel.values.firstWhere((e) => e.name == j['mood'], orElse: () => MoodLevel.neutral), note: j['note'], date: j['date'] != null ? DateTime.parse(j['date']) : DateTime.now(), userId: j['userId']);
}

class WaterLog {
  String id; int amountMl; DateTime date; String? userId;
  WaterLog({required this.id, required this.amountMl, required this.date, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'amountMl': amountMl, 'date': date.toIso8601String(), 'userId': userId};
  factory WaterLog.fromJson(Map<String, dynamic> j) => WaterLog(id: j['id'] ?? '', amountMl: j['amountMl'] ?? 0, date: j['date'] != null ? DateTime.parse(j['date']) : DateTime.now(), userId: j['userId']);
}

class Goal {
  String id; String title; String? description; GoalStatus status; DateTime? targetDate; double progress; DateTime createdAt; String? userId;
  Goal({required this.id, required this.title, this.description, this.status = GoalStatus.notStarted, this.targetDate, this.progress = 0.0, DateTime? createdAt, this.userId}) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'status': status.name, 'targetDate': targetDate?.toIso8601String(), 'progress': progress, 'createdAt': createdAt.toIso8601String(), 'userId': userId};
  factory Goal.fromJson(Map<String, dynamic> j) => Goal(id: j['id'] ?? '', title: j['title'] ?? '', description: j['description'], status: GoalStatus.values.firstWhere((e) => e.name == j['status'], orElse: () => GoalStatus.notStarted), targetDate: j['targetDate'] != null ? DateTime.parse(j['targetDate']) : null, progress: (j['progress'] ?? 0.0).toDouble(), createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(), userId: j['userId']);
}

class JournalEntry {
  String id; String content; JournalMood mood; List<String> tags; DateTime date; String? userId;
  JournalEntry({required this.id, required this.content, this.mood = JournalMood.neutral, this.tags = const [], required this.date, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'content': content, 'mood': mood.name, 'tags': tags, 'date': date.toIso8601String(), 'userId': userId};
  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(id: j['id'] ?? '', content: j['content'] ?? '', mood: JournalMood.values.firstWhere((e) => e.name == j['mood'], orElse: () => JournalMood.neutral), tags: List<String>.from(j['tags'] ?? []), date: j['date'] != null ? DateTime.parse(j['date']) : DateTime.now(), userId: j['userId']);
}

class CalendarEvent {
  String id; String title; String? description; DateTime startDate; DateTime? endDate; bool isAllDay; String? colorHex; String? userId;
  CalendarEvent({required this.id, required this.title, this.description, required this.startDate, this.endDate, this.isAllDay = false, this.colorHex, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'startDate': startDate.toIso8601String(), 'endDate': endDate?.toIso8601String(), 'isAllDay': isAllDay, 'colorHex': colorHex, 'userId': userId};
  factory CalendarEvent.fromJson(Map<String, dynamic> j) => CalendarEvent(id: j['id'] ?? '', title: j['title'] ?? '', description: j['description'], startDate: j['startDate'] != null ? DateTime.parse(j['startDate']) : DateTime.now(), endDate: j['endDate'] != null ? DateTime.parse(j['endDate']) : null, isAllDay: j['isAllDay'] ?? false, colorHex: j['colorHex'], userId: j['userId']);
}

class FamilyMember {
  String id; String name; String? avatarUrl; String? relationship; String? userId;
  FamilyMember({required this.id, required this.name, this.avatarUrl, this.relationship, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'avatarUrl': avatarUrl, 'relationship': relationship, 'userId': userId};
  factory FamilyMember.fromJson(Map<String, dynamic> j) => FamilyMember(id: j['id'] ?? '', name: j['name'] ?? '', avatarUrl: j['avatarUrl'], relationship: j['relationship'], userId: j['userId']);
}

class BudgetTransaction {
  String id; String title; double amount; bool isIncome; String? category; DateTime date; String? userId;
  BudgetTransaction({required this.id, required this.title, required this.amount, this.isIncome = false, this.category, required this.date, this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'amount': amount, 'isIncome': isIncome, 'category': category, 'date': date.toIso8601String(), 'userId': userId};
  factory BudgetTransaction.fromJson(Map<String, dynamic> j) => BudgetTransaction(id: j['id'] ?? '', title: j['title'] ?? '', amount: (j['amount'] ?? 0.0).toDouble(), isIncome: j['isIncome'] ?? false, category: j['category'], date: j['date'] != null ? DateTime.parse(j['date']) : DateTime.now(), userId: j['userId']);
}

class VisionBoardItem {
  String id; String? imageUrl; String? title; String? note; String? emoji; DateTime createdAt; String? userId;
  VisionBoardItem({required this.id, this.imageUrl, this.title, this.note, this.emoji, DateTime? createdAt, this.userId}) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'imageUrl': imageUrl, 'title': title, 'note': note, 'emoji': emoji, 'createdAt': createdAt.toIso8601String(), 'userId': userId};
  factory VisionBoardItem.fromJson(Map<String, dynamic> j) => VisionBoardItem(id: j['id'] ?? '', imageUrl: j['imageUrl'], title: j['title'], note: j['note'], emoji: j['emoji'], createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(), userId: j['userId']);
}

class Achievement {
  String id; String title; String? description; String? emoji; DateTime unlockedAt; String? userId;
  Achievement({required this.id, required this.title, this.description, this.emoji, DateTime? unlockedAt, this.userId}) : unlockedAt = unlockedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'emoji': emoji, 'unlockedAt': unlockedAt.toIso8601String(), 'userId': userId};
  factory Achievement.fromJson(Map<String, dynamic> j) => Achievement(id: j['id'] ?? '', title: j['title'] ?? '', description: j['description'], emoji: j['emoji'], unlockedAt: j['unlockedAt'] != null ? DateTime.parse(j['unlockedAt']) : DateTime.now(), userId: j['userId']);
}

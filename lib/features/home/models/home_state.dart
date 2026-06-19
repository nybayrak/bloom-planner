// lib/features/home/models/home_state.dart
import '../../../core/db/models.dart';

class HomeState {
  const HomeState({
    required this.isLoading,
    this.error,
    this.tasks = const [],
    this.habits = const [],
    this.doneHabitIds = const {},
    this.waterCups = 0,
    this.waterTarget = 8,
    this.upcomingEvents = const [],
    this.todayMood,
    this.hasJournalEntry = false,
    required this.date,
  });

  final bool isLoading;
  final String? error;
  final List<Task> tasks;
  final List<Habit> habits;
  final Set<String> doneHabitIds;
  final int waterCups;
  final int waterTarget;
  final List<CalendarEvent> upcomingEvents;
  final int? todayMood;
  final bool hasJournalEntry;
  final DateTime date;

  factory HomeState.loading() => HomeState(
        isLoading: true,
        date: DateTime.now(),
      );

  factory HomeState.error(String message) => HomeState(
        isLoading: false,
        error: message,
        date: DateTime.now(),
      );

  bool get hasError => error != null;

  // ── Computed ─────────────────────────────────────────────

  int get tasksDone => tasks.where((t) => t.isDone).length;
  int get tasksTotal => tasks.length;
  double get taskProgress =>
      tasksTotal == 0 ? 0 : tasksDone / tasksTotal;

  int get habitsDone => doneHabitIds.length;
  int get habitsTotal => habits.length;
  double get habitProgress =>
      habitsTotal == 0 ? 0 : habitsDone / habitsTotal;

  double get waterProgress =>
      waterTarget == 0 ? 0 : waterCups / waterTarget;

  // Fake step progress (replace with HealthKit / Health Connect)
  double get stepProgress => 0.45;

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<Task>? tasks,
    List<Habit>? habits,
    Set<String>? doneHabitIds,
    int? waterCups,
    int? waterTarget,
    List<CalendarEvent>? upcomingEvents,
    int? todayMood,
    bool? hasJournalEntry,
    DateTime? date,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      tasks: tasks ?? this.tasks,
      habits: habits ?? this.habits,
      doneHabitIds: doneHabitIds ?? this.doneHabitIds,
      waterCups: waterCups ?? this.waterCups,
      waterTarget: waterTarget ?? this.waterTarget,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      todayMood: todayMood ?? this.todayMood,
      hasJournalEntry: hasJournalEntry ?? this.hasJournalEntry,
      date: date ?? this.date,
    );
  }
}

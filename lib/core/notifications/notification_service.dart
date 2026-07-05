class NotificationService {
  static Future<void> init() async {}
  static Future<void> scheduleHabitReminder({
    required int id,
    required String habitName,
    required int weekday,
    required int hour,
    required int minute,
  }) async {}
  static Future<void> scheduleTaskReminder({
    required int id,
    required String taskTitle,
    required DateTime reminderTime,
  }) async {}
  static Future<void> showStreakCelebration({
    required String habitName,
    required int streakCount,
  }) async {}
  static Future<void> cancelNotification(int id) async {}
  static Future<void> cancelAllNotifications() async {}
}

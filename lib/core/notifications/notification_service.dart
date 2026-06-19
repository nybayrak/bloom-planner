// lib/core/notifications/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // ── Notification channels (Android) ──────────────────────────

  static const _habitChannel = AndroidNotificationChannel(
    'bloom_habits',
    'Habit Reminders',
    description: 'Daily nudges to keep your streaks alive 🌸',
    importance: Importance.high,
  );

  static const _taskChannel = AndroidNotificationChannel(
    'bloom_tasks',
    'Task Reminders',
    description: 'Upcoming task alerts ✅',
    importance: Importance.defaultImportance,
  );

  static const _eventChannel = AndroidNotificationChannel(
    'bloom_events',
    'Event Reminders',
    description: 'Calendar event alerts 📅',
    importance: Importance.high,
  );

  static const _streakChannel = AndroidNotificationChannel(
    'bloom_streaks',
    'Streak Celebrations',
    description: 'Celebrate your wins! 🎉',
    importance: Importance.low,
  );

  // ── Init ─────────────────────────────────────────────────────

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onTap,
    );

    // Create Android channels
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_habitChannel);
    await androidPlugin?.createNotificationChannel(_taskChannel);
    await androidPlugin?.createNotificationChannel(_eventChannel);
    await androidPlugin?.createNotificationChannel(_streakChannel);

    _initialized = true;
  }

  // ── Permission request ────────────────────────────────────────

  static Future<bool> requestPermission() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final granted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return granted ?? true; // Android handles permissions via channel importance
  }

  // ── Schedule habit reminder ───────────────────────────────────
  //
  // [id] should be stable for a given habit so we can update/cancel it.
  // [hour] and [minute] are the user's chosen time.

  static Future<void> scheduleHabitReminder({
    required int id,
    required String habitLabel,
    required String habitIcon,
    required int hour,
    required int minute,
    required List<int> weekDays, // 1=Mon … 7=Sun (DateTime.monday … sunday)
  }) async {
    // Cancel existing
    await _plugin.cancel(id);

    // Schedule for each selected weekday
    for (final day in weekDays) {
      final scheduledDate = _nextWeekday(day, hour, minute);
      await _plugin.zonedSchedule(
        id + day, // unique per day
        '$habitIcon $habitLabel',
        'Time to keep your streak alive! 🔥',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _habitChannel.id,
            _habitChannel.name,
            channelDescription: _habitChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            color: const Color(0xFFF472B6),
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  // ── Schedule event reminder ───────────────────────────────────

  static Future<void> scheduleEventReminder({
    required int id,
    required String eventTitle,
    required String eventIcon,
    required DateTime eventStartAt,
    required int minutesBefore,
  }) async {
    final reminderTime = eventStartAt.subtract(Duration(minutes: minutesBefore));
    if (reminderTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      '$eventIcon $eventTitle',
      minutesBefore == 0
          ? 'Starting now!'
          : 'Starting in $minutesBefore minutes ⏰',
      tz.TZDateTime.from(reminderTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _eventChannel.id,
          _eventChannel.name,
          channelDescription: _eventChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── Streak celebration ────────────────────────────────────────

  static Future<void> showStreakCelebration({
    required String habitLabel,
    required int streakCount,
    required String badge,
  }) async {
    await _plugin.show(
      999,
      '$badge $streakCount-day streak!',
      'Amazing work on "$habitLabel" 🌸 Keep it up!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bloom_streaks',
          'Streak Celebrations',
          importance: Importance.low,
          priority: Priority.low,
          color: Color(0xFFF472B6),
        ),
        iOS: DarwinNotificationDetails(presentSound: false),
      ),
    );
  }

  // ── Cancel ───────────────────────────────────────────────────

  static Future<void> cancelHabitReminder(int habitId) async {
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(habitId + day);
    }
  }

  static Future<void> cancelEventReminder(int eventId) =>
      _plugin.cancel(eventId);

  static Future<void> cancelAll() => _plugin.cancelAll();

  // ── Tap handler ───────────────────────────────────────────────

  static void _onTap(NotificationResponse response) {
    // TODO: navigate to the relevant screen using the router
    // The payload can carry the route, e.g. '/habits/abc123'
  }

  // ── Helpers ───────────────────────────────────────────────────

  static tz.TZDateTime _nextWeekday(int weekday, int hour, int minute) {
    var date = tz.TZDateTime.now(tz.local);
    final target = date.copyWith(hour: hour, minute: minute, second: 0);
    // Advance until we hit the right weekday
    while (target.weekday != weekday || target.isBefore(date)) {
      date = date.add(const Duration(days: 1));
    }
    return tz.TZDateTime(tz.local, date.year, date.month, date.day, hour, minute);
  }
}

// Needed for Android color constant
class Color {
  final int value;
  const Color(this.value);
}

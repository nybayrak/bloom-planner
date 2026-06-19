// lib/features/calendar/screens/calendar_screen.dart
export '../../../features/calendar/screens/calendar_screen_impl.dart';

// lib/features/calendar/screens/calendar_screen_impl.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/bloom_card.dart';
import '../../../core/db/models.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  // View mode: day | week | month | year
  String _view = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Text('➕', style: TextStyle(fontSize: 18)),
            onPressed: () => context.push(Routes.addEvent),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── View switcher ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: BloomColors.cloud,
                borderRadius: BorderRadius.all(BloomRadius.pill),
              ),
              child: Row(
                children: ['Day', 'Week', 'Month', 'Year'].map((v) {
                  final active = _view == v.toLowerCase();
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _view = v.toLowerCase()),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: active ? BloomColors.bloom : Colors.transparent,
                          borderRadius: BorderRadius.all(BloomRadius.pill),
                        ),
                        child: Text(
                          v,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: BloomFonts.body,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : BloomColors.stone,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Calendar widget ────────────────────────────────
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2099, 12, 31), // rolling — no end
            focusedDay: _focused,
            selectedDayPredicate: (d) => isSameDay(d, _selected),
            calendarFormat: _format,
            onFormatChanged: (f) => setState(() => _format = f),
            onDaySelected: (sel, foc) => setState(() {
              _selected = sel;
              _focused  = foc;
            }),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(color: BloomColors.bloom, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: BloomColors.bloom.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: BloomColors.bloom, width: 2),
              ),
              selectedTextStyle: const TextStyle(color: BloomColors.bloom, fontWeight: FontWeight.w700),
              weekendTextStyle: const TextStyle(color: BloomColors.stone),
              markerDecoration: const BoxDecoration(color: BloomColors.bloom, shape: BoxShape.circle),
              markersMaxCount: 3,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontFamily: BloomFonts.display,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BloomColors.ink,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: BloomColors.bloom),
              rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: BloomColors.bloom),
            ),
          ),

          const Divider(height: 1),

          // ── Day events ────────────────────────────────────
          Expanded(
            child: _DayEventList(date: _selected),
          ),
        ],
      ),
    );
  }
}

class _DayEventList extends ConsumerWidget {
  const _DayEventList({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: load from Isar CalendarEvent for this date
    final mockEvents = [
      ('8:00', 'Morning journaling ✍️', '30 min', BloomColors.petal),
      ('10:00', 'Team standup', '15 min', BloomColors.mist),
      ('12:00', 'Lunch + walk 🥗', '1 hr', BloomColors.sage),
      ('14:00', 'Focus work block', '2 hrs', BloomColors.lavender),
      ('18:30', 'Yoga class 🧘‍♀️', '1 hr', BloomColors.peach),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockEvents.length,
      itemBuilder: (_, i) {
        final (time, label, dur, color) = mockEvents[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Text(time, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BloomColors.stone)),
              ),
              Container(width: 2, height: 52, color: BloomColors.cloud, margin: const EdgeInsets.symmetric(horizontal: 8)),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(BloomRadius.md),
                    border: Border(left: BorderSide(color: color.withOpacity(0.6), width: 3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BloomColors.ink)),
                      Text(dur, style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ADD EVENT SCREEN (minimal, expandable)
// ─────────────────────────────────────────────────────────────

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New Event')),
    body: const Center(child: Text('Add Event form — Phase 2 🌸')),
  );
}

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Event')),
    body: Center(child: Text('Event $eventId')),
  );
}

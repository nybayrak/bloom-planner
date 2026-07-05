import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await IsarService.getCalendarEvents();
    setState(() => _events = events);
  }

  List<CalendarEvent> _eventsForDay(DateTime day) {
    return _events.where((e) =>
      e.startDate.year == day.year &&
      e.startDate.month == day.month &&
      e.startDate.day == day.day).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _eventsForDay(_selectedDay!)
        : _eventsForDay(_focusedDay);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8A598),
        title: const Text('📅 Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _eventsForDay,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(color: Color(0xFFE8A598), shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Color(0xFFD4A5A5), shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Color(0xFFE8A598), shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(child: Text('No events on this day 🌸'))
                : ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (ctx, i) {
                      final event = selectedEvents[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.event, color: Color(0xFFE8A598)),
                          title: Text(event.title),
                          subtitle: event.description != null ? Text(event.description!) : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

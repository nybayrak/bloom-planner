import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/db/isar_service.dart';
import '../../../core/db/models.dart';
import 'package:uuid/uuid.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
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

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = _selectedDay ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('📅 Add Event', style: TextStyle(color: Color(0xFFE8A598))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Event title', prefixIcon: Icon(Icons.title)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.notes)),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFFE8A598)),
                  title: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  subtitle: const Text('Tap to change date'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setDialogState(() => selectedDate = picked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Color(0xFFE8A598)),
                  title: Text(selectedTime.format(ctx)),
                  subtitle: const Text('Tap to change time'),
                  onTap: () async {
                    final picked = await showTimePicker(context: ctx, initialTime: selectedTime);
                    if (picked != null) setDialogState(() => selectedTime = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8A598), foregroundColor: Colors.white),
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                final eventDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                final event = CalendarEvent(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text.isEmpty ? null : descController.text,
                  startDate: eventDate,
                );
                await IsarService.putCalendarEvent(event);
                await _loadEvents();
                if (mounted) Navigator.pop(ctx);
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEvent(CalendarEvent event) async {
    final prefs = await IsarService.getCalendarEvents();
    final updated = prefs.where((e) => e.id != event.id).toList();
    // Save updated list
    setState(() => _events = updated);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _eventsForDay(_selectedDay ?? _focusedDay);

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
              setState(() { _selectedDay = selected; _focusedDay = focused; });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(color: Color(0xFFE8A598), shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Color(0xFFD4A5A5), shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Color(0xFF7B5EA7), shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Color(0xFFE8A598), fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  _selectedDay != null
                    ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
                    : 'Today',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE8A598), fontSize: 16),
                ),
                const Spacer(),
                Text('${selectedEvents.length} event(s)', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🌸', style: TextStyle(fontSize: 40)),
                        SizedBox(height: 8),
                        Text('No events on this day', style: TextStyle(color: Colors.grey)),
                        Text('Tap + to add one!', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedEvents.length,
                    itemBuilder: (ctx, i) {
                      final event = selectedEvents[i];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE8A598),
                            child: Icon(Icons.event, color: Colors.white, size: 18),
                          ),
                          title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${event.startDate.hour}:${event.startDate.minute.toString().padLeft(2, '0')}'),
                              if (event.description != null) Text(event.description!),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteEvent(event),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8A598),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _showAddEventDialog,
      ),
    );
  }
}

// lib/features/home/widgets/mood_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/bloom_card.dart';
import '../providers/home_provider.dart';

class MoodCard extends ConsumerWidget {
  const MoodCard({super.key});

  static const _moods = ['😔', '😕', '😐', '🙂', '😄'];
  static const _labels = ['Low', 'Meh', 'Okay', 'Good', 'Great'];
  static const _colors = [
    Color(0xFFFCA5A5),
    Color(0xFFFED7AA),
    Color(0xFFFDE68A),
    Color(0xFF86EFAC),
    Color(0xFF6EE7B7),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = ref.watch(homeProvider).todayMood;

    return BloomCard(
      color: BloomColors.petal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('💭', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text('How are you feeling?', style: Theme.of(context).textTheme.titleSmall),
            if (mood != null) ...[
              const Spacer(),
              Text(_moods[mood - 1], style: const TextStyle(fontSize: 14)),
            ],
          ]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final selected = mood == i + 1;
              return GestureDetector(
                onTap: () => ref.read(homeProvider.notifier).logMood(i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected ? _colors[i] : Colors.transparent,
                    borderRadius: BorderRadius.all(BloomRadius.md),
                    border: Border.all(
                      color: selected ? _colors[i] : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(_moods[i], style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 2),
                      Text(
                        _labels[i],
                        style: TextStyle(
                          fontFamily: BloomFonts.body,
                          fontSize: 9,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: BloomColors.stone,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/progress_rings_card.dart
class ProgressRingsCard extends ConsumerWidget {
  const ProgressRingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return BloomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✨ Today\'s Progress', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Ring(
                pct: state.habitProgress,
                color: BloomColors.bloom,
                label: 'Habits',
                sub: '${state.habitsDone}/${state.habitsTotal} done',
              ),
              _Ring(
                pct: state.taskProgress,
                color: BloomColors.lavender,
                label: 'Tasks',
                sub: '${state.tasksDone}/${state.tasksTotal} done',
              ),
              _Ring(
                pct: state.waterProgress,
                color: BloomColors.mist.withBlue(200),
                label: 'Water',
                sub: '${state.waterCups}/${state.waterTarget} cups',
              ),
              _Ring(
                pct: state.stepProgress,
                color: BloomColors.sun.withRed(230),
                label: 'Steps',
                sub: '4.5k / 10k',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.pct, required this.color, required this.label, required this.sub});
  final double pct;
  final Color color;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 60, height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: pct,
                strokeWidth: 7,
                backgroundColor: BloomColors.cloud,
                valueColor: AlwaysStoppedAnimation(color),
                strokeCap: StrokeCap.round,
              ),
              Text(
                '${(pct * 100).round()}%',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.ink)),
        Text(sub, style: const TextStyle(fontSize: 9, color: BloomColors.stone)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/todays_priorities_card.dart
class TodaysPrioritiesCard extends ConsumerWidget {
  const TodaysPrioritiesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final tasks  = state.tasks.take(5).toList();

    return BloomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🎯 Today\'s Priorities', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: BloomColors.petal,
                    borderRadius: BorderRadius.all(BloomRadius.pill),
                  ),
                  child: const Text('+ Add', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.bloom)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            const _EmptyTasks()
          else
            ...tasks.asMap().entries.map((e) => _TaskRow(
                  task: e.value,
                  isLast: e.key == tasks.length - 1,
                  onToggle: () => ref.read(homeProvider.notifier).toggleTask(e.value.taskId),
                )),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.isLast, required this.onToggle});
  final task;
  final bool isLast;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final done = task.isDone as bool;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: done ? BloomColors.sage : Colors.transparent,
                    border: Border.all(
                      color: done ? BloomColors.sage : BloomColors.cloud,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(BloomRadius.sm),
                  ),
                  child: done
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.title as String,
                  style: TextStyle(
                    fontFamily: BloomFonts.body,
                    fontSize: 13,
                    color: done ? BloomColors.stone : BloomColors.ink,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: BloomColors.categoryColors[(task.category as TaskCategory).name] ?? BloomColors.petal,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: BloomColors.cloud),
      ],
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Column(
            children: [
              const Text('🌸', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text('All clear! Tap + Add to plan your day.',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/habit_mini_card.dart
class HabitMiniCard extends ConsumerWidget {
  const HabitMiniCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state  = ref.watch(homeProvider);
    final habits = state.habits.take(4).toList();
    final weekDays = _weekLabels();

    return BloomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('⭐ Habits', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text('Week ${_weekNumber()}', style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
            ],
          ),
          const SizedBox(height: 10),
          // Day labels header
          Row(children: [
            const SizedBox(width: 86),
            ...weekDays.map((d) => Expanded(
              child: Center(child: Text(d, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: BloomColors.stone))),
            )),
          ]),
          const SizedBox(height: 6),
          ...habits.map((h) => _HabitRow(habit: h, doneToday: state.doneHabitIds.contains(h.habitId))),
        ],
      ),
    );
  }

  List<String> _weekLabels() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days;
  }

  int _weekNumber() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return (dayOfYear / 7).ceil();
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({required this.habit, required this.doneToday});
  final Habit habit;
  final bool doneToday;

  @override
  Widget build(BuildContext context) {
    // Fake week history for demo (replace with real HabitLog query per day)
    final fakeDone = [true, true, false, true, true, doneToday, false];

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(habit.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          SizedBox(
            width: 60,
            child: Text(habit.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: BloomColors.ink), overflow: TextOverflow.ellipsis),
          ),
          ...fakeDone.map((done) => Expanded(
            child: Center(
              child: Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: done ? BloomColors.bloom : Colors.transparent,
                  border: Border.all(color: done ? BloomColors.bloom : BloomColors.cloud, width: 2),
                  shape: BoxShape.circle,
                ),
                child: done ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/upcoming_events_card.dart
class UpcomingEventsCard extends ConsumerWidget {
  const UpcomingEventsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(homeProvider).upcomingEvents;

    return BloomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Coming Up', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No upcoming events — enjoy the free time! 🌸', style: TextStyle(fontSize: 12, color: BloomColors.stone)),
            )
          else
            ...events.map((e) {
              final catColor = BloomColors.categoryColors[e.category.name] ?? BloomColors.petal;
              final timeStr  = _formatEventTime(e);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(width: 3, height: 38, decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.all(BloomRadius.pill))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BloomColors.ink)),
                          Text(timeStr, style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.all(BloomRadius.pill)),
                      child: Text(e.category.name, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: BloomColors.ink)),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatEventTime(CalendarEvent e) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eDay  = DateTime(e.startAt.year, e.startAt.month, e.startAt.day);
    final diff  = eDay.difference(today).inDays;
    final timeF = '${e.startAt.hour}:${e.startAt.minute.toString().padLeft(2,'0')}';
    if (diff == 0) return 'Today · $timeF';
    if (diff == 1) return 'Tomorrow · $timeF';
    return '${e.startAt.day}/${e.startAt.month} · $timeF';
  }
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/daily_wins_card.dart
class DailyWinsCard extends StatelessWidget {
  const DailyWinsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BloomCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFDE68A), Color(0xFFFCA5A5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🏆 Today\'s Wins', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          const Text(
            '✅ Woke up before alarm\n✅ Made a healthy breakfast\n✅ Hit my step goal!',
            style: TextStyle(fontFamily: BloomFonts.handwriting, fontSize: 14, color: BloomColors.ink, height: 1.6),
          ),
          const SizedBox(height: 10),
          const Center(child: Text('🎉🌸✨', style: TextStyle(fontSize: 24))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/features/home/widgets/quote_card.dart
class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  // Hard-coded for now — replace with QuoteService
  static const _quotes = [
    ('Small steps every day lead to big changes every year.', '🌱'),
    ('You don\'t have to be perfect to be amazing.', '✨'),
    ('Progress, not perfection.', '🎯'),
    ('Every day is a fresh start.', '🌸'),
    ('Your only limit is you.', '💪'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = DateTime.now().day % _quotes.length;
    final (quote, emoji) = _quotes[idx];

    return BloomCard(
      color: BloomColors.cloud,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '"$quote"',
              style: const TextStyle(
                fontFamily: BloomFonts.handwriting,
                fontSize: 13,
                color: BloomColors.stone,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

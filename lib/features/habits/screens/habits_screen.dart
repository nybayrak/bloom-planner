// lib/features/habits/screens/habits_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/bloom_card.dart';
import '../../../core/db/models.dart';
import '../providers/habits_provider.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Gradient header ──────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEDE9FE), Color(0xFFFCE7F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⭐ Habit Tracker', style: Theme.of(context).textTheme.displaySmall),
                    Text('Week ${_weekNum()} · Keep the streak alive! 🔥',
                        style: const TextStyle(fontSize: 12, color: BloomColors.stone)),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Text('➕', style: TextStyle(fontSize: 18)),
                onPressed: () => context.push(Routes.addHabit),
              ),
            ],
          ),

          // ── Stats row ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _StatsRow(state: state),
            ),
          ),

          // ── Water tracker ────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: _WaterTracker()),
          ),

          // ── Habit list ───────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: state.isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _HabitCard(
                        habit: state.habits[i],
                        doneToday: state.doneToday.contains(state.habits[i].habitId),
                        onToggle: () => ref.read(habitsProvider.notifier).toggleToday(state.habits[i].habitId),
                      ).animate().fadeIn(delay: Duration(milliseconds: 50 * i)).slideY(begin: 0.05),
                      childCount: state.habits.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int _weekNum() {
    final n = DateTime.now();
    return (n.difference(DateTime(n.year, 1, 1)).inDays / 7).ceil();
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});
  final dynamic state; // HabitsState

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          _StatBox(value: '${state.doneToday?.length ?? 0}/${state.habits?.length ?? 0}', label: 'Done today', color: BloomColors.petal),
          const SizedBox(width: 8),
          _StatBox(value: '🔥${state.bestStreak ?? 0}', label: 'Best streak', color: BloomColors.peach),
          const SizedBox(width: 8),
          _StatBox(value: '${state.weeklyPct ?? 87}%', label: 'This week', color: BloomColors.sage),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(BloomRadius.md)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: BloomColors.ink)),
          Text(label, style: const TextStyle(fontSize: 9, color: BloomColors.stone)),
        ],
      ),
    ),
  );
}

class _WaterTracker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cups = ref.watch(habitsProvider).waterCups;
    final target = 8;

    return BloomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('💧', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text('Water Tracker', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Text('$cups/$target cups', style: const TextStyle(fontSize: 11, color: BloomColors.stone)),
          ]),
          const SizedBox(height: 10),
          Row(
            children: List.generate(target, (i) => Expanded(
              child: GestureDetector(
                onTap: () => ref.read(habitsProvider.notifier).setWater(i < cups ? i : i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 40,
                  decoration: BoxDecoration(
                    color: i < cups ? BloomColors.mist : BloomColors.cloud,
                    borderRadius: BorderRadius.all(BloomRadius.md),
                    border: Border.all(color: i < cups ? const Color(0xFF7DD3FC) : BloomColors.cloud, width: 2),
                  ),
                  child: Center(child: Text(i < cups ? '💧' : '·', style: const TextStyle(fontSize: 14))),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit, required this.doneToday, required this.onToggle});
  final Habit habit;
  final bool doneToday;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _hexColor(habit.color);

    return BloomCard(
      child: Row(
        children: [
          // Icon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(BloomRadius.md)),
            child: Center(child: Text(habit.icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 10),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(habit.label, style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    if (habit.currentStreak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: BloomColors.peach, borderRadius: BorderRadius.all(BloomRadius.pill)),
                        child: Text('🔥 ${habit.currentStreak}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BloomColors.ink)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (habit.targetValue != null)
                  Text('Goal: ${habit.targetValue!.toStringAsFixed(habit.targetValue! % 1 == 0 ? 0 : 1)} ${habit.targetUnit ?? ''}',
                      style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.all(BloomRadius.pill),
                  child: LinearProgressIndicator(
                    value: doneToday ? 1.0 : 0.0,
                    minHeight: 6,
                    backgroundColor: BloomColors.cloud,
                    valueColor: AlwaysStoppedAnimation(doneToday ? BloomColors.sage : BloomColors.bloom),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: doneToday ? BloomColors.sage : Colors.transparent,
                border: Border.all(color: doneToday ? BloomColors.sage : BloomColors.cloud, width: 2),
                shape: BoxShape.circle,
              ),
              child: doneToday ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return BloomColors.petal;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// STUB SUB-SCREENS
// ─────────────────────────────────────────────────────────────

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habitId});
  final String habitId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Habit Detail')),
    body: Center(child: Text('Detail for habit $habitId')),
  );
}

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New Habit')),
    body: const Center(child: Text('Add Habit form — coming in Phase 2 🌱')),
  );
}

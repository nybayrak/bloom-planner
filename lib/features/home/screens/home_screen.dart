// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/bloom_card.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../../core/services/auth_service.dart';
import '../providers/home_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/mood_card.dart';
import '../widgets/progress_rings_card.dart';
import '../widgets/todays_priorities_card.dart';
import '../widgets/habit_mini_card.dart';
import '../widgets/upcoming_events_card.dart';
import '../widgets/daily_wins_card.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final homeState = ref.watch(homeProvider);
    final season = ref.watch(seasonProvider);

    return Scaffold(
      backgroundColor: BloomColors.chalk,
      body: RefreshIndicator(
        color: BloomColors.bloom,
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Gradient header ─────────────────────────────
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: GreetingHeader(
                  userName: user?.displayName ?? 'Friend',
                  season: season,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Text('⚙️', style: TextStyle(fontSize: 20)),
                  onPressed: () => context.push(Routes.settings),
                ),
              ],
            ),

            // ── Content ─────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // Motivational quote
                  const QuoteCard()
                      .animate().fadeIn(delay: 50.ms).slideY(begin: 0.1),

                  // Progress rings (habits / tasks / water / steps)
                  const ProgressRingsCard()
                      .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                  // Mood tracker
                  const MoodCard()
                      .animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),

                  // Today's priorities / tasks
                  const TodaysPrioritiesCard()
                      .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  // Habit mini-tracker (week grid)
                  const HabitMiniCard()
                      .animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),

                  // Upcoming events
                  const UpcomingEventsCard()
                      .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  // Daily wins
                  const DailyWinsCard()
                      .animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),

      // ── FAB — quick add ──────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAdd(context, ref),
        backgroundColor: BloomColors.bloom,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Quick Add',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showQuickAdd(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _QuickAddSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK ADD BOTTOM SHEET
// ─────────────────────────────────────────────────────────────

class _QuickAddSheet extends StatelessWidget {
  const _QuickAddSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: BloomRadius.xl,
          topRight: BloomRadius.xl,
        ),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: BloomColors.cloud,
                borderRadius: BorderRadius.all(BloomRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Add ✨',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickAddOption(
                icon: '✅',
                label: 'Task',
                color: BloomColors.petal,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: push add-task sheet
                },
              ),
              _QuickAddOption(
                icon: '📅',
                label: 'Event',
                color: BloomColors.mist,
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.addEvent);
                },
              ),
              _QuickAddOption(
                icon: '⭐',
                label: 'Habit',
                color: BloomColors.sun,
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.addHabit);
                },
              ),
              _QuickAddOption(
                icon: '🎯',
                label: 'Goal',
                color: BloomColors.peach,
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.addGoal);
                },
              ),
              _QuickAddOption(
                icon: '📖',
                label: 'Journal',
                color: BloomColors.lavender,
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.journal);
                },
              ),
              _QuickAddOption(
                icon: '💭',
                label: 'Mood',
                color: BloomColors.sage,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: open mood logger inline
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _QuickAddOption extends StatelessWidget {
  const _QuickAddOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 3,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(BloomRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: BloomFonts.body,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: BloomColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

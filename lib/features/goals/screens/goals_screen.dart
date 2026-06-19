// lib/features/goals/screens/goals_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/bloom_card.dart';
import '../../../core/db/models.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFFCA5A5), Color(0xFFC084FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🎯 Goals & Vision', style: Theme.of(context).textTheme.displaySmall),
                    Text('Q2 · April – June 2026', style: const TextStyle(fontSize: 12, color: BloomColors.ink)),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Text('➕', style: TextStyle(fontSize: 18)),
                onPressed: () => context.push(Routes.addGoal),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Vision board ──────────────────────────
                BloomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('🌟 Vision Board', style: Theme.of(context).textTheme.titleSmall),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.push(Routes.visionBoard),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(color: BloomColors.petal, borderRadius: BorderRadius.all(BloomRadius.pill)),
                            child: const Text('View All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.bloom)),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.6,
                        children: const [
                          _VisionTile(emoji: '🏠', label: 'Dream Home', color: Color(0xFFFCE7F3)),
                          _VisionTile(emoji: '✈️', label: 'Travel Italy', color: Color(0xFFE0F2FE)),
                          _VisionTile(emoji: '💪', label: 'Get Fit', color: Color(0xFF86EFAC)),
                          _VisionTile(emoji: '📖', label: 'Write a Book', color: Color(0xFFFDE68A)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 50.ms),

                // ── Annual goals ──────────────────────────
                const _SectionLabel('🗓️ Annual Goals · 2026'),
                ...[
                  ('Run a 5K race 🏃', 0.60, BloomColors.sage),
                  ('Save \$10,000 💰', 0.40, BloomColors.sun),
                  ('Read 24 books 📚', 0.50, BloomColors.lavender),
                  ('Learn Spanish 🇪🇸', 0.25, BloomColors.peach),
                ].asMap().entries.map((e) => _GoalProgressCard(
                  label: e.value.$1,
                  percent: e.value.$2,
                  color: e.value.$3,
                ).animate().fadeIn(delay: Duration(milliseconds: 80 * (e.key + 1)))),

                // ── Q2 goals ──────────────────────────────
                const _SectionLabel('📌 Q2 Goals (Current)'),
                ...[
                  ('Complete online course', true),
                  ('Declutter home office', true),
                  ('Start vegetable garden 🌱', false),
                  ('Plan family vacation', false),
                ].map((g) => _CheckGoal(label: g.$1, done: g.$2)),

                // ── Savings tracker ───────────────────────
                BloomCard(
                  color: BloomColors.sun,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('💰', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text('Savings Tracker', style: Theme.of(context).textTheme.titleSmall),
                      ]),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Goal: \$10,000', style: TextStyle(fontSize: 11, color: BloomColors.stone)),
                          Text('\$4,000 saved', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.ink)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.all(BloomRadius.pill),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 14,
                          backgroundColor: Color(0x44FFFFFF),
                          valueColor: AlwaysStoppedAnimation(BloomColors.bloom),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('🎯 \$6,000 to go · On track for December!',
                          style: TextStyle(fontSize: 10, color: BloomColors.stone)),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionTile extends StatelessWidget {
  const _VisionTile({required this.emoji, required this.label, required this.color});
  final String emoji;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(BloomRadius.lg)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.ink)),
      ],
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 6),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _GoalProgressCard extends StatelessWidget {
  const _GoalProgressCard({required this.label, required this.percent, required this.color});
  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) => BloomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
          Text('${(percent * 100).round()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BloomColors.stone)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.all(BloomRadius.pill),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: BloomColors.cloud,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    ),
  );
}

class _CheckGoal extends StatelessWidget {
  const _CheckGoal({required this.label, required this.done});
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(BloomRadius.md),
      boxShadow: BloomShadows.soft,
    ),
    child: Row(
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: done ? BloomColors.sage : Colors.transparent,
            border: Border.all(color: done ? BloomColors.sage : BloomColors.cloud, width: 2),
            borderRadius: BorderRadius.all(BloomRadius.sm),
          ),
          child: done ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: TextStyle(
          fontSize: 13,
          color: done ? BloomColors.stone : BloomColors.ink,
          decoration: done ? TextDecoration.lineThrough : null,
        ))),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// STUB SUB-SCREENS
// ─────────────────────────────────────────────────────────────

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key, required this.goalId});
  final String goalId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Goal Detail')),
    body: Center(child: Text('Goal $goalId')),
  );
}

class VisionBoardScreen extends StatelessWidget {
  const VisionBoardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vision Board 🌟')),
    body: const Center(child: Text('Vision Board — Phase 3 ✨')),
  );
}

class AddGoalScreen extends StatelessWidget {
  const AddGoalScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New Goal')),
    body: const Center(child: Text('Add Goal form — Phase 3 🎯')),
  );
}

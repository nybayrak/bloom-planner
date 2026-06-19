// lib/features/journal/screens/journal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/bloom_card.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal 📖'),
        actions: [
          IconButton(
            icon: const Text('✍️', style: TextStyle(fontSize: 18)),
            onPressed: () => context.push('${Routes.journal}/${DateFormat('yyyy-MM-dd').format(today)}'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = today.subtract(Duration(days: i));
          final dateStr = DateFormat('EEEE, MMMM d').format(date);
          final isToday = i == 0;
          return BloomCard(
            color: isToday ? BloomColors.petal : Colors.white,
            onTap: () => context.push('${Routes.journal}/${DateFormat('yyyy-MM-dd').format(date)}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(isToday ? '📖 Today' : dateStr,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: isToday ? BloomColors.bloom : null)),
                  const Spacer(),
                  Text(DateFormat('MMM d').format(date),
                      style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                ]),
                if (i > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Today was productive. Got a lot done and feeling grateful for the sunshine. 🌸',
                    style: const TextStyle(fontFamily: BloomFonts.handwriting, fontSize: 13, color: BloomColors.stone, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(spacing: 4, children: ['🌸','✨','😊'].map((s) => Text(s, style: const TextStyle(fontSize: 16))).toList()),
                ] else
                  Text('Tap to write today\'s entry ✍️', style: const TextStyle(fontSize: 12, color: BloomColors.stone)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, required this.dateString});
  final String dateString;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _ctrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dateString),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save 🌸')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BloomCard(
              color: BloomColors.petal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🙏 Gratitude', style: TextStyle(fontWeight: FontWeight.w700, color: BloomColors.ink)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _gratitudeCtrl,
                    maxLines: 3,
                    style: const TextStyle(fontFamily: BloomFonts.handwriting, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'Three things I\'m grateful for today…',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ],
              ),
            ),
            BloomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✍️ My Entry', style: TextStyle(fontWeight: FontWeight.w700, color: BloomColors.ink)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _ctrl,
                    maxLines: 12,
                    style: const TextStyle(fontFamily: BloomFonts.handwriting, fontSize: 15, height: 1.6),
                    decoration: const InputDecoration(
                      hintText: 'How was your day? What are you thinking about?',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ],
              ),
            ),
            // Sticker row
            BloomCard(
              color: BloomColors.cloud,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎨 Stickers', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: BloomColors.ink)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: ['🌸','🦋','🌈','⭐','🎀','🌺','🍀','🌙','🎉','🦄'].map(
                      (s) => GestureDetector(
                        onTap: () => _ctrl.text += s,
                        child: Text(s, style: const TextStyle(fontSize: 26)),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    // TODO: save to Isar
    Navigator.of(context).pop();
  }
}

// ─────────────────────────────────────────────────────────────
// FAMILY SCREEN
// ─────────────────────────────────────────────────────────────

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Hub 👨‍👩‍👧')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BloomCard(
            color: BloomColors.peach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Family Members', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                Row(
                  children: ['👩 Mom','👨 Dad','👧 Emma','👦 Liam'].map((m) => Expanded(
                    child: Column(children: [
                      Text(m.split(' ').first, style: const TextStyle(fontSize: 28)),
                      Text(m.split(' ').last, style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                    ]),
                  )).toList(),
                ),
              ],
            ),
          ),
          BloomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📅 Shared Calendar', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...[
                  ('Emma — School recital 🎵', 'Thu Jun 18', BloomColors.petal),
                  ('Family dinner 🍝', 'Sat Jun 20', BloomColors.peach),
                  ('Liam — Soccer game ⚽', 'Sun Jun 21', BloomColors.sage),
                ].map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Container(width: 3, height: 36, color: e.$3, margin: const EdgeInsets.only(right: 10)),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.$1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BloomColors.ink)),
                      Text(e.$2, style: const TextStyle(fontSize: 10, color: BloomColors.stone)),
                    ])),
                  ]),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BUDGET SCREEN
// ─────────────────────────────────────────────────────────────

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Planner 💰')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BloomCard(
            color: BloomColors.sun,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('June Budget', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Income', style: TextStyle(fontSize: 12, color: BloomColors.stone)),
                  Text('\$5,200', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: BloomColors.ink)),
                ]),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Spent', style: TextStyle(fontSize: 12, color: BloomColors.stone)),
                  Text('\$3,140', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: BloomColors.bloom)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.all(BloomRadius.pill),
                  child: const LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 10,
                    backgroundColor: Color(0x44FFFFFF),
                    valueColor: AlwaysStoppedAnimation(BloomColors.bloom),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('60% of budget used — looking good! 🌟', style: TextStyle(fontSize: 10, color: BloomColors.stone)),
              ],
            ),
          ),
          BloomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...[
                  ('🏠 Housing',      0.30, '\$1,200', BloomColors.petal),
                  ('🛒 Food',         0.20, '\$820',   BloomColors.sage),
                  ('🚗 Transport',    0.12, '\$480',   BloomColors.mist),
                  ('🎮 Entertainment',0.08, '\$320',   BloomColors.lavender),
                  ('💊 Health',       0.06, '\$220',   BloomColors.peach),
                  ('💰 Savings',      0.24, '\$960',   BloomColors.sun),
                ].map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    SizedBox(width: 120, child: Text(c.$1, style: const TextStyle(fontSize: 12, color: BloomColors.ink))),
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.all(BloomRadius.pill),
                      child: LinearProgressIndicator(
                        value: c.$2,
                        minHeight: 8,
                        backgroundColor: BloomColors.cloud,
                        valueColor: AlwaysStoppedAnimation(c.$4),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Text(c.$3, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.ink)),
                  ]),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SETTINGS SCREENS
// ─────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsGroup(title: 'Account', items: [
            _SettingsTile(icon: '👤', label: 'Profile', onTap: () => context.push(Routes.profile)),
            _SettingsTile(icon: '🌸', label: 'Subscription', onTap: () => context.push(Routes.subscription)),
          ]),
          _SettingsGroup(title: 'Appearance', items: [
            _SettingsTile(icon: '🎨', label: 'Themes & Stickers', onTap: () => context.push(Routes.themes)),
            _SettingsTile(icon: '🌙', label: 'Dark Mode', trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v ? ThemeMode.dark : ThemeMode.light),
              activeColor: BloomColors.bloom,
            )),
          ]),
          _SettingsGroup(title: 'Notifications', items: [
            _SettingsTile(icon: '🔔', label: 'Reminders', onTap: () => context.push(Routes.notifications)),
          ]),
          _SettingsGroup(title: 'Features', items: [
            _SettingsTile(icon: '🧠', label: 'ADHD-Friendly Mode', trailing: Switch(value: false, onChanged: (_) {}, activeColor: BloomColors.bloom)),
            _SettingsTile(icon: '👨‍👩‍👧', label: 'Family Mode', trailing: Switch(value: false, onChanged: (_) {}, activeColor: BloomColors.bloom)),
          ]),
          _SettingsGroup(title: 'About', items: [
            _SettingsTile(icon: '⭐', label: 'Rate Bloom Planner', onTap: () {}),
            _SettingsTile(icon: '📤', label: 'Export Data', onTap: () {}),
            _SettingsTile(icon: '🚪', label: 'Sign Out', textColor: const Color(0xFFFCA5A5), onTap: () {}),
          ]),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BloomColors.stone, letterSpacing: 1)),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(BloomRadius.lg), boxShadow: BloomShadows.soft),
        child: Column(children: items),
      ),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label, this.onTap, this.trailing, this.textColor});
  final String icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? textColor;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Text(icon, style: const TextStyle(fontSize: 20)),
    title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor ?? BloomColors.ink)),
    trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right_rounded, color: BloomColors.stone, size: 20) : null),
    onTap: onTap,
    dense: true,
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile')), body: const Center(child: Text('Profile settings 👤')));
}

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Themes & Stickers')), body: const Center(child: Text('Theme picker 🎨')));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Notifications')), body: const Center(child: Text('Notification settings 🔔')));
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bloom Pro 🌸')),
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🌸', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 12),
        const Text('Bloom Pro', style: TextStyle(fontFamily: BloomFonts.display, fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('\$4.99 / month', style: TextStyle(fontSize: 20, color: BloomColors.bloom, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        ...[
          'Unlimited habits & goals',
          'All seasonal themes',
          'Full sticker library',
          'Cloud sync',
          'Family sharing (up to 6)',
          'Priority support',
        ].map((f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle_rounded, color: BloomColors.sage, size: 18),
            const SizedBox(width: 8),
            Text(f),
          ]),
        )),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {}, child: const Text('Start 7-day free trial')),
      ]),
    ),
  );
}

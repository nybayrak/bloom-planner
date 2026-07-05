import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../../../core/db/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8A598),
        title: const Text('🌸 Bloom Planner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: '✅ Today\'s Tasks',
              child: tasksAsync.when(
                data: (tasks) => tasks.isEmpty
                    ? const Text('No tasks yet! Add one below 🌟')
                    : Column(children: tasks.take(5).map((t) => ListTile(
                        leading: Icon(t.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: const Color(0xFFE8A598)),
                        title: Text(t.title),
                        subtitle: t.dueDate != null ? Text('Due: ${t.dueDate!.day}/${t.dueDate!.month}') : null,
                      )).toList()),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '💧 Water Tracker',
              child: Column(
                children: [
                  const Text('Tap to log water intake'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(homeNotifierProvider.notifier).logWater(250),
                    icon: const Text('💧'),
                    label: const Text('Log 250ml'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8A598), foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '🌱 My Habits',
              child: habitsAsync.when(
                data: (habits) => habits.isEmpty
                    ? const Text('No habits yet! Start building good ones 💪')
                    : Column(children: habits.take(5).map((h) => ListTile(
                        leading: Text(h.emoji ?? '🌸', style: const TextStyle(fontSize: 24)),
                        title: Text(h.name),
                        trailing: ElevatedButton(
                          onPressed: () => ref.read(homeNotifierProvider.notifier).logHabit(h.id),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8A598), foregroundColor: Colors.white),
                          child: const Text('Done!'),
                        ),
                      )).toList()),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '😊 Mood Check-in',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: MoodLevel.values.map((mood) {
                  final emojis = ['😢', '😕', '😐', '🙂', '😄'];
                  final index = MoodLevel.values.indexOf(mood);
                  return GestureDetector(
                    onTap: () => ref.read(homeNotifierProvider.notifier).logMood(mood),
                    child: Text(emojis[index], style: const TextStyle(fontSize: 32)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8A598),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTaskDialog(context, ref),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Task ✅'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'What do you need to do?')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(homeNotifierProvider.notifier).addTask(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE8A598))),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/db/isar_service.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await IsarService.init();
  await NotificationService.init();
  runApp(const ProviderScope(child: BloomPlannerApp()));
}

class BloomPlannerApp extends ConsumerWidget {
  const BloomPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Bloom Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE8A598)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

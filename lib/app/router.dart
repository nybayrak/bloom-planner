// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/services/auth_service.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/login_screen.dart';
import '../features/onboarding/screens/signup_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/calendar/screens/event_detail_screen.dart';
import '../features/calendar/screens/add_event_screen.dart';
import '../features/habits/screens/habits_screen.dart';
import '../features/habits/screens/habit_detail_screen.dart';
import '../features/habits/screens/add_habit_screen.dart';
import '../features/goals/screens/goals_screen.dart';
import '../features/goals/screens/goal_detail_screen.dart';
import '../features/goals/screens/vision_board_screen.dart';
import '../features/goals/screens/add_goal_screen.dart';
import '../features/journal/screens/journal_screen.dart';
import '../features/journal/screens/journal_entry_screen.dart';
import '../features/family/screens/family_screen.dart';
import '../features/budget/screens/budget_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/settings/screens/profile_screen.dart';
import '../features/settings/screens/themes_screen.dart';
import '../features/settings/screens/notifications_screen.dart';
import '../features/settings/screens/subscription_screen.dart';
import '../shared/screens/shell_screen.dart';

// ─────────────────────────────────────────────────────────────
// ROUTE NAMES
// ─────────────────────────────────────────────────────────────

abstract class Routes {
  // Auth & onboarding
  static const splash      = '/';
  static const onboarding  = '/onboarding';
  static const login       = '/login';
  static const signup      = '/signup';

  // Main shell tabs
  static const home        = '/home';
  static const calendar    = '/calendar';
  static const habits      = '/habits';
  static const goals       = '/goals';
  static const more        = '/more';

  // Calendar sub-routes
  static const eventDetail = '/calendar/event/:id';
  static const addEvent    = '/calendar/add';

  // Habit sub-routes
  static const habitDetail = '/habits/:id';
  static const addHabit    = '/habits/add';

  // Goal sub-routes
  static const goalDetail  = '/goals/:id';
  static const addGoal     = '/goals/add';
  static const visionBoard = '/goals/vision-board';

  // Journal
  static const journal     = '/journal';
  static const journalEntry= '/journal/:date';

  // Feature pages
  static const family      = '/family';
  static const budget      = '/budget';

  // Settings
  static const settings       = '/settings';
  static const profile        = '/settings/profile';
  static const themes         = '/settings/themes';
  static const notifications  = '/settings/notifications';
  static const subscription   = '/settings/subscription';
}

// ─────────────────────────────────────────────────────────────
// ROUTER PROVIDER
// ─────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == Routes.login ||
                          state.matchedLocation == Routes.signup ||
                          state.matchedLocation == Routes.onboarding ||
                          state.matchedLocation == Routes.splash;

      if (!isLoggedIn && !isAuthRoute) return Routes.login;
      if (isLoggedIn && state.matchedLocation == Routes.login) return Routes.home;
      if (isLoggedIn && state.matchedLocation == Routes.signup) return Routes.home;
      return null;
    },

    routes: [
      // ── Auth & Onboarding ──────────────────────────────────
      GoRoute(
        path: Routes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (_, __) => const SignupScreen(),
      ),

      // ── Shell (bottom nav) ─────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (_, __) => _fade(const HomeScreen()),
          ),
          GoRoute(
            path: Routes.calendar,
            pageBuilder: (_, __) => _fade(const CalendarScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddEventScreen(),
              ),
              GoRoute(
                path: 'event/:id',
                builder: (ctx, state) => EventDetailScreen(
                  eventId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.habits,
            pageBuilder: (_, __) => _fade(const HabitsScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddHabitScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (ctx, state) => HabitDetailScreen(
                  habitId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.goals,
            pageBuilder: (_, __) => _fade(const GoalsScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddGoalScreen(),
              ),
              GoRoute(
                path: 'vision-board',
                builder: (_, __) => const VisionBoardScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (ctx, state) => GoalDetailScreen(
                  goalId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.more,
            pageBuilder: (_, __) => _fade(const MorePlaceholderScreen()),
          ),
        ],
      ),

      // ── Feature routes (full-screen, outside shell) ────────
      GoRoute(
        path: Routes.journal,
        builder: (_, __) => const JournalScreen(),
        routes: [
          GoRoute(
            path: ':date',
            builder: (ctx, state) => JournalEntryScreen(
              dateString: state.pathParameters['date']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.family,
        builder: (_, __) => const FamilyScreen(),
      ),
      GoRoute(
        path: Routes.budget,
        builder: (_, __) => const BudgetScreen(),
      ),

      // ── Settings ──────────────────────────────────────────
      GoRoute(
        path: Routes.settings,
        builder: (_, __) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'profile',       builder: (_, __) => const ProfileScreen()),
          GoRoute(path: 'themes',        builder: (_, __) => const ThemesScreen()),
          GoRoute(path: 'notifications', builder: (_, __) => const NotificationsScreen()),
          GoRoute(path: 'subscription',  builder: (_, __) => const SubscriptionScreen()),
        ],
      ),
    ],

    // ── Error page ──────────────────────────────────────────
    errorBuilder: (_, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌸', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Page not found', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(state.error?.message ?? '', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
  );
});

// Fade transition helper
CustomTransitionPage<void> _fade(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 200),
  );
}

// Placeholder for "More" tab — filled in later
class MorePlaceholderScreen extends StatelessWidget {
  const MorePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('More — coming soon')));
}

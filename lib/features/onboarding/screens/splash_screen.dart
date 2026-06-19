// lib/features/onboarding/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../core/services/auth_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final user = ref.read(currentUserProvider);
    if (user != null) {
      context.go(Routes.home);
    } else {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('onboarding_seen') ?? false;
      context.go(seen ? Routes.login : Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCE7F3), Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌸', style: TextStyle(fontSize: 72))
                  .animate()
                  .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              Text(
                'Bloom Planner',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: BloomFonts.display,
                  color: BloomColors.ink,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              const SizedBox(height: 8),
              Text(
                'Plan. Bloom. Thrive.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BloomColors.stone,
                  fontFamily: BloomFonts.handwriting,
                  fontSize: 16,
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ONBOARDING
// ─────────────────────────────────────────────────────────────

// lib/features/onboarding/screens/onboarding_screen.dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPage(
      emoji: '🌸',
      title: 'Your life, beautifully organised',
      body: 'A rolling planner that never expires. Track habits, set goals, and celebrate every win.',
      gradient: LinearGradient(colors: [Color(0xFFFCE7F3), Color(0xFFEDE9FE)]),
    ),
    _OnboardPage(
      emoji: '⭐',
      title: 'Build habits that stick',
      body: 'Track streaks, earn badges, and get gentle nudges when your streak is at risk.',
      gradient: LinearGradient(colors: [Color(0xFFEDE9FE), Color(0xFFE0F2FE)]),
    ),
    _OnboardPage(
      emoji: '🎯',
      title: 'Turn dreams into plans',
      body: 'Annual goals cascade into quarterly → monthly → weekly → daily action steps.',
      gradient: LinearGradient(colors: [Color(0xFFE0F2FE), Color(0xFFD1FAE5)]),
    ),
    _OnboardPage(
      emoji: '✨',
      title: 'Cute, fun, and ADHD-friendly',
      body: 'Stickers, washi tape, seasonal themes, and a focus mode that makes planning feel like play.',
      gradient: LinearGradient(colors: [Color(0xFFFDE68A), Color(0xFFFCE7F3)]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _pages[i],
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Page dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _page == i ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _page == i ? BloomColors.bloom : BloomColors.cloud,
                      borderRadius: BorderRadius.all(BloomRadius.pill),
                    ),
                  )),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_page < _pages.length - 1) {
                      _ctrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarding_seen', true);
                      if (context.mounted) context.go(Routes.signup);
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: Text(_page < _pages.length - 1 ? 'Next →' : 'Get Started 🌸'),
                ),
                if (_page < _pages.length - 1) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.body,
    required this.gradient,
  });

  final String emoji;
  final String title;
  final String body;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80))
              .animate().scale(curve: Curves.elasticOut, duration: 600.ms),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: BloomColors.stone),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 120), // space for bottom buttons
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LOGIN SCREEN (stub — flesh out in feature 2)
// ─────────────────────────────────────────────────────────────

// lib/features/onboarding/screens/login_screen.dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCE7F3), Color(0xFFEDE9FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text('🌸', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('Welcome back!', style: Theme.of(context).textTheme.displaySmall),
                Text('Sign in to your garden 🌿', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: BloomColors.stone)),
                const SizedBox(height: 32),

                // Email
                TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email address')),
                const SizedBox(height: 12),
                TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(hintText: 'Password')),
                const SizedBox(height: 8),

                if (_error != null) Text(_error!, style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12)),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _loading ? null : _signIn,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In'),
                ),
                const SizedBox(height: 16),

                // Social sign in
                OutlinedButton.icon(
                  onPressed: _signInGoogle,
                  icon: const Text('🔵', style: TextStyle(fontSize: 16)),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _signInApple,
                  icon: const Icon(Icons.apple, size: 20),
                  label: const Text('Continue with Apple'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: () => context.go(Routes.signup),
                    child: const Text('Don\'t have an account? Sign up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInWithEmail(_email.text.trim(), _pass.text);
      if (mounted) context.go(Routes.home);
    } catch (e) {
      setState(() { _error = 'Invalid email or password'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _signInGoogle() async {
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted) context.go(Routes.home);
    } catch (e) {
      setState(() { _error = 'Google sign-in failed'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _signInApple() async {
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInWithApple();
      if (mounted) context.go(Routes.home);
    } catch (e) {
      setState(() { _error = 'Apple sign-in failed'; });
    } finally {
      setState(() { _loading = false; });
    }
  }
}

// ─────────────────────────────────────────────────────────────
// SIGNUP SCREEN (stub)
// ─────────────────────────────────────────────────────────────

// lib/features/onboarding/screens/signup_screen.dart
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDE68A), Color(0xFFFCE7F3), Color(0xFFEDE9FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text('✨', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('Start your journey', style: Theme.of(context).textTheme.displaySmall),
                Text('Create your free account 🌱', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: BloomColors.stone)),
                const SizedBox(height: 32),

                TextField(controller: _name, decoration: const InputDecoration(hintText: 'Your name')),
                const SizedBox(height: 12),
                TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email address')),
                const SizedBox(height: 12),
                TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(hintText: 'Password (min. 8 characters)')),
                const SizedBox(height: 8),

                if (_error != null) Text(_error!, style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12)),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _loading ? null : _signUp,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Account 🌸'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty || _pass.text.length < 8) {
      setState(() { _error = 'Please fill all fields (password min. 8 chars)'; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
        email: _email.text.trim(),
        password: _pass.text,
        displayName: _name.text.trim(),
      );
      if (mounted) context.go(Routes.onboarding); // let them pick ADHD mode etc.
    } catch (e) {
      setState(() { _error = e.toString().replaceFirst('Exception: ', ''); });
    } finally {
      setState(() { _loading = false; });
    }
  }
}

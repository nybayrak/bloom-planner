// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:isar/isar.dart';

import '../db/isar_service.dart';
import '../db/models.dart';

// ── Auth state stream ─────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// ── Auth service ──────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  // ── Email / password ─────────────────────────────────────────

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);
    await _createLocalProfile(cred.user!, displayName);
    return cred;
  }

  // ── Google ───────────────────────────────────────────────────

  Future<UserCredential?> signInWithGoogle() async {
    final account = await _google.signIn();
    if (account == null) return null; // user cancelled

    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);
    await _createLocalProfileIfNeeded(cred.user!);
    return cred;
  }

  // ── Apple ────────────────────────────────────────────────────

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final cred = await _auth.signInWithCredential(oauthCredential);

    // Apple only sends name on first sign-in
    final name = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ');
    if (name.isNotEmpty) {
      await cred.user?.updateDisplayName(name);
    }
    await _createLocalProfileIfNeeded(cred.user!);
    return cred;
  }

  // ── Password reset ───────────────────────────────────────────

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  // ── Sign out ─────────────────────────────────────────────────

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
    await IsarService.clearAll();
  }

  // ── Delete account ───────────────────────────────────────────

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    await IsarService.clearAll();
  }

  // ── Local profile helpers ─────────────────────────────────────

  Future<void> _createLocalProfile(User user, String displayName) async {
    final profile = UserProfile()
      ..uid = user.uid
      ..displayName = displayName
      ..email = user.email ?? ''
      ..themePreference = ThemePreference.system
      ..seasonPreference = SeasonPreference.auto
      ..subscriptionTier = SubscriptionTier.free
      ..onboardingComplete = false
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await IsarService.write((db) => db.userProfiles.put(profile));
    await _seedAchievements(user.uid);
  }

  Future<void> _createLocalProfileIfNeeded(User user) async {
    final existing = await IsarService.db.userProfiles
        .where()
        .uidEqualTo(user.uid)
        .findFirst();
    if (existing == null) {
      await _createLocalProfile(
        user,
        user.displayName ?? user.email?.split('@').first ?? 'Planner',
      );
    }
  }

  /// Seed all achievement definitions on new account creation.
  Future<void> _seedAchievements(String uid) async {
    final achievements = [
      ('streak_3',    '3-Day Streak',      'Keep a habit 3 days in a row', '🌱'),
      ('streak_7',    '7-Day Streak',       'Keep a habit a full week',     '⭐'),
      ('streak_30',   '30-Day Champion',    '30 consecutive habit days',    '🏆'),
      ('goal_first',  'First Goal',         'Add your first goal',          '🎯'),
      ('habit_first', 'First Habit',        'Add your first habit',         '✨'),
      ('entry_first', 'Dear Diary',         'Write your first journal entry','📖'),
      ('mood_week',   'Mood Check-in',      'Log mood 7 days in a row',     '💭'),
      ('task_10',     'Getting Things Done','Complete 10 tasks',             '✅'),
      ('planner_pro', 'Power Planner',      'Use the app 30 days',           '🌟'),
    ];

    final list = achievements.map((a) => Achievement()
      ..uid = uid
      ..achievementId = a.$1
      ..title = a.$2
      ..description = a.$3
      ..badge = a.$4
      ..isEarned = false
      ..createdAt = DateTime.now()
    ).toList();

    await IsarService.write((db) => db.achievements.putAll(list));
  }
}

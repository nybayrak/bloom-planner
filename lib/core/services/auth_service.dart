import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../db/isar_service.dart';
import '../db/models.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      await _createOrUpdateProfile(result.user);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _createOrUpdateProfile(result.user);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _createOrUpdateProfile(result.user);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  static Future<void> _createOrUpdateProfile(User? user) async {
    if (user == null) return;
    final profile = UserProfile(
      id: user.uid,
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      avatarUrl: user.photoURL,
    );
    await IsarService.putUserProfile(profile);
    final existing = await IsarService.getAchievements();
    if (existing.isEmpty) {
      final list = [
        Achievement(id: const Uuid().v4(), title: 'Welcome!', description: 'Joined Bloom Planner', emoji: '🌸'),
      ];
      for (final a in list) { await IsarService.putAchievement(a); }
    }
  }
}

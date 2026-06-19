// lib/app/theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────
// BLOOM DESIGN TOKENS
// ─────────────────────────────────────────────────────────────

abstract class BloomColors {
  // ── Core brand ──────────────────────────────────────────────
  static const bloom    = Color(0xFFF472B6); // hot pink  — primary CTA
  static const petal    = Color(0xFFFCE7F3); // soft pink — light backgrounds
  static const lavender = Color(0xFFC084FC); // purple    — secondary accent
  static const mist     = Color(0xFFE0F2FE); // sky blue  — calm / health
  static const sage     = Color(0xFF86EFAC); // green     — success / done
  static const sun      = Color(0xFFFDE68A); // yellow    — warmth / wins
  static const peach    = Color(0xFFFED7AA); // orange    — streaks / warmth
  static const chalk    = Color(0xFFFAFAF9); // near-white — surface
  static const ink      = Color(0xFF1C1917); // near-black — primary text
  static const stone    = Color(0xFF78716C); // muted      — secondary text
  static const cloud    = Color(0xFFF5F5F4); // grey-50    — dividers

  // ── Semantic ─────────────────────────────────────────────────
  static const done   = sage;
  static const missed = Color(0xFFFCA5A5);
  static const todo   = sun;

  // ── Dark mode overrides ──────────────────────────────────────
  static const darkSurface = Color(0xFF1C1917);
  static const darkCard    = Color(0xFF292524);
  static const darkText    = Color(0xFFFAFAF9);

  // ── Category colours ─────────────────────────────────────────
  static const categoryColors = <String, Color>{
    'health':   mist,
    'family':   peach,
    'work':     lavender,
    'personal': petal,
    'fitness':  sage,
    'finance':  sun,
    'learning': Color(0xFFBFDBFE),
    'social':   Color(0xFFFBCFE8),
  };
}

abstract class BloomFonts {
  static const display    = 'PlayfairDisplay';
  static const handwriting = 'Caveat';
  static const body       = 'DMSans';
}

abstract class BloomRadius {
  static const sm   = Radius.circular(8);
  static const md   = Radius.circular(16);
  static const lg   = Radius.circular(24);
  static const xl   = Radius.circular(32);
  static const pill = Radius.circular(999);

  static const smBR = BorderRadius.all(sm);
  static const mdBR = BorderRadius.all(md);
  static const lgBR = BorderRadius.all(lg);
  static const xlBR = BorderRadius.all(xl);
  static const pillBR = BorderRadius.all(pill);
}

abstract class BloomShadows {
  static const card = [
    BoxShadow(
      color: Color(0x1AF472B6),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const float = [
    BoxShadow(
      color: Color(0x2EF472B6),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const soft = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────
// THEME DATA BUILDERS
// ─────────────────────────────────────────────────────────────

class BloomTheme {
  BloomTheme._();

  static ThemeData light() {
    const primary = BloomColors.bloom;
    const surface = BloomColors.chalk;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: BloomFonts.body,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: BloomColors.lavender,
        tertiary: BloomColors.sage,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: BloomColors.ink,
      ),

      // ── App bar ─────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: BloomColors.ink,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x1A000000),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: BloomFonts.display,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BloomColors.ink,
        ),
      ),

      // ── Scaffold ────────────────────────────────────────────
      scaffoldBackgroundColor: BloomColors.chalk,

      // ── Cards ───────────────────────────────────────────────
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BloomRadius.lgBR),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),

      // ── Input fields ────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BloomColors.cloud,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BloomRadius.lgBR,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BloomRadius.lgBR,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BloomRadius.lgBR,
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: const TextStyle(color: BloomColors.stone, fontSize: 14),
        labelStyle: const TextStyle(color: BloomColors.stone, fontSize: 14),
      ),

      // ── Elevated button ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BloomRadius.pillBR),
          textStyle: const TextStyle(
            fontFamily: BloomFonts.body,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── Text button ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: BloomFonts.body,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined button ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BloomRadius.pillBR),
        ),
      ),

      // ── Chip ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: BloomColors.petal,
        labelStyle: const TextStyle(
          fontFamily: BloomFonts.body,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BloomRadius.pillBR),
        side: BorderSide.none,
      ),

      // ── Bottom nav ──────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: BloomColors.petal,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: BloomFonts.body,
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : BloomColors.stone,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? primary : BloomColors.stone,
            size: 22,
          );
        }),
        elevation: 0,
        shadowColor: const Color(0x1A000000),
      ),

      // ── Dialog ──────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BloomRadius.xlBR),
        titleTextStyle: const TextStyle(
          fontFamily: BloomFonts.display,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BloomColors.ink,
        ),
      ),

      // ── Bottom sheet ────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: BloomRadius.xl,
            topRight: BloomRadius.xl,
          ),
        ),
        elevation: 0,
      ),

      // ── Switch ──────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : BloomColors.stone),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? BloomColors.petal : BloomColors.cloud),
      ),

      // ── Checkbox ────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : Colors.transparent),
        side: const BorderSide(color: BloomColors.cloud, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BloomRadius.smBR),
      ),

      // ── Text styles ─────────────────────────────────────────
      textTheme: _buildTextTheme(BloomColors.ink),

      // ── Divider ─────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: BloomColors.cloud,
        thickness: 1,
        space: 0,
      ),
    );
  }

  // ── DARK THEME ─────────────────────────────────────────────

  static ThemeData dark() {
    const primary = BloomColors.bloom;
    const surface = BloomColors.darkSurface;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: BloomFonts.body,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: BloomColors.lavender,
        tertiary: BloomColors.sage,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: BloomColors.darkText,
      ),

      scaffoldBackgroundColor: surface,

      cardTheme: CardTheme(
        color: BloomColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BloomRadius.lgBR),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: BloomColors.darkSurface,
        foregroundColor: BloomColors.darkText,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: BloomFonts.display,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BloomColors.darkText,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BloomColors.darkCard,
        indicatorColor: const Color(0x33F472B6),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: BloomFonts.body,
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : BloomColors.stone,
          );
        }),
      ),

      textTheme: _buildTextTheme(BloomColors.darkText),
    );
  }

  // ── SHARED TEXT THEME ──────────────────────────────────────

  static TextTheme _buildTextTheme(Color base) {
    return TextTheme(
      // Display sizes — Playfair Display
      displayLarge: TextStyle(
        fontFamily: BloomFonts.display, fontSize: 32,
        fontWeight: FontWeight.w700, color: base, letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: BloomFonts.display, fontSize: 26,
        fontWeight: FontWeight.w700, color: base,
      ),
      displaySmall: TextStyle(
        fontFamily: BloomFonts.display, fontSize: 22,
        fontWeight: FontWeight.w700, color: base,
      ),

      // Headline sizes — DM Sans bold
      headlineLarge: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 20,
        fontWeight: FontWeight.w700, color: base,
      ),
      headlineMedium: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 18,
        fontWeight: FontWeight.w700, color: base,
      ),
      headlineSmall: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 16,
        fontWeight: FontWeight.w700, color: base,
      ),

      // Title sizes — DM Sans medium
      titleLarge: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 16,
        fontWeight: FontWeight.w600, color: base,
      ),
      titleMedium: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 14,
        fontWeight: FontWeight.w600, color: base,
      ),
      titleSmall: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 12,
        fontWeight: FontWeight.w600, color: base,
      ),

      // Body sizes — DM Sans regular
      bodyLarge: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 16,
        fontWeight: FontWeight.w400, color: base, height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 14,
        fontWeight: FontWeight.w400, color: base, height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 12,
        fontWeight: FontWeight.w400, color: BloomColors.stone, height: 1.4,
      ),

      // Label / caption
      labelLarge: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 13,
        fontWeight: FontWeight.w600, color: base,
      ),
      labelMedium: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 11,
        fontWeight: FontWeight.w600, color: BloomColors.stone,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: BloomFonts.body, fontSize: 10,
        fontWeight: FontWeight.w500, color: BloomColors.stone,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SEASONAL THEMES
// ─────────────────────────────────────────────────────────────

enum BloomSeason { spring, summer, autumn, winter }

extension BloomSeasonExtension on BloomSeason {
  String get label => switch (this) {
    BloomSeason.spring => '🌸 Spring',
    BloomSeason.summer => '🌞 Summer',
    BloomSeason.autumn => '🍂 Autumn',
    BloomSeason.winter => '❄️ Winter',
  };

  LinearGradient get headerGradient => switch (this) {
    BloomSeason.spring => const LinearGradient(
        colors: [Color(0xFFFCE7F3), Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
    BloomSeason.summer => const LinearGradient(
        colors: [Color(0xFFFDE68A), Color(0xFFFCA5A5), Color(0xFFFED7AA)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
    BloomSeason.autumn => const LinearGradient(
        colors: [Color(0xFFFED7AA), Color(0xFFFCA5A5), Color(0xFFFBBF24)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
    BloomSeason.winter => const LinearGradient(
        colors: [Color(0xFFE0F2FE), Color(0xFFEDE9FE), Color(0xFFDBEAFE)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
  };

  List<String> get decorativeEmojis => switch (this) {
    BloomSeason.spring => ['🌸', '🦋', '🌷', '🌿', '🐝'],
    BloomSeason.summer => ['🌻', '🌊', '🍦', '☀️', '🌴'],
    BloomSeason.autumn => ['🍂', '🎃', '🍁', '🌾', '🦊'],
    BloomSeason.winter => ['❄️', '🌨️', '🕯️', '🍵', '⛄'],
  };
}

// ─────────────────────────────────────────────────────────────
// THEME MODE PROVIDER
// ─────────────────────────────────────────────────────────────

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('theme_mode') ?? 'system';
    state = switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}

// ─────────────────────────────────────────────────────────────
// SEASON PROVIDER
// ─────────────────────────────────────────────────────────────

final seasonProvider = StateNotifierProvider<SeasonNotifier, BloomSeason>(
  (ref) => SeasonNotifier(),
);

class SeasonNotifier extends StateNotifier<BloomSeason> {
  SeasonNotifier() : super(_currentSeason()) {
    _loadOverride();
  }

  static BloomSeason _currentSeason() {
    final m = DateTime.now().month;
    if (m >= 3 && m <= 5) return BloomSeason.spring;
    if (m >= 6 && m <= 8) return BloomSeason.summer;
    if (m >= 9 && m <= 11) return BloomSeason.autumn;
    return BloomSeason.winter;
  }

  Future<void> _loadOverride() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('season_override');
    if (stored != null) {
      state = BloomSeason.values.firstWhere(
        (s) => s.name == stored,
        orElse: _currentSeason,
      );
    }
  }

  Future<void> setSeason(BloomSeason? season) async {
    state = season ?? _currentSeason();
    final prefs = await SharedPreferences.getInstance();
    if (season == null) {
      await prefs.remove('season_override');
    } else {
      await prefs.setString('season_override', season.name);
    }
  }
}

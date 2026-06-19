// lib/core/services/quote_service.dart
//
// Daily motivational quotes. Rotate by day-of-year so the same
// quote appears all day long but changes at midnight.

class QuoteService {
  QuoteService._();

  static const _quotes = [
    ('Small steps every day lead to big changes every year.', '🌱'),
    ('You don\'t have to be perfect to be amazing.', '✨'),
    ('Progress, not perfection.', '🎯'),
    ('Every day is a fresh start.', '🌸'),
    ('Your only limit is you.', '💪'),
    ('Believe you can and you\'re halfway there.', '⭐'),
    ('Done is better than perfect.', '✅'),
    ('One habit at a time changes everything.', '🔥'),
    ('The secret to getting ahead is getting started.', '🚀'),
    ('You are stronger than you know.', '🦋'),
    ('Make today count.', '☀️'),
    ('Little by little, a little becomes a lot.', '🌼'),
    ('Be patient with yourself — growth takes time.', '🌿'),
    ('Celebrate every win, no matter how small.', '🏆'),
    ('Your future self is cheering you on.', '💫'),
    ('Rest if you must, but don\'t quit.', '🌙'),
    ('Today\'s effort is tomorrow\'s reward.', '🎁'),
    ('Consistency beats intensity every time.', '📊'),
    ('You\'ve got this — one day at a time.', '🌈'),
    ('Action is the antidote to anxiety.', '⚡'),
  ];

  static (String quote, String emoji) today() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final idx = dayOfYear % _quotes.length;
    return _quotes[idx];
  }
}

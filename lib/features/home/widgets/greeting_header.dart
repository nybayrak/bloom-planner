// lib/features/home/widgets/greeting_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.userName,
    required this.season,
  });

  final String userName;
  final BloomSeason season;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final gradient = season.headerGradient;
    final emojis   = season.decorativeEmojis;
    final dateStr  = DateFormat('EEEE · MMMM d').format(DateTime.now()).toUpperCase();

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      child: Stack(
        children: [
          // Decorative background blobs
          ...List.generate(3, (i) {
            final offsets = [
              const Offset(-20, -20),
              const Offset(260, 10),
              const Offset(140, -10),
            ];
            final sizes = [80.0, 60.0, 40.0];
            return Positioned(
              left: offsets[i].dx,
              top: offsets[i].dy,
              child: Container(
                width: sizes[i],
                height: sizes[i],
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: BloomFonts.body,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: BloomColors.stone,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_greeting, $userName! ${emojis.first}',
                          style: const TextStyle(
                            fontFamily: BloomFonts.display,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: BloomColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: BloomColors.bloom,
                      shape: BoxShape.circle,
                      boxShadow: BloomShadows.float,
                    ),
                    child: Center(
                      child: Text(
                        emojis[1],
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Quote strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.all(BloomRadius.md),
                  border: const Border(
                    left: BorderSide(color: BloomColors.bloom, width: 3),
                  ),
                ),
                child: const Text(
                  '"Small steps every day lead to big changes every year." 🌱',
                  style: TextStyle(
                    fontFamily: BloomFonts.handwriting,
                    fontSize: 12,
                    color: BloomColors.stone,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

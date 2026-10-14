
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';

class AIExplainScreen extends ConsumerWidget {
  const AIExplainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI decision trace')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2B2250),
                  CineAITheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4A3C70),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  color: Color(0xFFC4B5FD),
                  size: 34,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why this edit works',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'A transparent look at the decisions behind your video.',
                        style: TextStyle(
                          color: CineAITheme.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _buildTraceCard(
            'Highlight selection',
            'High motion peak and a big smile detected at 00:04.',
            'CONFIDENCE · 95%',
            Icons.local_fire_department_rounded,
            const Color(0xFFFB923C),
          ),
          _buildTraceCard(
            'Color grade recipe',
            'Applied a cinematic teal-and-orange look with a contrast boost.',
            'MODEL · COLORIST V1',
            Icons.palette_outlined,
            const Color(0xFF38BDF8),
          ),
          _buildTraceCard(
            'Music beat sync',
            'Cut points aligned with the detected 124 BPM audio beat markers.',
            'TRACK · ENERGETIC BEAT 01',
            Icons.graphic_eq_rounded,
            const Color(0xFFA78BFA),
          ),
        ],
      ),
    );
  }

  Widget _buildTraceCard(
    String title,
    String explanation,
    String meta,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: CineAITheme.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: CineAITheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                size: 17,
                color: CineAITheme.success,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            explanation,
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            meta,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/theme.dart';
import '../widgets/ai_explain_card.dart';
import '../widgets/cine_widgets.dart';

class AIExplainScreen extends ConsumerWidget {
  const AIExplainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI decision trace')),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 420),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 36,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              AppCard(
                padding: const EdgeInsets.all(18),
                borderColor: const Color(0xFF4A3C70),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2B2250),
                    CineAITheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: CineAITheme.accentGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: CineAITheme.glow(alpha: .3, blur: 16),
                      ),
                      child: const Icon(
                        Icons.psychology_alt_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
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
              const SizedBox(height: 18),
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
        ),
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
    return AIExplainCard(
      title: title,
      reason: explanation,
      confidence: meta,
      icon: icon,
      accentColor: color,
    );
  }
}
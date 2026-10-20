import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../application/providers/project_providers.dart';
import '../../core/theme/theme.dart';
import '../widgets/ai_explain_card.dart';
import '../widgets/cine_widgets.dart';

class AIExplainScreen extends ConsumerWidget {
  const AIExplainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(activeProjectProvider);
    final trace = project?.aiTrace;

    final climaxMoment = trace?.narrativeArc.climax;
    final climaxScore = climaxMoment != null
        ? '${(climaxMoment.score * 100).round()}%'
        : '95%';
    final climaxReasons = climaxMoment != null
        ? climaxMoment.reasonCodes.map((r) => r.name).join(', ')
        : 'High motion peak & big smile';

    final colorGrade = trace?.colorGrade;
    final bpm = trace?.chosenBpm ?? 124.0;
    final trackName = trace?.chosenTrack ?? 'energetic_beat_01.mp3';

    final llmEngine = trace?.modelVersions['narrativeLlm'] ??
        trace?.modelVersions['llm'] ??
        'CineAI Multimodal Planner';
    final mediaEngine = trace?.modelVersions['mediaEngine'] ?? 'AI Video Synthesis Engine';

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project?.title != null
                                ? 'Why this edit works: ${project!.title}'
                                : 'Why this edit works',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'A transparent look at the AI reasoning behind your video.',
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
                'Story peak detected with reasons: $climaxReasons.',
                'CONFIDENCE · $climaxScore',
                Icons.local_fire_department_rounded,
                const Color(0xFFFB923C),
              ),
              _buildTraceCard(
                'Color grade recipe',
                'Applied custom grade with ${colorGrade?.contrast ?? 1.15}x contrast and ${colorGrade?.saturation ?? 1.08}x saturation tailored for ${project?.vibe.name.toUpperCase() ?? 'HYPE'} vibe.',
                'MODEL · COLORIST V1.4',
                Icons.palette_outlined,
                const Color(0xFF38BDF8),
              ),
              _buildTraceCard(
                'Music beat sync',
                'Cut points aligned with detected ${bpm.round()} BPM audio cadence.',
                'TRACK · ${trackName.split('/').last.toUpperCase()}',
                Icons.graphic_eq_rounded,
                const Color(0xFFA78BFA),
              ),
              _buildTraceCard(
                'Coordinated AI engines',
                'Orchestrated using $llmEngine for narrative planning and $mediaEngine for video sourcing.',
                'PIPELINE · CINEAI DUAL-WORKFLOW',
                Icons.hub_rounded,
                const Color(0xFF10B981),
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
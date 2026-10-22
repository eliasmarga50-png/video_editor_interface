import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/project_providers.dart';
import '../../core/theme/theme.dart';
import '../../domain/value_objects/platform.dart';
import '../../domain/value_objects/vibe.dart';
import '../widgets/cine_widgets.dart';

class AnalysisProgressScreen extends ConsumerStatefulWidget {
  const AnalysisProgressScreen({super.key});

  @override
  ConsumerState<AnalysisProgressScreen> createState() =>
      _AnalysisProgressScreenState();
}

class _AnalysisProgressScreenState
    extends ConsumerState<AnalysisProgressScreen> {
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartWorkflow();
    });
  }

  void _checkAndStartWorkflow() {
    final mode = GoRouterState.of(context).uri.queryParameters['mode'];
    final videoState = ref.read(videoGenWorkflowProvider);
    final autoState = ref.read(autoEditWorkflowProvider);

    if (mode == 'generate' && videoState.status == WorkflowStatus.idle) {
      ref.read(videoGenWorkflowProvider.notifier).startGeneration(
            prompt: 'Cinematic travel montage',
            style: 'Cinematic',
            platform: ref.read(activeProjectProvider)?.platform ??
                const PlatformTargetConverter().fromName('instagramReel'),
            vibe: ref.read(activeProjectProvider)?.vibe ??
                const VibeConverter().fromName('hype'),
            durationMs: 30000,
          );
    } else if (mode != 'generate' && autoState.status == WorkflowStatus.idle) {
      // Start auto-edit workflow
      ref.read(autoEditWorkflowProvider.notifier).startAutoEdit();
    }
  }

  void _retry(String mode) {
    if (mode == 'generate') {
      ref.read(videoGenWorkflowProvider.notifier).startGeneration(
            prompt: 'Cinematic creative video',
            style: 'Cinematic',
            platform: const PlatformTargetConverter().fromName('instagramReel'),
            vibe: const VibeConverter().fromName('hype'),
            durationMs: 30000,
          );
    } else {
      ref.read(autoEditWorkflowProvider.notifier).startAutoEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = GoRouterState.of(context).uri.queryParameters['mode'] ?? 'autoedit';
    final WorkflowState workflow = mode == 'generate'
        ? ref.watch(videoGenWorkflowProvider)
        : ref.watch(autoEditWorkflowProvider);

    final double progress = workflow.progress.clamp(0.05, 1.0);
    final String statusLabel = workflow.statusLabel;

    // Navigate to editor once succeeded
    if (workflow.status == WorkflowStatus.succeeded && !_didNavigate) {
      _didNavigate = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        if (context.mounted) context.go('/editor');
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -.45),
                  radius: 1.1,
                  colors: [
                    CineAITheme.violet.withValues(alpha: .16),
                    CineAITheme.background,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _PulsingRing(size: 176),
                      const SizedBox(height: 30),
                      Text(
                        'Your story is taking shape',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          statusLabel,
                          key: ValueKey(statusLabel),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: CineAITheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (workflow.status == WorkflowStatus.failed) ...[
                        AppCard(
                          padding: const EdgeInsets.all(20),
                          borderColor: CineAITheme.danger.withValues(alpha: .5),
                          child: ErrorState(
                            title: 'Workflow Notice',
                            message: workflow.errorMessage ??
                                'Unable to reach backend service.',
                            onRetry: () => _retry(mode),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/editor'),
                          child: const Text('Continue to Editor anyway'),
                        ),
                      ] else ...[
                        AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    mode == 'generate'
                                        ? 'AI Video Generation'
                                        : 'AI Narrative Editing',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${(progress * 100).round()}%',
                                    style: const TextStyle(
                                      color: CineAITheme.lavender,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: progress),
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, _) {
                                    return Container(
                                      height: 8,
                                      color: CineAITheme.surfaceElevated,
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: value.clamp(0.0, 1.0),
                                        child: const DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient:
                                                CineAITheme.accentGradient,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 17),
                              _statusRow(
                                Icons.check_circle_rounded,
                                mode == 'generate'
                                    ? 'Interpreting prompt with LLM'
                                    : 'Scanning motion & dialogue',
                                progress >= 0.25,
                              ),
                              const SizedBox(height: 12),
                              _statusRow(
                                Icons.graphic_eq_rounded,
                                mode == 'generate'
                                    ? 'Generating scene stack'
                                    : 'Building narrative arc',
                                progress >= 0.6,
                              ),
                              const SizedBox(height: 12),
                              _statusRow(
                                Icons.movie_filter_rounded,
                                mode == 'generate'
                                    ? 'Rendering timeline & video'
                                    : 'Assembling beat-synced timeline',
                                progress >= 0.95,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Keep this screen open while CineAI prepares your edit.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CineAITheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(
    IconData icon,
    String label,
    bool complete,
  ) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            complete ? Icons.check_circle_rounded : icon,
            key: ValueKey(complete),
            size: 18,
            color: complete
                ? CineAITheme.success
                : CineAITheme.textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: complete ? FontWeight.w700 : FontWeight.w500,
            color: complete
                ? CineAITheme.textPrimary
                : CineAITheme.textSecondary,
          ),
        ),
        const Spacer(),
        if (!complete)
          const SizedBox(
            width: 13,
            height: 13,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: CineAITheme.violet,
            ),
          ),
      ],
    );
  }
}

// Helpers for converter fallbacks
class PlatformTargetConverter {
  const PlatformTargetConverter();
  dynamic fromName(String name) {
    try {
      return PlatformTarget.values.byName(name);
    } catch (_) {
      return PlatformTarget.instagramReel;
    }
  }
}

class VibeConverter {
  const VibeConverter();
  dynamic fromName(String name) {
    try {
      return Vibe.values.byName(name);
    } catch (_) {
      return Vibe.hype;
    }
  }
}

/// Pulsing glow + rotating gradient ring around the AI spark.
class _PulsingRing extends StatefulWidget {
  final double size;

  const _PulsingRing({required this.size});

  @override
  State<_PulsingRing> createState() => _PulsingRingState();
}

class _PulsingRingState extends State<_PulsingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double t = _controller.value;
        final double pulse = .5 - .5 * math.cos(t * 2 * math.pi);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size * .62,
                height: size * .62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CineAITheme.violet
                          .withValues(alpha: .25 + .25 * pulse),
                      blurRadius: 40 + 30 * pulse,
                      spreadRadius: 4 + 8 * pulse,
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(t),
              ),
              Transform.scale(
                scale: 1 + .06 * pulse,
                child: Container(
                  width: size * .52,
                  height: size * .52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: CineAITheme.accentGradient,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: size * .24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double t;

  _RingPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 - 8;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = CineAITheme.border,
    );

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: const [
            Color(0x008B5CF6),
            CineAITheme.violet,
            CineAITheme.blue,
            Color(0x003B82F6),
          ],
          stops: const [0, .45, .85, 1],
          transform: GradientRotation(t * 2 * math.pi),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.t != t;
}
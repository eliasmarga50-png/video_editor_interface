import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../widgets/cine_widgets.dart';

class AnalysisProgressScreen extends StatefulWidget {
  const AnalysisProgressScreen({super.key});

  @override
  State<AnalysisProgressScreen> createState() =>
      _AnalysisProgressScreenState();
}

class _AnalysisProgressScreenState
    extends State<AnalysisProgressScreen> {
  double progress = 0.3;
  String statusLabel =
      'Looking for the best smiles & motion...';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        progress = 0.7;
        statusLabel = 'Generating AI Narrative Arc...';
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      setState(() {
        progress = 1.0;
        statusLabel = 'Ready!';
      });

      context.go('/editor');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'AI analysis',
                                  style: TextStyle(
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
                                duration: const Duration(milliseconds: 500),
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
                              'Scanning highlights',
                              true,
                            ),
                            const SizedBox(height: 12),
                            _statusRow(
                              Icons.graphic_eq_rounded,
                              'Building a narrative',
                              progress >= .7,
                            ),
                            const SizedBox(height: 12),
                            _statusRow(
                              Icons.movie_filter_rounded,
                              'Preparing your timeline',
                              progress >= 1,
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
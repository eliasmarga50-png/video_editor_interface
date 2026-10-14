
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    gradient: CineAITheme.accentGradient,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: CineAITheme.violet.withValues(alpha: .28),
                        blurRadius: 35,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Your story is taking shape',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  statusLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: CineAITheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CineAITheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: CineAITheme.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'AI analysis',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: Color(0xFFC4B5FD),
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
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 7,
                              backgroundColor:
                                  CineAITheme.surfaceElevated,
                              color: CineAITheme.violet,
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
                      const SizedBox(height: 10),
                      _statusRow(
                        Icons.graphic_eq_rounded,
                        'Building a narrative',
                        progress >= .7,
                      ),
                      const SizedBox(height: 10),
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
    );
  }

  Widget _statusRow(
    IconData icon,
    String label,
    bool complete,
  ) {
    return Row(
      children: [
        Icon(
          complete ? Icons.check_circle_rounded : icon,
          size: 17,
          color: complete
              ? CineAITheme.success
              : CineAITheme.textSecondary,
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
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

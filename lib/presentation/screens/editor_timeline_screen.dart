
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';

class EditorTimelineScreen extends ConsumerWidget {
  const EditorTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekend in the mountains',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Draft project · 9:16 vertical',
              style: TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'AI decisions',
            icon: const Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFFC4B5FD),
            ),
            onPressed: () => context.push('/explain'),
          ),
          IconButton(
            tooltip: 'Export',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Exporting video with platform preset...',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B2940),
                    Color(0xFF111827),
                    Color(0xFF25213B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: CineAITheme.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 22,
                    left: 22,
                    child: _previewPill(
                      Icons.auto_awesome,
                      'AI COLOR GRADE',
                    ),
                  ),
                  Positioned(
                    top: 22,
                    right: 22,
                    child: _previewPill(
                      Icons.hd_rounded,
                      '1080P',
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 155,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF34506A),
                              Color(0xFF4B356C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .14),
                          ),
                        ),
                        child: const Icon(
                          Icons.landscape_rounded,
                          size: 56,
                          color: Color(0xFFC4D4E8),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'AI Video Preview',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Your edit, frame by frame',
                        style: TextStyle(
                          color: CineAITheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .25),
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 18,
                    left: 18,
                    right: 18,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 17,
                          color: CineAITheme.textSecondary,
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          '00:08',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '00:32',
                          style: TextStyle(
                            color: CineAITheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 20),
            decoration: const BoxDecoration(
              color: CineAITheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'AI highlight stack',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(
                      '3 clips · 00:32',
                      style: TextStyle(
                        color: CineAITheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.tune_rounded,
                      color: CineAITheme.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your best moments, arranged into a story',
                  style: TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 94,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildClipCard(
                        'Clip 01',
                        'HIGH MOTION',
                        const Color(0xFFFB923C),
                        Icons.directions_run_rounded,
                      ),
                      _buildClipCard(
                        'Clip 02',
                        'BIG SMILE',
                        const Color(0xFFFBBF24),
                        Icons.sentiment_satisfied_alt_rounded,
                      ),
                      _buildClipCard(
                        'Clip 03',
                        'AUDIO PEAK',
                        const Color(0xFFA78BFA),
                        Icons.graphic_eq_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _toolButton(Icons.content_cut_rounded, 'Trim'),
                    _toolButton(Icons.music_note_rounded, 'Audio'),
                    _toolButton(Icons.subtitles_rounded, 'Captions'),
                    _toolButton(Icons.palette_outlined, 'Color'),
                    _toolButton(
                      Icons.auto_awesome_rounded,
                      'AI Magic',
                      active: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .28),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color(0xFFC4B5FD),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClipCard(
    String title,
    String badge,
    Color badgeColor,
    IconData icon,
  ) {
    return Container(
      width: 132,
      margin: const EdgeInsets.only(right: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CineAITheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CineAITheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: badgeColor),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: .3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolButton(
    IconData icon,
    String label, {
    bool active = false,
  }) {
    return Column(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            gradient: active ? CineAITheme.accentGradient : null,
            color: active ? null : CineAITheme.surfaceElevated,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: active
                  ? Colors.transparent
                  : CineAITheme.border,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight:
                active ? FontWeight.w800 : FontWeight.w500,
            color: active
                ? const Color(0xFFC4B5FD)
                : CineAITheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

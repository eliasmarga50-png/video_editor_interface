import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../widgets/cine_widgets.dart';

class EditorTimelineScreen extends ConsumerWidget {
  const EditorTimelineScreen({super.key});

  // Timeline scale: 24 logical pixels per second, 32 seconds total.
  static const double _pxPerSecond = 24;
  static const int _totalSeconds = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool canPop = Navigator.of(context).canPop();
    final double topInset =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: canPop
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Center(
                  child: CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    size: 40,
                    overlay: true,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
              )
            : null,
        titleSpacing: canPop ? 4 : 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Vlog — Bali Sunset',
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
          CircleIconButton(
            icon: Icons.psychology_alt_rounded,
            size: 40,
            overlay: true,
            iconColor: CineAITheme.lavender,
            tooltip: 'AI decisions',
            onTap: () => context.push('/explain'),
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.ios_share_rounded,
            size: 40,
            overlay: true,
            tooltip: 'Export',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Exporting video with platform preset...',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _preview(topInset)),
          _panel(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Full-bleed vertical preview
  // ---------------------------------------------------------------------------
  Widget _preview(double topInset) {
    return Hero(
      tag: 'editor-preview',
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2A2350),
                Color(0xFF16233B),
                CineAITheme.background,
              ],
              stops: [0, .55, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.landscape_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: .08),
              ),
              Positioned(
                top: topInset + 8,
                left: 20,
                child: _previewPill(Icons.auto_awesome, 'AI COLOR GRADE'),
              ),
              Positioned(
                top: topInset + 8,
                right: 20,
                child: _previewPill(Icons.hd_rounded, '1080P'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .25),
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AI Video Preview',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your edit, frame by frame',
                    style: TextStyle(
                      color: CineAITheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(
                            height: 3,
                            color: Colors.white.withValues(alpha: .18),
                          ),
                          FractionallySizedBox(
                            widthFactor: .25,
                            child: Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                gradient: CineAITheme.accentGradient,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(
                          Icons.volume_up_rounded,
                          size: 17,
                          color: CineAITheme.textSecondary,
                        ),
                        SizedBox(width: 7),
                        Text(
                          '00:08',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '00:32',
                          style: TextStyle(
                            color: CineAITheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 64,
                child: _aiMagicFab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Floating "AI Magic" action (visual only, no route behind it).
  Widget _aiMagicFab() {
    return Container(
      decoration: BoxDecoration(
        gradient: CineAITheme.accentGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: CineAITheme.glow(alpha: .5, blur: 22),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'AI Magic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom panel: stack header, ruler + playhead timeline, tools
  // ---------------------------------------------------------------------------
  Widget _panel(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, bottomInset + 14),
      decoration: BoxDecoration(
        color: CineAITheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(top: BorderSide(color: CineAITheme.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .45),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CineAITheme.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your best moments, arranged into a story',
              style: TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _timeline(),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _toolButton(Icons.content_cut_rounded, 'Trim'),
                _toolButton(Icons.music_note_rounded, 'Audio'),
                _toolButton(Icons.subtitles_rounded, 'Captions'),
                _toolButton(Icons.palette_outlined, 'Color'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline() {
    const double contentWidth = _pxPerSecond * _totalSeconds;

    return SizedBox(
      height: 128,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                    width: contentWidth,
                    child: CustomPaint(painter: _RulerPainter()),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildClipCard(
                        'Clip 01',
                        'HIGH MOTION',
                        const Color(0xFFFB923C),
                        Icons.directions_run_rounded,
                        width: _pxPerSecond * 12,
                      ),
                      _buildClipCard(
                        'Clip 02',
                        'BIG SMILE',
                        const Color(0xFFFBBF24),
                        Icons.sentiment_satisfied_alt_rounded,
                        width: _pxPerSecond * 10,
                      ),
                      _buildClipCard(
                        'Clip 03',
                        'AUDIO PEAK',
                        const Color(0xFFA78BFA),
                        Icons.graphic_eq_rounded,
                        width: _pxPerSecond * 10,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 30,
                    width: contentWidth,
                    decoration: BoxDecoration(
                      color: CineAITheme.blue.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CineAITheme.blue.withValues(alpha: .3),
                      ),
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CustomPaint(painter: _WavePainter()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Playhead
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: const Alignment(-.45, 0),
                child: SizedBox(
                  width: 14,
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CineAITheme.violet.withValues(alpha: .7),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(width: 2, color: Colors.white),
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

  Widget _previewPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .32),
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
            color: CineAITheme.lavender,
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
    IconData icon, {
    double width = 132,
  }) {
    return Container(
      width: width - 4,
      height: 54,
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            badgeColor.withValues(alpha: .30),
            CineAITheme.surfaceElevated,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withValues(alpha: .6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: badgeColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Text(
            badge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: badgeColor,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .4,
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
        CircleIconButton(icon: icon, size: 46, active: active),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active
                ? CineAITheme.lavender
                : CineAITheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Time ruler: a tick every second, a label every two seconds.
class _RulerPainter extends CustomPainter {
  const _RulerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tick = Paint()
      ..color = CineAITheme.textSecondary.withValues(alpha: .6)
      ..strokeWidth = 1;

    for (int s = 0; s <= EditorTimelineScreen._totalSeconds; s++) {
      final double x = s * EditorTimelineScreen._pxPerSecond;
      final bool major = s % 2 == 0;

      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - (major ? 8 : 4)),
        tick,
      );

      if (major) {
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: '00:${s.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2 + 1, 0));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) => false;
}

/// Decorative audio waveform for the music track.
class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bar = Paint()
      ..color = CineAITheme.blue.withValues(alpha: .75)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final double midY = size.height / 2;

    for (double x = 4; x < size.width; x += 5) {
      final double amp =
          (.25 + .75 * (math.sin(x * .21).abs() * math.cos(x * .047).abs())) *
              (size.height / 2 - 4);
      canvas.drawLine(Offset(x, midY - amp), Offset(x, midY + amp), bar);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}
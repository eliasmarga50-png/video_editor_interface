import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../application/providers/project_providers.dart';
import '../../core/theme/theme.dart';
import '../../domain/entities/highlight_moment.dart';
import '../widgets/cine_widgets.dart';

class EditorTimelineScreen extends ConsumerStatefulWidget {
  const EditorTimelineScreen({super.key});

  @override
  ConsumerState<EditorTimelineScreen> createState() => _EditorTimelineScreenState();
}

class _EditorTimelineScreenState extends ConsumerState<EditorTimelineScreen> {
  // Timeline scale: 24 logical pixels per second
  static const double _pxPerSecond = 24;

  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  String? _loadedUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkVideoController();
  }

  void _checkVideoController() {
    final project = ref.read(activeProjectProvider);
    final videoUrl = project?.videoUrl;

    if (videoUrl != null && videoUrl != _loadedUrl && videoUrl.isNotEmpty) {
      _loadedUrl = videoUrl;
      _videoController?.dispose();

      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        }).catchError((_) {
          // If video failed to load, fallback to preview
        });

      _videoController?.addListener(() {
        if (!mounted) return;
        final playing = _videoController?.value.isPlaying ?? false;
        if (playing != _isPlaying) {
          setState(() => _isPlaying = playing);
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      setState(() => _isPlaying = !_isPlaying);
      return;
    }

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();
    final double topInset = MediaQuery.of(context).padding.top + kToolbarHeight;
    final project = ref.watch(activeProjectProvider);

    final title = project?.title ?? 'Travel Vlog — Bali Sunset';
    final platformName = project?.platform.name ?? '9:16 vertical';
    final vibeLabel = project?.vibe.label ?? 'Hype';
    final totalSeconds = (project?.targetLengthMs ?? 30000) ~/ 1000;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              '$vibeLabel · $platformName · ${totalSeconds}s',
              style: const TextStyle(
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
                SnackBar(
                  content: Text(
                    'Exporting "$title" in high resolution...',
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
          Expanded(child: _preview(topInset, project, totalSeconds)),
          _panel(context, project, totalSeconds),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Full-bleed video preview
  // ---------------------------------------------------------------------------
  Widget _preview(double topInset, ActiveProject? project, int totalSeconds) {
    final bool hasVideo =
        _videoController != null && _videoController!.value.isInitialized;

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
              if (hasVideo)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                )
              else
                Icon(
                  Icons.landscape_rounded,
                  size: 150,
                  color: Colors.white.withValues(alpha: .08),
                ),

              // Gradient scrim overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: .45),
                        Colors.transparent,
                        Colors.black.withValues(alpha: .6),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
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

              // Center play/pause control
              GestureDetector(
                onTap: _togglePlay,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .35),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .3),
                        ),
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    if (!hasVideo) ...[
                      const SizedBox(height: 16),
                      Text(
                        project?.title ?? 'AI Video Preview',
                        style: const TextStyle(
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
                  ],
                ),
              ),

              // Bottom timeline scrubber on video
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
                            widthFactor: hasVideo
                                ? (_videoController!.value.position.inMilliseconds /
                                        math.max(1, _videoController!.value.duration.inMilliseconds))
                                    .clamp(0.0, 1.0)
                                : 0.35,
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
                    Row(
                      children: [
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 17,
                          color: CineAITheme.textSecondary,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          hasVideo
                              ? _formatTime(_videoController!.value.position.inSeconds)
                              : '00:04',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(totalSeconds),
                          style: const TextStyle(
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

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // Floating "AI Magic" action
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
          onTap: () => context.push('/explain'),
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
  Widget _panel(BuildContext context, ActiveProject? project, int totalSeconds) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final moments = project?.aiTrace?.moments ?? const [];
    final clipCount = moments.isNotEmpty ? moments.length : 3;

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
                Text(
                  '$clipCount clips · ${_formatTime(totalSeconds)}',
                  style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your best moments, arranged into a story',
              style: TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _timeline(project, totalSeconds),
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

  Widget _timeline(ActiveProject? project, int totalSeconds) {
    final double contentWidth = math.max(320.0, _pxPerSecond * totalSeconds);
    final moments = project?.aiTrace?.moments;

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
                  SizedBox(
                    height: 24,
                    width: contentWidth,
                    child: CustomPaint(
                      painter: _RulerPainter(totalSeconds: totalSeconds, pxPerSecond: _pxPerSecond),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: moments != null && moments.isNotEmpty
                        ? moments.map((m) => _buildMomentClipCard(m, totalSeconds)).toList()
                        : [
                            _buildClipCard(
                              'Clip 01',
                              'HIGH MOTION',
                              const Color(0xFFFB923C),
                              Icons.directions_run_rounded,
                              width: _pxPerSecond * 10,
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

  Widget _buildMomentClipCard(HighlightMoment moment, int totalSeconds) {
    final durSec = (moment.endMs - moment.startMs) / 1000;
    final width = math.max(70.0, _pxPerSecond * durSec);

    final reason = moment.reasonCodes.isNotEmpty
        ? moment.reasonCodes.first.name.toUpperCase()
        : 'AI HIGHLIGHT';

    Color color;
    IconData icon;
    if (reason.contains('MOTION')) {
      color = const Color(0xFFFB923C);
      icon = Icons.directions_run_rounded;
    } else if (reason.contains('SMILE')) {
      color = const Color(0xFFFBBF24);
      icon = Icons.sentiment_satisfied_alt_rounded;
    } else if (reason.contains('AUDIO')) {
      color = const Color(0xFFA78BFA);
      icon = Icons.graphic_eq_rounded;
    } else {
      color = const Color(0xFF38BDF8);
      icon = Icons.auto_awesome_rounded;
    }

    return _buildClipCard(
      moment.clipId.replaceAll('_', ' ').toUpperCase(),
      reason,
      color,
      icon,
      width: width,
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
            color: active ? CineAITheme.lavender : CineAITheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Dynamic time ruler
class _RulerPainter extends CustomPainter {
  final int totalSeconds;
  final double pxPerSecond;

  const _RulerPainter({required this.totalSeconds, required this.pxPerSecond});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tick = Paint()
      ..color = CineAITheme.textSecondary.withValues(alpha: .6)
      ..strokeWidth = 1;

    for (int s = 0; s <= totalSeconds; s++) {
      final double x = s * pxPerSecond;
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
  bool shouldRepaint(covariant _RulerPainter oldDelegate) =>
      oldDelegate.totalSeconds != totalSeconds;
}

/// Decorative audio waveform
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
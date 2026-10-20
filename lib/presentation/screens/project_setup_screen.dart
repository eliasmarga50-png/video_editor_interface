import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';
import '../../application/providers/project_providers.dart';
import '../widgets/cine_widgets.dart';

class ProjectSetupScreen extends ConsumerStatefulWidget {
  const ProjectSetupScreen({super.key});

  @override
  ConsumerState<ProjectSetupScreen> createState() =>
      _ProjectSetupScreenState();
}

class _ProjectSetupScreenState
    extends ConsumerState<ProjectSetupScreen> {
  // Existing state (unchanged)
  Vibe selectedVibe = Vibe.hype;
  PlatformTarget selectedPlatform =
      PlatformTarget.instagramReel;
  int targetLengthMs = 30000;

  // Visual-only state for the new controls (not wired to any backend call)
  final TextEditingController _promptController = TextEditingController();
  String selectedStyle = 'Cinematic';
  String selectedVoice = _voices.first;

  static const List<String> _voices = [
    'Aria — Warm narrator',
    'Leo — Deep & cinematic',
    'Maya — Bright & upbeat',
    'No voiceover',
  ];

  static const List<(String, IconData)> _styles = [
    ('Cinematic', Icons.movie_filter_rounded),
    ('Anime', Icons.auto_awesome_rounded),
    ('Realistic', Icons.photo_camera_outlined),
    ('3D', Icons.view_in_ar_rounded),
    ('Watercolor', Icons.brush_rounded),
  ];

  static const List<String> _ratios = ['9:16', '1:1', '16:9'];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New project')),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 380),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 28,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Text(
                'Let’s shape your story',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Describe your idea and pick the look, format and feeling.',
                style: TextStyle(
                  color: CineAITheme.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('01', 'Describe your video'),
              const SizedBox(height: 12),
              _promptField(),
              const SizedBox(height: 26),
              _sectionTitle('02', 'Choose a style'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: _styles.map((s) {
                  return GradientChip(
                    label: s.$1,
                    icon: s.$2,
                    selected: selectedStyle == s.$1,
                    onTap: () => setState(() => selectedStyle = s.$1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),
              _sectionTitle('03', 'Aspect ratio'),
              const SizedBox(height: 12),
              _aspectSelector(),
              const SizedBox(height: 26),
              _sectionTitle('04', 'Duration'),
              const SizedBox(height: 12),
              _durationCard(),
              const SizedBox(height: 26),
              _sectionTitle('05', 'Voice'),
              const SizedBox(height: 12),
              _voiceDropdown(),
              const SizedBox(height: 26),
              _sectionTitle('06', 'Select platform'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: PlatformTarget.values.map((platform) {
                  return GradientChip(
                    label: _platformLabel(platform),
                    icon: _platformIcon(platform.name),
                    selected: selectedPlatform == platform,
                    onTap: () {
                      setState(() => selectedPlatform = platform);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),
              _sectionTitle('07', 'Choose your vibe'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: Vibe.values.map((vibe) {
                  return GradientChip(
                    label: vibe.label,
                    selected: selectedVibe == vibe,
                    onTap: () {
                      setState(() => selectedVibe = vibe);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              _vibeHint(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: CineAITheme.background,
          border: Border(top: BorderSide(color: CineAITheme.border)),
        ),
        child: SafeArea(
          top: false,
          child: GradientButton(
            label: 'Generate',
            icon: Icons.auto_awesome_rounded,
            onPressed: () {
              ref.read(videoGenWorkflowProvider.notifier).startGeneration(
                    prompt: _promptController.text.trim(),
                    style: selectedStyle,
                    platform: selectedPlatform,
                    vibe: selectedVibe,
                    durationMs: targetLengthMs,
                  );
              context.push('/analyzing?mode=generate');
            },
          ),
        ),
      ),
    );
  }

  Widget _promptField() {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: TextField(
        controller: _promptController,
        minLines: 4,
        maxLines: 6,
        maxLength: 300,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 15, height: 1.45),
        decoration: const InputDecoration(
          hintText: 'Describe your video...',
          filled: false,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          counterStyle: TextStyle(
            color: CineAITheme.textSecondary,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _aspectSelector() {
    final String current = selectedPlatform.aspectRatio;

    return Row(
      children: [
        for (int i = 0; i < _ratios.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: _aspectTile(_ratios[i], current == _ratios[i])),
        ],
      ],
    );
  }

  Widget _aspectTile(String ratio, bool selected) {
    late final double w;
    late final double h;
    switch (ratio) {
      case '9:16':
        w = 18;
        h = 32;
        break;
      case '1:1':
        w = 26;
        h = 26;
        break;
      default:
        w = 36;
        h = 20;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Reuse the existing platform state: pick the first platform that
        // uses this ratio (unless the current one already does).
        if (selectedPlatform.aspectRatio == ratio) return;
        setState(() {
          selectedPlatform = PlatformTarget.values.firstWhere(
            (p) => p.aspectRatio == ratio,
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          gradient: selected ? CineAITheme.accentGradient : null,
          color: selected ? null : CineAITheme.border,
          borderRadius: BorderRadius.circular(CineAITheme.cardRadius),
        ),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF241D40) : CineAITheme.surface,
            borderRadius: BorderRadius.circular(14.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1.8,
                    color: selected
                        ? CineAITheme.lavender
                        : CineAITheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ratio,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? CineAITheme.textPrimary
                      : CineAITheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _durationCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timelapse_rounded,
                color: Color(0xFFA78BFA),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Target duration',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: CineAITheme.violet.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${targetLengthMs ~/ 1000}s',
                  style: const TextStyle(
                    color: CineAITheme.lavender,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            min: 15000,
            max: 60000,
            divisions: 9,
            value: targetLengthMs.toDouble(),
            onChanged: (value) {
              setState(() => targetLengthMs = value.round());
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '15 seconds',
                style: TextStyle(
                  color: CineAITheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                '60 seconds',
                style: TextStyle(
                  color: CineAITheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _voiceDropdown() {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: selectedVoice,
      isExpanded: true,
      dropdownColor: CineAITheme.surfaceElevated,
      borderRadius: BorderRadius.circular(CineAITheme.buttonRadius),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: CineAITheme.textSecondary,
      ),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.record_voice_over_rounded,
          color: CineAITheme.lavender,
          size: 20,
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: CineAITheme.textPrimary,
      ),
      items: _voices
          .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() => selectedVoice = v);
      },
    );
  }

  Widget _vibeHint() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Row(
        key: ValueKey(selectedVibe),
        children: [
          Icon(
            _vibeIcon(selectedVibe.label),
            size: 16,
            color: CineAITheme.lavender,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _vibeDescription(selectedVibe.label),
              style: const TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String number, String title) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CineAITheme.violet.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: CineAITheme.lavender,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  String _platformLabel(PlatformTarget platform) {
    switch (platform) {
      case PlatformTarget.instagramReel:
        return 'Instagram Reel';
      case PlatformTarget.tiktok:
        return 'TikTok';
      case PlatformTarget.youtubeShort:
        return 'YouTube Short';
      case PlatformTarget.square:
        return 'Square';
      case PlatformTarget.cinematic:
        return 'Cinematic';
    }
  }

  IconData _platformIcon(String name) {
    final normalized = name.toLowerCase();

    if (normalized.contains('instagram')) {
      return Icons.camera_alt_outlined;
    }
    if (normalized.contains('tiktok')) {
      return Icons.music_note_rounded;
    }
    if (normalized.contains('youtube')) {
      return Icons.play_circle_outline_rounded;
    }
    return Icons.smartphone_rounded;
  }

  IconData _vibeIcon(String label) {
    final normalized = label.toLowerCase();

    if (normalized.contains('hype')) {
      return Icons.bolt_rounded;
    }
    if (normalized.contains('cinema')) {
      return Icons.local_movies_outlined;
    }
    if (normalized.contains('calm')) {
      return Icons.waves_rounded;
    }
    if (normalized.contains('travel')) {
      return Icons.explore_outlined;
    }
    return Icons.auto_awesome_rounded;
  }

  String _vibeDescription(String label) {
    final normalized = label.toLowerCase();

    if (normalized.contains('hype')) {
      return 'Fast cuts, energetic pacing and bold moments.';
    }
    if (normalized.contains('cinema')) {
      return 'Atmospheric pacing with a film-inspired mood.';
    }
    if (normalized.contains('calm')) {
      return 'Smooth transitions and a relaxed rhythm.';
    }
    if (normalized.contains('travel')) {
      return 'A sense of discovery, movement and place.';
    }
    return 'A consistent visual style tailored to your footage.';
  }
}
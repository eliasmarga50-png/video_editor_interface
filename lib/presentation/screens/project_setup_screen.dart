
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';

class ProjectSetupScreen extends ConsumerStatefulWidget {
  const ProjectSetupScreen({super.key});

  @override
  ConsumerState<ProjectSetupScreen> createState() =>
      _ProjectSetupScreenState();
}

class _ProjectSetupScreenState
    extends ConsumerState<ProjectSetupScreen> {
  Vibe selectedVibe = Vibe.hype;
  PlatformTarget selectedPlatform =
      PlatformTarget.instagramReel;
  int targetLengthMs = 30000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New project')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Let’s shape your story',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose where it will live and the feeling you want to create.',
            style: TextStyle(
              color: CineAITheme.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 25),
          _sectionTitle('01', 'Select platform'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: PlatformTarget.values.map((platform) {
              final selected = selectedPlatform == platform;

              return ChoiceChip(
                avatar: Icon(
                  _platformIcon(platform.name),
                  size: 16,
                  color: selected
                      ? Colors.white
                      : CineAITheme.textSecondary,
                ),
                label: Text(platform.name),
                selected: selected,
                onSelected: (_) {
                  setState(() => selectedPlatform = platform);
                },
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : CineAITheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
                side: BorderSide(
                  color: selected
                      ? CineAITheme.violet
                      : CineAITheme.border,
                ),
                backgroundColor: CineAITheme.surface,
                selectedColor: CineAITheme.violet,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          _sectionTitle('02', 'Choose your vibe'),
          const SizedBox(height: 12),
          ...Vibe.values.map((vibe) {
            final selected = selectedVibe == vibe;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 9),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF241D40)
                    : CineAITheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected
                      ? CineAITheme.violet
                      : CineAITheme.border,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 3,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CineAITheme.violet.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _vibeIcon(vibe.label),
                    color: const Color(0xFFC4B5FD),
                  ),
                ),
                title: Text(
                  vibe.label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  _vibeDescription(vibe.label),
                  style: const TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                trailing: Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? CineAITheme.violet
                      : CineAITheme.textSecondary,
                ),
                onTap: () {
                  setState(() => selectedVibe = vibe);
                },
              ),
            );
          }),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CineAITheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CineAITheme.border),
            ),
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
                    Text(
                      '${targetLengthMs ~/ 1000}s',
                      style: const TextStyle(
                        color: Color(0xFFC4B5FD),
                        fontWeight: FontWeight.w800,
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
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              gradient: CineAITheme.accentGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: CineAITheme.violet.withValues(alpha: .2),
                  blurRadius: 20,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/analyzing'),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Start AI analysis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 56),
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
              color: Color(0xFFC4B5FD),
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


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';

class AILabSettingsScreen extends ConsumerStatefulWidget {
  const AILabSettingsScreen({super.key});

  @override
  ConsumerState<AILabSettingsScreen> createState() =>
      _AILabSettingsScreenState();
}

class _AILabSettingsScreenState
    extends ConsumerState<AILabSettingsScreen> {
  bool autoHighlights = true;
  bool autoCaptions = true;
  bool autoColorGrade = true;
  double sensitivity = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Lab settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF29204A),
                  CineAITheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4A3C70),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: Color(0xFFC4B5FD),
                  size: 30,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your creative assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Choose what CineAI handles automatically.',
                        style: TextStyle(
                          color: CineAITheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const Text(
            'AUTOMATION',
            style: TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          _settingTile(
            icon: Icons.auto_awesome_rounded,
            title: 'Auto-pick highlights',
            subtitle: 'Detect motion peaks and expressive moments',
            value: autoHighlights,
            onChanged: (value) {
              setState(() => autoHighlights = value);
            },
          ),
          _settingTile(
            icon: Icons.subtitles_rounded,
            title: 'Auto-captions',
            subtitle: 'Generate word-by-word subtitles',
            value: autoCaptions,
            onChanged: (value) {
              setState(() => autoCaptions = value);
            },
          ),
          _settingTile(
            icon: Icons.palette_outlined,
            title: 'Automatic color grade',
            subtitle: 'Apply a look based on your selected vibe',
            value: autoColorGrade,
            onChanged: (value) {
              setState(() => autoColorGrade = value);
            },
          ),
          const SizedBox(height: 25),
          const Text(
            'DETECTION',
            style: TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: CineAITheme.surface,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: CineAITheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Highlight sensitivity',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      '${(sensitivity * 100).round()}%',
                      style: const TextStyle(
                        color: Color(0xFFC4B5FD),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Higher sensitivity detects more potential moments.',
                  style: TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Slider(
                  value: sensitivity,
                  onChanged: (value) {
                    setState(() => sensitivity = value);
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtle',
                      style: TextStyle(
                        color: CineAITheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'More moments',
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
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: CineAITheme.textSecondary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'These preferences control the AI editing experience on this screen.',
                  style: TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: CineAITheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CineAITheme.border),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.fromLTRB(14, 7, 12, 7),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CineAITheme.violet.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFC4B5FD),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

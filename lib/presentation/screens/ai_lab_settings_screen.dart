import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../domain/value_objects/user_role.dart';
import '../widgets/cine_widgets.dart';
import '../widgets/role_gate.dart';

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
              _profileHeader(),
              const SizedBox(height: 18),
              _statsRow(),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Automation',
                subtitle: 'Choose what CineAI handles automatically.',
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _settingTile(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Auto-pick highlights',
                      subtitle: 'Detect motion peaks and expressive moments',
                      value: autoHighlights,
                      onChanged: (value) {
                        setState(() => autoHighlights = value);
                      },
                    ),
                    _divider(),
                    _settingTile(
                      icon: Icons.subtitles_rounded,
                      title: 'Auto-captions',
                      subtitle: 'Generate word-by-word subtitles',
                      value: autoCaptions,
                      onChanged: (value) {
                        setState(() => autoCaptions = value);
                      },
                    ),
                    _divider(),
                    _settingTile(
                      icon: Icons.palette_outlined,
                      title: 'Automatic color grade',
                      subtitle: 'Apply a look based on your selected vibe',
                      value: autoColorGrade,
                      onChanged: (value) {
                        setState(() => autoColorGrade = value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Detection',
                subtitle: 'Fine-tune how much the AI picks up.',
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.all(17),
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
                            '${(sensitivity * 100).round()}%',
                            style: const TextStyle(
                              color: CineAITheme.lavender,
                              fontWeight: FontWeight.w800,
                            ),
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
              const SizedBox(height: 28),
              AppCard(
                onTap: _confirmSignOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: const Row(
                  children: [
                    Icon(Icons.logout_rounded, color: CineAITheme.danger, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                          color: CineAITheme.danger,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
        ),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CineAITheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CineAITheme.cardRadius),
        ),
        title: const Text('Sign out?'),
        content: const Text('You’ll need to sign in again to keep editing.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // The router redirect takes the user to the sign-in screen.
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  Widget _profileHeader() {
    final user = ref.watch(authControllerProvider).user;

    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: CineAITheme.accentGradient,
            boxShadow: CineAITheme.glow(alpha: .3, blur: 22),
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CineAITheme.surfaceElevated,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 46,
              color: CineAITheme.lavender,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          (user != null && user.name.isNotEmpty) ? user.name : 'Creator Studio',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          user?.email ?? '@cineai.creator',
          style: const TextStyle(
            color: CineAITheme.textSecondary,
            fontSize: 12.5,
          ),
        ),
        RoleGate(
          minRole: UserRole.pro,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: CineAITheme.accentGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsRow() {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _statCell('247', 'Videos generated'),
            const VerticalDivider(width: 1, thickness: 1),
            _statCell('12.4K', 'Views'),
            const VerticalDivider(width: 1, thickness: 1),
            _statCell('8.2K', 'Followers'),
          ],
        ),
      ),
    );
  }

  Widget _statCell(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (rect) =>
                CineAITheme.accentGradient.createShader(rect),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16);
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
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
          color: CineAITheme.lavender,
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
    );
  }
}
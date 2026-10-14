
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: CineAITheme.accentGradient,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.movie_filter_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            const Text('CineAI Studio'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'AI Lab settings',
            onPressed: () => context.push('/lab'),
            icon: const Icon(
              Icons.tune_rounded,
              color: CineAITheme.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF28204A),
                  Color(0xFF172C4A),
                  CineAITheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF51437C).withValues(alpha: .65),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFC4B5FD),
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'YOUR AI CREATIVE STUDIO',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Make your next\nvideo unforgettable.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Turn raw footage into scroll-stopping stories with '
                  'AI-powered editing.',
                  style: TextStyle(
                    color: CineAITheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/setup'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create a new project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CineAITheme.violet,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _sectionHeader(context, 'Quick actions', 'Pick your workflow'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Auto edit',
                  subtitle: 'Find the best moments',
                  colors: const [
                    CineAITheme.violet,
                    CineAITheme.blue,
                  ],
                  onTap: () => context.push('/setup'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionCard(
                  icon: Icons.movie_creation_outlined,
                  title: 'AI workspace',
                  subtitle: 'Tune your AI tools',
                  colors: const [
                    Color(0xFF0EA5E9),
                    Color(0xFF6366F1),
                  ],
                  onTap: () => context.push('/lab'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _sectionHeader(
            context,
            'Recent projects',
            'Your creative queue',
          ),
          const SizedBox(height: 14),
          _projectCard(
            context,
            icon: Icons.landscape_rounded,
            iconColor: const Color(0xFF67E8F9),
            title: 'Weekend in the mountains',
            detail: 'Vertical short · 00:32',
            status: 'DRAFT',
            onTap: () => context.push('/editor'),
          ),
          const SizedBox(height: 10),
          _projectCard(
            context,
            icon: Icons.directions_walk_rounded,
            iconColor: const Color(0xFFFBBF24),
            title: 'City moments',
            detail: 'Social reel · 00:18',
            status: 'READY TO EDIT',
            onTap: () => context.push('/editor'),
          ),
          const SizedBox(height: 28),
          _sectionHeader(
            context,
            'Made for creators',
            'Smart tools, less busywork',
          ),
          const SizedBox(height: 14),
          _featureRow(
            Icons.bolt_rounded,
            'Automatic highlight detection',
            'Finds movement, smiles and standout moments.',
          ),
          _featureRow(
            Icons.graphic_eq_rounded,
            'Beat-aware editing',
            'Helps cuts feel connected to your soundtrack.',
          ),
          _featureRow(
            Icons.color_lens_outlined,
            'One-tap color mood',
            'Give your footage a consistent visual tone.',
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            color: CineAITheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: CineAITheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: CineAITheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: CineAITheme.textSecondary,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String detail,
    required String status,
    required VoidCallback onTap,
  }) {
    return Material(
      color: CineAITheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CineAITheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 58,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 27),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: CineAITheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.more_horiz_rounded,
                    color: CineAITheme.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: const TextStyle(
                      color: Color(0xFFA5B4FC),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
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

  Widget _featureRow(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CineAITheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFA78BFA),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

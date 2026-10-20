import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/project_providers.dart';
import '../../core/theme/theme.dart';
import '../../domain/value_objects/platform.dart';
import '../../domain/value_objects/vibe.dart';
import '../widgets/cine_widgets.dart';

class _Sample {
  final String title;
  final String meta;
  final String duration;
  final List<Color> colors;
  final IconData icon;
  final String? badge;
  final String? heroTag;

  const _Sample({
    required this.title,
    required this.meta,
    required this.duration,
    required this.colors,
    required this.icon,
    this.badge,
    this.heroTag,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<_Sample> _templates = [
    _Sample(
      title: 'Cinematic Travel',
      meta: '15s · 9:16',
      duration: '0:15',
      colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
      icon: Icons.flight_takeoff_rounded,
      badge: 'HOT',
    ),
    _Sample(
      title: 'Neon Cyberpunk',
      meta: '12s · 9:16',
      duration: '0:12',
      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      icon: Icons.nightlife_rounded,
    ),
    _Sample(
      title: 'Product Drop',
      meta: '10s · 1:1',
      duration: '0:10',
      colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      icon: Icons.shopping_bag_outlined,
    ),
    _Sample(
      title: 'Morning Routine',
      meta: '20s · 9:16',
      duration: '0:20',
      colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
      icon: Icons.wb_sunny_outlined,
    ),
    _Sample(
      title: 'Anime Opening',
      meta: '15s · 16:9',
      duration: '0:15',
      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  // Empty on purpose: shows the "Continue Editing" empty state.
  static const List<_Sample> _draftSamples = [];

  static const List<_Sample> _projects = [
    _Sample(
      title: 'Travel Vlog — Bali Sunset',
      meta: 'Auto-edited · 9:16',
      duration: '0:15',
      colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
      icon: Icons.beach_access_rounded,
      badge: 'AUTO-EDIT',
      heroTag: 'editor-preview',
    ),
    _Sample(
      title: 'AI Short Story — Cyberpunk',
      meta: 'AI generated · 9:16',
      duration: '0:12',
      colors: [Color(0xFF8B5CF6), Color(0xFF0EA5E9)],
      icon: Icons.auto_stories_rounded,
      badge: 'AI GEN',
    ),
    _Sample(
      title: 'Product Launch — Sneaker Drop',
      meta: 'AI generated · 1:1',
      duration: '0:10',
      colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
      icon: Icons.shopping_bag_rounded,
      badge: 'AI GEN',
    ),
    _Sample(
      title: 'Daily Vlog — Morning Routine',
      meta: 'Auto-edited · 9:16',
      duration: '0:20',
      colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
      icon: Icons.wb_twilight_rounded,
      badge: 'AUTO-EDIT',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;

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
                boxShadow: CineAITheme.glow(alpha: .25, blur: 14),
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
          CircleIconButton(
            icon: Icons.tune_rounded,
            size: 40,
            tooltip: 'AI Lab settings',
            onTap: () => context.push('/lab'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 28 + bottomInset),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 420),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 36,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _hero(),
              const SizedBox(height: 26),
              _pad(
                const SectionHeader(
                  title: 'Choose your path',
                  subtitle: 'Two ways to make your next video',
                ),
              ),
              const SizedBox(height: 14),
              _pad(_paths(context, ref)),
              const SizedBox(height: 28),
              _LoadGate(
                placeholder: _skeleton(),
                builder: (context) => _content(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pad(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _hero() {
    return _pad(
      Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -60,
            top: -50,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      CineAITheme.violet.withValues(alpha: .30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()} 👋',
                style: const TextStyle(
                  color: CineAITheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Create stunning\nvideos '),
                    TextSpan(
                      text: 'with AI',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = CineAITheme.accentGradient.createShader(
                            const Rect.fromLTWH(0, 0, 170, 40),
                          ),
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 33,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Generate from a prompt, or let AI edit your footage.',
                style: TextStyle(
                  color: CineAITheme.textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paths(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PathCard(
              emoji: '✨',
              title: 'Generate with AI',
              subtitle: 'Type a prompt, get a video in seconds',
              badge: 'From scratch',
              colors: const [CineAITheme.violet, CineAITheme.blue],
              onTap: () => context.push('/setup'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PathCard(
              emoji: '🎬',
              title: 'Auto-Edit My Footage',
              subtitle: 'Upload raw clips, AI edits them for you',
              badge: 'Zero editing',
              colors: const [CineAITheme.blue, Color(0xFF22D3EE)],
              onTap: () {
                ref.read(autoEditWorkflowProvider.notifier).startAutoEdit(
                      title: 'Travel Adventure — Coastal Roads',
                      vibe: Vibe.travel,
                      platform: PlatformTarget.instagramReel,
                      targetLengthMs: 30000,
                    );
                context.push('/analyzing?mode=autoedit');
              },
            ),
          ),
        ],
      ),
    );
  }

  // Loading skeleton shown briefly before the carousels and grid appear.
  Widget _skeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pad(const ShimmerBox(width: 160, height: 20, radius: 8)),
        const SizedBox(height: 14),
        SizedBox(
          height: 196,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: const [
              ShimmerBox(width: 138, height: 196),
              SizedBox(width: 12),
              ShimmerBox(width: 138, height: 196),
              SizedBox(width: 12),
              ShimmerBox(width: 138, height: 196),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _pad(const ShimmerBox(width: 140, height: 20, radius: 8)),
        const SizedBox(height: 14),
        _pad(
          const Row(
            children: [
              Expanded(child: ShimmerBox(height: 200)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(height: 200)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, WidgetRef ref) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 420),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 36,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _trending(),
            const SizedBox(height: 28),
            _drafts(context, ref),
            const SizedBox(height: 28),
            _recent(context),
          ],
        ),
      ),
    );
  }

  Widget _trending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pad(
          const SectionHeader(
            title: 'Trending templates',
            subtitle: 'Popular looks creators are using',
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 196,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _templates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final _Sample t = _templates[index];
              return SizedBox(
                width: 138,
                child: VideoThumbCard(
                  title: t.title,
                  meta: t.meta,
                  colors: t.colors,
                  icon: t.icon,
                  badge: t.badge,
                  duration: t.duration,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _drafts(BuildContext context, WidgetRef ref) {
    final activeProject = ref.watch(activeProjectProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pad(
          const SectionHeader(
            title: 'Continue editing',
            subtitle: 'Pick up where you left off',
          ),
        ),
        const SizedBox(height: 14),
        if (activeProject != null)
          _pad(
            SizedBox(
              height: 196,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 154,
                    child: VideoThumbCard(
                      title: activeProject.title,
                      meta:
                          '${activeProject.targetLengthMs ~/ 1000}s · ${activeProject.platform.aspectRatio}',
                      colors: const [Color(0xFF8B5CF6), Color(0xFF0EA5E9)],
                      icon: Icons.movie_filter_rounded,
                      badge: 'ACTIVE DRAFT',
                      duration:
                          '0:${(activeProject.targetLengthMs ~/ 1000).toString().padLeft(2, '0')}',
                      heroTag: 'editor-preview',
                      onTap: () => context.push('/editor'),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          _pad(
            SizedBox(
              width: double.infinity,
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                child: EmptyState(
                  icon: Icons.video_library_outlined,
                  message:
                      'No drafts yet — your AI-edited projects will appear here',
                  ctaLabel: 'Auto-edit my footage',
                  onCta: () {
                    ref.read(autoEditWorkflowProvider.notifier).startAutoEdit();
                    context.push('/analyzing?mode=autoedit');
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _recent(BuildContext context) {
    return _pad(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent projects',
            subtitle: 'Your latest creations',
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _projects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 236,
            ),
            itemBuilder: (context, index) {
              final _Sample p = _projects[index];
              return VideoThumbCard(
                title: p.title,
                meta: p.meta,
                colors: p.colors,
                icon: p.icon,
                badge: p.badge,
                duration: p.duration,
                heroTag: p.heroTag,
                onTap: () => context.push('/editor'),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Shows [placeholder] (shimmer skeleton) briefly, then fades in [builder].
class _LoadGate extends StatefulWidget {
  final Widget placeholder;
  final WidgetBuilder builder;

  const _LoadGate({required this.placeholder, required this.builder});

  @override
  State<_LoadGate> createState() => _LoadGateState();
}

class _LoadGateState extends State<_LoadGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _ready
          ? KeyedSubtree(
              key: const ValueKey('ready'),
              child: widget.builder(context),
            )
          : KeyedSubtree(
              key: const ValueKey('loading'),
              child: widget.placeholder,
            ),
    );
  }
}
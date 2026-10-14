import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/theme.dart';

/// ---------------------------------------------------------------------------
/// AppCard — rounded, subtle border, soft shadow
/// ---------------------------------------------------------------------------
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final bool shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.gradient,
    this.color,
    this.borderColor,
    this.radius = CineAITheme.cardRadius,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? CineAITheme.surface) : null,
        gradient: gradient,
        borderRadius: r,
        border: Border.all(color: borderColor ?? CineAITheme.border),
        boxShadow: shadow ? CineAITheme.softShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: r,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: r,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// GradientButton — violet → blue, glow that intensifies on press
/// ---------------------------------------------------------------------------
class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;
  final bool glow;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expand = true,
    this.glow = true,
    this.height = 56,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? .97 : 1,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: widget.height,
            width: widget.expand ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              gradient: enabled ? CineAITheme.accentGradient : null,
              color: enabled ? null : CineAITheme.surfaceElevated,
              borderRadius: BorderRadius.circular(CineAITheme.buttonRadius),
              boxShadow: enabled && widget.glow
                  ? CineAITheme.glow(
                      alpha: _pressed ? .75 : .38,
                      blur: _pressed ? 34 : 22,
                    )
                  : const [],
            ),
            child: Row(
              mainAxisSize:
                  widget.expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 9),
                ],
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// GradientChip — gradient border when selected
/// ---------------------------------------------------------------------------
class GradientChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const GradientChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            gradient: selected ? CineAITheme.accentGradient : null,
            color: selected ? null : CineAITheme.border,
            borderRadius: BorderRadius.circular(CineAITheme.buttonRadius),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF241D40) : CineAITheme.surface,
              borderRadius: BorderRadius.circular(10.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: selected
                        ? CineAITheme.lavender
                        : CineAITheme.textSecondary,
                  ),
                  const SizedBox(width: 7),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? CineAITheme.textPrimary
                        : CineAITheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// PathCard — the dual-path entry card on Home
/// ---------------------------------------------------------------------------
class PathCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final List<Color> colors;
  final VoidCallback onTap;

  const PathCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderColor: colors.first.withValues(alpha: .38),
      gradient: LinearGradient(
        colors: [
          colors.first.withValues(alpha: .20),
          CineAITheme.surface,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withValues(alpha: .45),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .08),
                ),
                child: const Icon(
                  Icons.arrow_outward_rounded,
                  size: 16,
                  color: CineAITheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.first.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge.toUpperCase(),
              style: const TextStyle(
                color: CineAITheme.lavender,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ShimmerBox — loading placeholder
/// ---------------------------------------------------------------------------
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = CineAITheme.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CineAITheme.surface,
      highlightColor: const Color(0xFF2C364B),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// EmptyState — friendly icon + message + optional CTA
/// ---------------------------------------------------------------------------
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    CineAITheme.violet.withValues(alpha: .28),
                    CineAITheme.blue.withValues(alpha: .18),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: CineAITheme.violet.withValues(alpha: .35),
                ),
              ),
              child: Icon(icon, size: 28, color: CineAITheme.lavender),
            ),
            const SizedBox(height: 14),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: 16),
              GradientButton(
                label: ctaLabel!,
                onPressed: onCta,
                expand: false,
                glow: false,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ErrorState — message + retry
/// ---------------------------------------------------------------------------
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CineAITheme.danger.withValues(alpha: .12),
                border: Border.all(
                  color: CineAITheme.danger.withValues(alpha: .35),
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: CineAITheme.danger,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CircleIconButton — toolbar style (solid, gradient-active, or glass overlay)
/// ---------------------------------------------------------------------------
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final bool active;
  final bool overlay;
  final Color? iconColor;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.size = 44,
    this.active = false,
    this.overlay = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active ? CineAITheme.accentGradient : null,
        color: active
            ? null
            : (overlay
                ? Colors.black.withValues(alpha: .4)
                : CineAITheme.surfaceElevated),
        border: Border.all(
          color: active
              ? Colors.transparent
              : (overlay
                  ? Colors.white.withValues(alpha: .14)
                  : CineAITheme.border),
        ),
        boxShadow: active ? CineAITheme.glow(alpha: .3, blur: 16) : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: size * .45,
              color: iconColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// ---------------------------------------------------------------------------
/// SectionHeader — title, optional subtitle and trailing action
/// ---------------------------------------------------------------------------
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: CineAITheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// VideoThumbCard — gradient thumbnail, play overlay, optional Hero
/// Needs a bounded height from its parent (SizedBox / grid cell).
/// ---------------------------------------------------------------------------
class VideoThumbCard extends StatelessWidget {
  final String title;
  final String meta;
  final List<Color> colors;
  final IconData icon;
  final String? badge;
  final String? duration;
  final String? heroTag;
  final VoidCallback? onTap;

  const VideoThumbCard({
    super.key,
    required this.title,
    required this.meta,
    required this.colors,
    this.icon = Icons.movie_creation_outlined,
    this.badge,
    this.duration,
    this.heroTag,
    this.onTap,
  });

  Widget _pill(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color ?? Colors.black.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: .4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget thumb = ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(CineAITheme.cardRadius),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(.65, -.55),
            child: Icon(
              icon,
              size: 76,
              color: Colors.white.withValues(alpha: .22),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: .38),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: .38),
                border: Border.all(color: Colors.white.withValues(alpha: .28)),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (badge != null)
            Positioned(top: 8, left: 8, child: _pill(badge!)),
          if (duration != null)
            Positioned(bottom: 8, right: 8, child: _pill(duration!)),
        ],
      ),
    );

    if (heroTag != null) {
      thumb = Hero(tag: heroTag!, child: thumb);
    }

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: thumb),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
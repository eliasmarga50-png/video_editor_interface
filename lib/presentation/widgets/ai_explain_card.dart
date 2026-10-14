import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import 'cine_widgets.dart';

class AIExplainCard extends StatelessWidget {
  final String title;
  final String reason;
  final String confidence;
  final VoidCallback? onRegenerate;
  final IconData? icon;
  final Color accentColor;

  const AIExplainCard({
    super.key,
    required this.title,
    required this.reason,
    required this.confidence,
    this.onRegenerate,
    this.icon,
    this.accentColor = CineAITheme.lavender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: .10),
            CineAITheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: accentColor.withValues(alpha: .28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 11),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CineAITheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: CineAITheme.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reason,
              style: const TextStyle(
                color: CineAITheme.textSecondary,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                confidence,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
            ),
            if (onRegenerate != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onRegenerate,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                  ),
                  label: const Text('Regenerate'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
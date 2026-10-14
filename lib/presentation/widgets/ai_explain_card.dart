
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class AIExplainCard extends StatelessWidget {
  final String title;
  final String reason;
  final String confidence;
  final VoidCallback? onRegenerate;

  const AIExplainCard({
    super.key,
    required this.title,
    required this.reason,
    required this.confidence,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 16,
      ),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFC4B5FD),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: CineAITheme.violet.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  confidence,
                  style: const TextStyle(
                    color: Color(0xFFC4B5FD),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            reason,
            style: const TextStyle(
              color: CineAITheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          if (onRegenerate != null) ...[
            const SizedBox(height: 12),
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
    );
  }
}

import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF22222B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(confidence, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(reason, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
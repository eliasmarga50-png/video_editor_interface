import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIExplainScreen extends ConsumerWidget {
  const AIExplainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('AI Decision Trace', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTraceCard('Highlight Selection', '🔥 High motion peak & 😊 big smile detected at 00:04', 'Confidence: 95%'),
          _buildTraceCard('Color Grade Recipe', 'Applied Cinematic Teal & Orange LUT with contrast boost (1.3x)', 'Model: Colorist-v1'),
          _buildTraceCard('Music Beat-Sync', 'Snapped cuts to 124 BPM downsampled audio beat markers', 'Track: Energetic Beat 01'),
        ],
      ),
    );
  }

  Widget _buildTraceCard(String title, String explanation, String meta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF22222B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(explanation, style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 12),
          Text(meta, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}
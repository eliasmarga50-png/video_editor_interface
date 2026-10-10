import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AILabSettingsScreen extends ConsumerStatefulWidget {
  const AILabSettingsScreen({super.key});

  @override
  ConsumerState<AILabSettingsScreen> createState() => _AILabSettingsScreenState();
}

class _AILabSettingsScreenState extends ConsumerState<AILabSettingsScreen> {
  bool autoHighlights = true;
  bool autoCaptions = true;
  bool autoColorGrade = true;
  double sensitivity = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('AI Lab Settings', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Auto-pick Highlights', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Detect motion peaks & face energy', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: autoHighlights,
            activeThumbColor: const Color(0xFF8B5CF6),
            onChanged: (val) => setState(() => autoHighlights = val),
          ),
          SwitchListTile(
            title: const Text('Auto-captions (Subtitles)', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Speech-to-text word-by-word highlight', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: autoCaptions,
            activeThumbColor: const Color(0xFF8B5CF6),
            onChanged: (val) => setState(() => autoCaptions = val),
          ),
          SwitchListTile(
            title: const Text('Auto Color Grade', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Apply LUTs based on selected vibe', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: autoColorGrade,
            activeThumbColor: const Color(0xFF8B5CF6),
            onChanged: (val) => setState(() => autoColorGrade = val),
          ),
          const SizedBox(height: 24),
          const Text('Highlight Sensitivity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Slider(
            value: sensitivity,
            activeColor: const Color(0xFF8B5CF6),
            inactiveColor: const Color(0xFF22222B),
            onChanged: (val) => setState(() => sensitivity = val),
          ),
        ],
      ),
    );
  }
}
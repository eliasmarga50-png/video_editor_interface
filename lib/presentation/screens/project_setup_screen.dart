import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';

class ProjectSetupScreen extends ConsumerStatefulWidget {
  const ProjectSetupScreen({super.key});

  @override
  ConsumerState<ProjectSetupScreen> createState() => _ProjectSetupScreenState();
}

class _ProjectSetupScreenState extends ConsumerState<ProjectSetupScreen> {
  Vibe selectedVibe = Vibe.hype;
  PlatformTarget selectedPlatform = PlatformTarget.instagramReel;
  int targetLengthMs = 30000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Project Setup', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Select Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: PlatformTarget.values.map((p) {
              final isSelected = selectedPlatform == p;
              return ChoiceChip(
                label: Text(p.name),
                selected: isSelected,
                selectedColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFF1E1E24),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                onSelected: (_) => setState(() => selectedPlatform = p),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Choose Vibe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Vibe.values.map((v) {
              final isSelected = selectedVibe == v;
              return ChoiceChip(
                label: Text(v.label),
                selected: isSelected,
                selectedColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFF1E1E24),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                onSelected: (_) => setState(() => selectedVibe = v),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => context.push('/analyzing'),
            child: const Text('Start AI Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class AnalysisProgressScreen extends StatefulWidget {
  const AnalysisProgressScreen({super.key});

  @override
  State<AnalysisProgressScreen> createState() => _AnalysisProgressScreenState();
}

class _AnalysisProgressScreenState extends State<AnalysisProgressScreen> {
  double progress = 0.3;
  String statusLabel = 'Looking for the best smiles & motion...';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { progress = 0.7; statusLabel = 'Generating AI Narrative Arc...'; });
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() { progress = 1.0; statusLabel = 'Ready!'; });
        context.go('/editor');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF8B5CF6), strokeWidth: 4),
              const SizedBox(height: 32),
              Text(statusLabel, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFF1E1E24), color: const Color(0xFF8B5CF6)),
            ],
          ),
        ),
      ),
    );
  }
}
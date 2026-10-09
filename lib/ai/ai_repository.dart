import '../domain/entities/ai_edit_trace.dart';
import '../domain/entities/highlight_moment.dart'; // Import the true domain entity
import '../domain/value_objects/vibe.dart';
import '../domain/value_objects/platform.dart';
import 'analyzers/motion_analyzer.dart';
import 'highlighters/highlight_scorer.dart';
import 'planners/narrative_planner.dart';
import 'colorist/color_grader.dart';

class AIRepository {
  final MotionAnalyzer motionAnalyzer;
  final HighlightScorer highlightScorer;
  final NarrativePlanner narrativePlanner;
  final ColorGrader colorGrader;

  AIRepository({
    required this.motionAnalyzer,
    required this.highlightScorer,
    required this.narrativePlanner,
    required this.colorGrader,
  });

  Future<AIEditTrace> generateEditPlan({
    required List<String> clipPaths,
    required Vibe vibe,
    required PlatformTarget platform,
    required int targetLengthMs,
    required Function(String status, double progress) onProgress,
  }) async {
    onProgress('Analyzing clip motion & faces...', 0.2);
    await Future.delayed(const Duration(milliseconds: 400));

    final List<HighlightMoment> dummyMoments = [
      const HighlightMoment(clipId: 'clip_1', startMs: 1200, endMs: 4500, score: 0.92, reasonCodes: []),
      const HighlightMoment(clipId: 'clip_2', startMs: 500, endMs: 3800, score: 0.88, reasonCodes: []),
      const HighlightMoment(clipId: 'clip_1', startMs: 8000, endMs: 11000, score: 0.95, reasonCodes: []),
      const HighlightMoment(clipId: 'clip_3', startMs: 2000, endMs: 5000, score: 0.81, reasonCodes: []),
    ];

    onProgress('Assembling narrative arc...', 0.6);
    final arc = narrativePlanner.planArc(dummyMoments, targetLengthMs);

    onProgress('Applying AI Color Grading & Beat-Sync...', 0.85);
    final recipe = colorGrader.recipeForVibe(vibe);

    onProgress('Finalizing AI Trace...', 1.0);
    return AIEditTrace(
      moments: dummyMoments,
      chosenBpm: 124.0,
      chosenTrack: 'assets/audio/energetic_beat_01.mp3',
      narrativeArc: arc,
      colorGrade: recipe,
      modelVersions: const {'movenet': 'v1.2', 'yolov8n': '8.0.2', 'vosk': '0.3.48'},
      generatedAt: DateTime.now(),
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai/ai_repository.dart';
import '../../ai/analyzers/motion_analyzer.dart';
import '../../ai/highlighters/highlight_scorer.dart';
import '../../ai/planners/narrative_planner.dart';
import '../../ai/colorist/color_grader.dart';
import '../../domain/entities/ai_edit_trace.dart';
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository(
    motionAnalyzer: MotionAnalyzer(),
    highlightScorer: HighlightScorer(),
    narrativePlanner: NarrativePlanner(),
    colorGrader: ColorGrader(),
  );
});

class EditOrchestratorState {
  final bool isAnalyzing;
  final double progress;
  final String statusLabel;
  final AIEditTrace? trace;

  const EditOrchestratorState({
    this.isAnalyzing = false,
    this.progress = 0.0,
    this.statusLabel = '',
    this.trace,
  });

  EditOrchestratorState copyWith({bool? isAnalyzing, double? progress, String? statusLabel, AIEditTrace? trace}) {
    return EditOrchestratorState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      progress: progress ?? this.progress,
      statusLabel: statusLabel ?? this.statusLabel,
      trace: trace ?? this.trace,
    );
  }
}

class EditOrchestratorNotifier extends StateNotifier<EditOrchestratorState> {
  final AIRepository _aiRepository;

  EditOrchestratorNotifier(this._aiRepository) : super(const EditOrchestratorState());

  Future<void> runAutoEdit({
    required List<String> clipPaths,
    required Vibe vibe,
    required PlatformTarget platform,
    required int targetLengthMs,
  }) async {
    state = state.copyWith(isAnalyzing: true, progress: 0.0, statusLabel: 'Ingesting raw media...');

    try {
      final trace = await _aiRepository.generateEditPlan(
        clipPaths: clipPaths,
        vibe: vibe,
        platform: platform,
        targetLengthMs: targetLengthMs,
        onProgress: (status, prog) {
          state = state.copyWith(statusLabel: status, progress: prog);
        },
      );

      state = state.copyWith(isAnalyzing: false, progress: 1.0, statusLabel: 'Complete', trace: trace);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, statusLabel: 'Error: $e');
    }
  }
}

final editOrchestratorProvider = StateNotifierProvider<EditOrchestratorNotifier, EditOrchestratorState>((ref) {
  return EditOrchestratorNotifier(ref.watch(aiRepositoryProvider));
});
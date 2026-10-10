import '../../ai/ai_repository.dart';
import '../../domain/entities/ai_edit_trace.dart';
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';

class AutoEditUseCase {
  final AIRepository aiRepository;

  AutoEditUseCase(this.aiRepository);

  Future<AIEditTrace> execute({
    required List<String> clipPaths,
    required Vibe vibe,
    required PlatformTarget platform,
    required int targetLengthMs,
    required Function(String, double) onProgress,
  }) async {
    return await aiRepository.generateEditPlan(
      clipPaths: clipPaths,
      vibe: vibe,
      platform: platform,
      targetLengthMs: targetLengthMs,
      onProgress: onProgress,
    );
  }
}
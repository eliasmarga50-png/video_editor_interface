import '../entities/ai_edit_trace.dart';
import '../value_objects/vibe.dart';
import '../value_objects/platform.dart';

abstract class IAIRepository {
  Future<AIEditTrace> generateEditPlan({
    required List<String> clipPaths,
    required Vibe vibe,
    required PlatformTarget platform,
    required int targetLengthMs,
    required Function(String status, double progress) onProgress,
  });
}
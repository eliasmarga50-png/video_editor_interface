import '../value_objects/vibe.dart';
import '../value_objects/platform.dart';
import 'ai_edit_trace.dart';

class EditProject {
  final String id;
  final String title;
  final Vibe vibe;
  final PlatformTarget platform;
  final int targetLengthMs;
  final List<String> rawClipPaths;
  final AIEditTrace? aiEditTrace;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EditProject({
    required this.id,
    required this.title,
    required this.vibe,
    required this.platform,
    required this.targetLengthMs,
    required this.rawClipPaths,
    this.aiEditTrace,
    required this.createdAt,
    required this.updatedAt,
  });
}
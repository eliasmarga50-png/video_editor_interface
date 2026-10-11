import '../value_objects/vibe.dart';
import '../value_objects/platform.dart';

class Project {
  final String id;
  final String title;
  final Vibe vibe;
  final PlatformTarget platform;
  final int targetLengthMs;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.title,
    required this.vibe,
    required this.platform,
    required this.targetLengthMs,
    required this.createdAt,
    required this.updatedAt,
  });
}
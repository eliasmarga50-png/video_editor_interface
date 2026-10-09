import '../../domain/entities/ai_edit_trace.dart';

class AssemblerSegment {
  final String clipId;
  final int startMs;
  final int endMs;
  final String transitionType;

  const AssemblerSegment({
    required this.clipId,
    required this.startMs,
    required this.endMs,
    required this.transitionType,
  });
}

class TimelineAssembler {
  List<AssemblerSegment> assemble(NarrativeArc arc) {
    return [
      AssemblerSegment(clipId: arc.open.clipId, startMs: arc.open.startMs, endMs: arc.open.endMs, transitionType: 'fade'),
      AssemblerSegment(clipId: arc.build.clipId, startMs: arc.build.startMs, endMs: arc.build.endMs, transitionType: 'cut'),
      AssemblerSegment(clipId: arc.climax.clipId, startMs: arc.climax.startMs, endMs: arc.climax.endMs, transitionType: 'zoom'),
      AssemblerSegment(clipId: arc.close.clipId, startMs: arc.close.startMs, endMs: arc.close.endMs, transitionType: 'fade'),
    ];
  }
}
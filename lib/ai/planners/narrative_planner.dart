
import '../../domain/entities/highlight_moment.dart';
import '../../domain/entities/ai_edit_trace.dart';

class NarrativePlanner {
  NarrativeArc planArc(
    List<HighlightMoment> moments,
    int targetDurationMs,
  ) {
    moments.sort((a, b) => b.score.compareTo(a.score));

    // Fallback generation if pool is small
    final top = moments.isNotEmpty
        ? moments.first
        : HighlightMoment(
            clipId: 'default',
            startMs: 0,
            endMs: targetDurationMs,
            score: 1.0,
            reasonCodes: [],
          );

    return NarrativeArc(
      open: moments.isNotEmpty ? moments[0] : top,
      build: moments.length > 1 ? moments[1] : top,
      climax: moments.length > 2 ? moments[2] : top,
      close: moments.length > 3 ? moments[3] : top,
    );
  }
}


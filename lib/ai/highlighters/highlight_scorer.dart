import '../../domain/entities/highlight_moment.dart';
import '../../domain/value_objects/reason_code.dart';

class HighlightScorer {
  HighlightMoment scoreSegment({
    required String clipId,
    required int startMs,
    required int endMs,
    required double motionScore,
    required double faceEnergy,
    required double audioPeak,
  }) {
    final compositeScore = (motionScore * 0.4) + (faceEnergy * 0.4) + (audioPeak * 0.2);
    final reasons = <ReasonCode>[];
    if (motionScore > 0.6) reasons.add(ReasonCode.highMotion);
    if (faceEnergy > 0.6) reasons.add(ReasonCode.bigSmile);
    if (audioPeak > 0.7) reasons.add(ReasonCode.audioPeak);
    if (reasons.isEmpty) reasons.add(ReasonCode.beautifulLight);

    return HighlightMoment(
      clipId: clipId,
      startMs: startMs,
      endMs: endMs,
      score: compositeScore,
      reasonCodes: reasons,
    );
  }
}


class SpeechSegment {
final int startMs;
final int endMs;
final String transcript;

const SpeechSegment({required this.startMs, required this.endMs, required this.transcript});
}

class ClipAnalysis {
final String clipId;
final int durationMs;
final double motionScore;
final double faceEnergy;
final double brightnessScore;
final List sceneTags;
final List speechSegments;
final double highlightScore;
final int suggestedStart;
final int suggestedEnd;

const ClipAnalysis({
required this.clipId,
required this.durationMs,
required this.motionScore,
required this.faceEnergy,
required this.brightnessScore,
required this.sceneTags,
required this.speechSegments,
required this.highlightScore,
required this.suggestedStart,
required this.suggestedEnd,
});
}
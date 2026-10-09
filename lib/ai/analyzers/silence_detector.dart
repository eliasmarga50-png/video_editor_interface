class SilenceSegment {
  final int startMs;
  final int endMs;

  const SilenceSegment({required this.startMs, required this.endMs});
}

class SilenceDetector {
  Future<List<SilenceSegment>> findSilentRanges(String audioPath) async {
    // Simulated Silero VAD / FFmpeg silencedetect parse stub
    return [
      const SilenceSegment(startMs: 10000, endMs: 13500),
      const SilenceSegment(startMs: 24000, endMs: 26200),
    ];
  }
}
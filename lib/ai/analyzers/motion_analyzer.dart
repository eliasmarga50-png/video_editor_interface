import 'input_frame.dart';

class MotionAnalyzer {
  Future<double> calculateMotionMagnitude(List<InputFrame> frames) async {
    if (frames.length < 2) return 0.0;
    double totalDiff = 0.0;
    for (int i = 1; i < frames.length; i++) {
      final prev = frames[i - 1].bytes;
      final curr = frames[i].bytes;
      int diffSum = 0;
      int sampleCount = 0;
      for (int p = 0; p < curr.length; p += 16) {
        diffSum += (curr[p] - prev[p]).abs();
        sampleCount++;
      }
      totalDiff += (diffSum / sampleCount);
    }
    return (totalDiff / (frames.length - 1)) / 255.0;
  }
}
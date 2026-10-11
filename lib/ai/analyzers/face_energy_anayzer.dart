import 'input_frame.dart';

class FaceEnergyAnalyzer {
  Future<double> scoreSmilesAndAttention(List<InputFrame> frames) async {
    // Simulated BlazeFace & emotion scoring inference wrapper
    if (frames.isEmpty) return 0.0;
    return 0.75; 
  }
}
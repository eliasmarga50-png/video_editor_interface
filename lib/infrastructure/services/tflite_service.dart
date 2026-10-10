class TfliteService {
  bool _isInitialized = false;

  Future<void> initializeModels() async {
    if (_isInitialized) return;
    // Load movenet_thunder.tflite & blazeface.tflite interpreter buffers
    await Future.delayed(const Duration(milliseconds: 300));
    _isInitialized = true;
  }

  Future<List<double>> runInference(List<int> inputTensorShape) async {
    if (!_isInitialized) await initializeModels();
    return [0.85, 0.92, 0.78];
  }
}
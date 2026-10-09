class SubtitleItem {
  final int startMs;
  final int endMs;
  final String text;

  const SubtitleItem({required this.startMs, required this.endMs, required this.text});
}

class SubtitleGenerator {
  Future<List<SubtitleItem>> transcribe(String audioPath) async {
    // Whisper GGML offline speech-to-text transcription engine stub
    return [
      const SubtitleItem(startMs: 1200, endMs: 2400, text: 'Welcome to this incredible journey!'),
      const SubtitleItem(startMs: 2500, endMs: 4100, text: 'Look at that stunning view! 🔥'),
    ];
  }
}
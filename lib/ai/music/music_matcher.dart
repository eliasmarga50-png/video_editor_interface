import '../../domain/value_objects/vibe.dart';

class MusicMatcher {
  String matchTrackForVibe(Vibe vibe) {
    switch (vibe) {
      case Vibe.hype:
        return 'assets/audio/energetic_beat_01.mp3';
      case Vibe.chill:
        return 'assets/audio/lofi_chill_02.mp3';
      case Vibe.romantic:
        return 'assets/audio/acoustic_warmth_03.mp3';
      case Vibe.cinematic:
        return 'assets/audio/epic_orchestral_04.mp3';
      default:
        return 'assets/audio/upbeat_standard_05.mp3';
    }
  }
}
enum ReasonCode {
  highMotion,
  bigSmile,
  audioPeak,
  beautifulLight,
  speechEnergy,
  sceneVariety;

  String get description {
    switch (this) {
      case ReasonCode.highMotion: return '🔥 High motion peak detected';
      case ReasonCode.bigSmile: return '😊 Big smile & positive face energy';
      case ReasonCode.audioPeak: return '📈 Sharp audio volume peak';
      case ReasonCode.beautifulLight: return '🌅 Optimal scene brightness / lighting';
      case ReasonCode.speechEnergy: return '🗣️ High speech activity & clarity';
      case ReasonCode.sceneVariety: return '✨ Unique contextual scene content';
    }
  }
}
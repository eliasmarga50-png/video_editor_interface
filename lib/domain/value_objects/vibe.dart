enum Vibe {
  hype,
  chill,
  romantic,
  cinematic,
  travel,
  funny,
  inspirational;

  String get label {
    switch (this) {
      case Vibe.hype: return '🔥 Hype';
      case Vibe.chill: return '🧊 Chill';
      case Vibe.romantic: return '❤️ Romantic';
      case Vibe.cinematic: return '🎬 Cinematic';
      case Vibe.travel: return '✈️ Travel';
      case Vibe.funny: return '😂 Funny';
      case Vibe.inspirational: return '✨ Inspirational';
    }
  }
}
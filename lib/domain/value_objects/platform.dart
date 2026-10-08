enum PlatformTarget {
  instagramReel,
  tiktok,
  youtubeShort,
  square,
  cinematic;

  String get aspectRatio {
    switch (this) {
      case PlatformTarget.instagramReel:
      case PlatformTarget.tiktok:
      case PlatformTarget.youtubeShort:
        return '9:16';
      case PlatformTarget.square:
        return '1:1';
      case PlatformTarget.cinematic:
        return '16:9';
    }
  }
}
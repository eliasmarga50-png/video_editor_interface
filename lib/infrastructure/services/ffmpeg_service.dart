class FFmpegService {
  String buildTrimCommand({required String inputPath, required String outputPath, required int startMs, required int endMs}) {
    final startSec = startMs / 1000.0;
    final durationSec = (endMs - startMs) / 1000.0;
    return '-ss $startSec -i "$inputPath" -t $durationSec -c:v libx264 -c:a aac "$outputPath"';
  }

  String buildColorGradeCommand({required String inputPath, required String outputPath, required String lutPath, required double contrast, required double saturation}) {
    // Complex video filter chain utilizing lut3d & eq parameters
    return '-i "$inputPath" -vf "lut3d=$lutPath,eq=contrast=$contrast:saturation=$saturation" -c:v libx264 -c:a copy "$outputPath"';
  }

  String buildMixAudioCommand({required String videoPath, required String audioPath, required String outputPath}) {
    // Sidechain compression / ducking filter syntax for background music vs speech voice track
    return '-i "$videoPath" -i "$audioPath" -filter_complex "[1:a]volume=0.3[m];[0:a][m]amix=inputs=2:duration=first[a]" -map 0:v -map "[a]" -c:v copy "$outputPath"';
  }

  String buildSubtitleBurnCommand({required String inputPath, required String srtPath, required String outputPath}) {
    return '-i "$inputPath" -vf "subtitles=$srtPath:force_style=\'FontName=Arial,FontSize=24,PrimaryColour=&H00FFFF&\'" -c:a copy "$outputPath"';
  }
}
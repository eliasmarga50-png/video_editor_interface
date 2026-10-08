import '../value_objects/vibe.dart';

class GradeRecipe {
  final Vibe vibe;
  final String lutPath;
  final double contrast;
  final double saturation;
  final double temperature;
  final double grainAmount;

  const GradeRecipe({
    required this.vibe,
    required this.lutPath,
    required this.contrast,
    required this.saturation,
    required this.temperature,
    required this.grainAmount,
  });

  Map<String, dynamic> toJson() => {
    'vibe': vibe.name,
    'lutPath': lutPath,
    'contrast': contrast,
    'saturation': saturation,
    'temperature': temperature,
    'grainAmount': grainAmount,
  };

  factory GradeRecipe.fromJson(Map<String, dynamic> json) => GradeRecipe(
    vibe: Vibe.values.byName(json['vibe']),
    lutPath: json['lutPath'],
    contrast: json['contrast'],
    saturation: json['saturation'],
    temperature: json['temperature'],
    grainAmount: json['grainAmount'],
  );
}
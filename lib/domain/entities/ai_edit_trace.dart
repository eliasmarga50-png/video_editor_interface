import 'highlight_moment.dart';
import 'grade_recipe.dart';

class NarrativeArc {
  final HighlightMoment open;
  final HighlightMoment build;
  final HighlightMoment climax;
  final HighlightMoment close;

  const NarrativeArc({
    required this.open,
    required this.build,
    required this.climax,
    required this.close,
  });

  Map<String, dynamic> toJson() => {
    'open': open.toJson(),
    'build': build.toJson(),
    'climax': climax.toJson(),
    'close': close.toJson(),
  };

  factory NarrativeArc.fromJson(Map<String, dynamic> json) => NarrativeArc(
    open: HighlightMoment.fromJson(json['open']),
    build: HighlightMoment.fromJson(json['build']),
    climax: HighlightMoment.fromJson(json['climax']),
    close: HighlightMoment.fromJson(json['close']),
  );
}

class AIEditTrace {
  final List<HighlightMoment> moments;
  final double chosenBpm;
  final String chosenTrack;
  final NarrativeArc narrativeArc;
  final GradeRecipe colorGrade;
  final Map<String, String> modelVersions;
  final DateTime generatedAt;

  const AIEditTrace({
    required this.moments,
    required this.chosenBpm,
    required this.chosenTrack,
    required this.narrativeArc,
    required this.colorGrade,
    required this.modelVersions,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'moments': moments.map((e) => e.toJson()).toList(),
    'chosenBpm': chosenBpm,
    'chosenTrack': chosenTrack,
    'narrativeArc': narrativeArc.toJson(),
    'colorGrade': colorGrade.toJson(),
    'modelVersions': modelVersions,
    'generatedAt': generatedAt.toIso8601String(),
  };

  factory AIEditTrace.fromJson(Map<String, dynamic> json) => AIEditTrace(
    moments: (json['moments'] as List).map((e) => HighlightMoment.fromJson(e)).toList(),
    chosenBpm: json['chosenBpm'],
    chosenTrack: json['chosenTrack'],
    narrativeArc: NarrativeArc.fromJson(json['narrativeArc']),
    colorGrade: GradeRecipe.fromJson(json['colorGrade']),
    modelVersions: Map<String, String>.from(json['modelVersions']),
    generatedAt: DateTime.parse(json['generatedAt']),
  );
}
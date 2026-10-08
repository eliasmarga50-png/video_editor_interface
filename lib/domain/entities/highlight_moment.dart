import '../value_objects/reason_code.dart';

class HighlightMoment {
  final String clipId;
  final int startMs;
  final int endMs;
  final double score;
  final List<ReasonCode> reasonCodes;

  const HighlightMoment({
    required this.clipId,
    required this.startMs,
    required this.endMs,
    required this.score,
    required this.reasonCodes,
  });

  Map<String, dynamic> toJson() => {
    'clipId': clipId,
    'startMs': startMs,
    'endMs': endMs,
    'score': score,
    'reasonCodes': reasonCodes.map((e) => e.name).toList(),
  };

  factory HighlightMoment.fromJson(Map<String, dynamic> json) => HighlightMoment(
    clipId: json['clipId'],
    startMs: json['startMs'],
    endMs: json['endMs'],
    score: json['score'],
    reasonCodes: (json['reasonCodes'] as List).map((e) => ReasonCode.values.byName(e)).toList(),
  );
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../domain/entities/ai_edit_trace.dart';
import '../../domain/entities/grade_recipe.dart';
import '../../domain/entities/highlight_moment.dart';
import '../../domain/value_objects/platform.dart';
import '../../domain/value_objects/reason_code.dart';
import '../../domain/value_objects/vibe.dart';
import 'auth_providers.dart';

// -----------------------------------------------------------------------------
// Active Project Model
// -----------------------------------------------------------------------------
class ActiveProject {
  final String id;
  final String title;
  final Vibe vibe;
  final PlatformTarget platform;
  final int targetLengthMs;
  final String? videoUrl;
  final String? thumbnailUrl;
  final AIEditTrace? aiTrace;
  final List<String> clipUrls;
  final String? limitationsNotice;

  const ActiveProject({
    required this.id,
    required this.title,
    required this.vibe,
    required this.platform,
    required this.targetLengthMs,
    this.videoUrl,
    this.thumbnailUrl,
    this.aiTrace,
    this.clipUrls = const [],
    this.limitationsNotice,
  });

  ActiveProject copyWith({
    String? id,
    String? title,
    Vibe? vibe,
    PlatformTarget? platform,
    int? targetLengthMs,
    String? videoUrl,
    String? thumbnailUrl,
    AIEditTrace? aiTrace,
    List<String>? clipUrls,
    String? limitationsNotice,
  }) {
    return ActiveProject(
      id: id ?? this.id,
      title: title ?? this.title,
      vibe: vibe ?? this.vibe,
      platform: platform ?? this.platform,
      targetLengthMs: targetLengthMs ?? this.targetLengthMs,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      aiTrace: aiTrace ?? this.aiTrace,
      clipUrls: clipUrls ?? this.clipUrls,
      limitationsNotice: limitationsNotice ?? this.limitationsNotice,
    );
  }
}

final activeProjectProvider = StateProvider<ActiveProject?>((ref) => null);

// -----------------------------------------------------------------------------
// Workflow State
// -----------------------------------------------------------------------------
enum WorkflowStatus { idle, running, succeeded, failed }

class WorkflowState {
  final WorkflowStatus status;
  final double progress;
  final String statusLabel;
  final String? errorMessage;
  final ActiveProject? project;

  const WorkflowState({
    this.status = WorkflowStatus.idle,
    this.progress = 0.0,
    this.statusLabel = 'Initializing AI...',
    this.errorMessage,
    this.project,
  });

  WorkflowState copyWith({
    WorkflowStatus? status,
    double? progress,
    String? statusLabel,
    String? errorMessage,
    ActiveProject? project,
  }) {
    return WorkflowState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      statusLabel: statusLabel ?? this.statusLabel,
      errorMessage: errorMessage ?? this.errorMessage,
      project: project ?? this.project,
    );
  }
}

// -----------------------------------------------------------------------------
// Video Generation Workflow Notifier
// -----------------------------------------------------------------------------
class VideoGenWorkflowNotifier extends StateNotifier<WorkflowState> {
  final Ref _ref;

  VideoGenWorkflowNotifier(this._ref) : super(const WorkflowState());

  Timer? _pollTimer;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> startGeneration({
    required String prompt,
    required String style,
    required PlatformTarget platform,
    required Vibe vibe,
    required int durationMs,
  }) async {
    _pollTimer?.cancel();
    state = const WorkflowState(
      status: WorkflowStatus.running,
      progress: 0.15,
      statusLabel: 'Connecting to CineAI generation service...',
    );

    final api = _ref.read(authedApiProvider);
    final durationSeconds = durationMs ~/ 1000;

    try {
      final res = await api.post(
        '/api/v1/generate-video',
        json: {
          'prompt': prompt.trim().isEmpty ? 'Cinematic creative video' : prompt.trim(),
          'style': style,
          'platform': platform.name,
          'aspectRatio': platform.aspectRatio,
          'vibe': vibe.name,
          'durationSeconds': durationSeconds,
        },
      );

      if (res.statusCode != 200 && res.statusCode != 201 && res.statusCode != 202) {
        final Map<String, dynamic> err = _tryParseJson(res.body);
        final msg = err['message'] ?? err['error']?['message'] ?? 'Server error (${res.statusCode})';
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: msg.toString(),
        );
        return;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      final taskId = data['taskId']?.toString();

      if (taskId == null) {
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: 'Server did not return a valid taskId',
        );
        return;
      }

      _startPolling(taskId, prompt, platform, vibe, durationMs);
    } catch (e) {
      state = state.copyWith(
        status: WorkflowStatus.failed,
        errorMessage: 'Network error connecting to backend: $e',
      );
    }
  }

  void _startPolling(
    String taskId,
    String prompt,
    PlatformTarget platform,
    Vibe vibe,
    int durationMs,
  ) {
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 650), (timer) async {
      attempts++;
      if (attempts > 60) {
        timer.cancel();
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: 'Generation timed out. Please try again.',
        );
        return;
      }

      try {
        final api = _ref.read(authedApiProvider);
        final res = await api.get('/api/v1/generate-video/$taskId');

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body) as Map<String, dynamic>;
          final task = (body['data'] ?? body) as Map<String, dynamic>;
          final String status = (task['status'] ?? '').toString();
          final double progress = (task['progress'] as num?)?.toDouble() ?? 0.3;
          final String message = task['statusMessage']?.toString() ?? 'Processing video...';

          if (status == 'succeeded') {
            timer.cancel();
            final project = _buildProjectFromTask(task, prompt, platform, vibe, durationMs);
            _ref.read(activeProjectProvider.notifier).state = project;
            state = state.copyWith(
              status: WorkflowStatus.succeeded,
              progress: 1.0,
              statusLabel: 'Ready!',
              project: project,
            );
          } else if (status == 'failed') {
            timer.cancel();
            state = state.copyWith(
              status: WorkflowStatus.failed,
              errorMessage: task['error']?.toString() ?? 'Video generation failed.',
            );
          } else {
            state = state.copyWith(
              progress: progress.clamp(0.1, 0.95),
              statusLabel: message,
            );
          }
        }
      } catch (err) {
        // Continue polling despite occasional network hiccups
      }
    });
  }

  ActiveProject _buildProjectFromTask(
    Map<String, dynamic> task,
    String prompt,
    PlatformTarget platform,
    Vibe vibe,
    int durationMs,
  ) {
    final String taskId = task['taskId']?.toString() ?? 'task_gen';
    final String? outputUrl = task['outputUrl']?.toString();
    final String? thumbnailUrl = task['thumbnailUrl']?.toString();
    final String? limitations = task['limitationsNotice']?.toString();

    AIEditTrace? trace;
    if (task['aiTrace'] != null && task['aiTrace'] is Map) {
      try {
        trace = _parseTrace(task['aiTrace'] as Map<String, dynamic>, vibe);
      } catch (_) {}
    }

    final clipList = <String>[];
    if (task['clips'] is List) {
      for (final c in task['clips']) {
        if (c is Map && c['url'] != null) {
          clipList.add(c['url'].toString());
        }
      }
    }

    return ActiveProject(
      id: taskId,
      title: prompt.isEmpty ? 'AI Generated Project' : prompt,
      vibe: vibe,
      platform: platform,
      targetLengthMs: durationMs,
      videoUrl: outputUrl,
      thumbnailUrl: thumbnailUrl,
      aiTrace: trace,
      clipUrls: clipList,
      limitationsNotice: limitations,
    );
  }
}

final videoGenWorkflowProvider =
    StateNotifierProvider<VideoGenWorkflowNotifier, WorkflowState>(
  (ref) => VideoGenWorkflowNotifier(ref),
);

// -----------------------------------------------------------------------------
// Auto-Edit Workflow Notifier
// -----------------------------------------------------------------------------
class AutoEditWorkflowNotifier extends StateNotifier<WorkflowState> {
  final Ref _ref;

  AutoEditWorkflowNotifier(this._ref) : super(const WorkflowState());

  Timer? _pollTimer;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> startAutoEdit({
    String? title,
    Vibe vibe = Vibe.hype,
    PlatformTarget platform = PlatformTarget.instagramReel,
    int targetLengthMs = 30000,
    List<String> rawClipPaths = const [],
    String? transcript,
  }) async {
    _pollTimer?.cancel();
    state = const WorkflowState(
      status: WorkflowStatus.running,
      progress: 0.2,
      statusLabel: 'Submitting raw clips for AI analysis...',
    );

    final api = _ref.read(authedApiProvider);

    try {
      final res = await api.post(
        '/api/v1/auto-edit',
        json: {
          'title': title ?? 'Auto-Edited Story',
          'vibe': vibe.name,
          'platform': platform.name,
          'targetLengthMs': targetLengthMs,
          'rawClipPaths': rawClipPaths,
          'transcript': transcript,
        },
      );

      if (res.statusCode != 200 && res.statusCode != 201 && res.statusCode != 202) {
        final Map<String, dynamic> err = _tryParseJson(res.body);
        final msg = err['message'] ?? 'Failed to start auto-editing (${res.statusCode})';
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: msg.toString(),
        );
        return;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      final taskId = data['taskId']?.toString();

      if (taskId == null) {
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: 'Server did not return a valid taskId',
        );
        return;
      }

      _startPolling(taskId, title ?? 'Auto-Edited Story', platform, vibe, targetLengthMs);
    } catch (e) {
      state = state.copyWith(
        status: WorkflowStatus.failed,
        errorMessage: 'Network error connecting to backend: $e',
      );
    }
  }

  void _startPolling(
    String taskId,
    String title,
    PlatformTarget platform,
    Vibe vibe,
    int targetLengthMs,
  ) {
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 650), (timer) async {
      attempts++;
      if (attempts > 60) {
        timer.cancel();
        state = state.copyWith(
          status: WorkflowStatus.failed,
          errorMessage: 'Auto-editing timed out. Please try again.',
        );
        return;
      }

      try {
        final api = _ref.read(authedApiProvider);
        final res = await api.get('/api/v1/auto-edit/$taskId');

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body) as Map<String, dynamic>;
          final task = (body['data'] ?? body) as Map<String, dynamic>;
          final String status = (task['status'] ?? '').toString();
          final double progress = (task['progress'] as num?)?.toDouble() ?? 0.3;
          final String message = task['statusMessage']?.toString() ?? 'Auto-editing...';

          if (status == 'succeeded') {
            timer.cancel();
            final project = _buildProjectFromAutoEdit(task, title, platform, vibe, targetLengthMs);
            _ref.read(activeProjectProvider.notifier).state = project;
            state = state.copyWith(
              status: WorkflowStatus.succeeded,
              progress: 1.0,
              statusLabel: 'Ready!',
              project: project,
            );
          } else if (status == 'failed') {
            timer.cancel();
            state = state.copyWith(
              status: WorkflowStatus.failed,
              errorMessage: task['error']?.toString() ?? 'Auto-editing failed.',
            );
          } else {
            state = state.copyWith(
              progress: progress.clamp(0.1, 0.95),
              statusLabel: message,
            );
          }
        }
      } catch (_) {}
    });
  }

  ActiveProject _buildProjectFromAutoEdit(
    Map<String, dynamic> task,
    String title,
    PlatformTarget platform,
    Vibe vibe,
    int targetLengthMs,
  ) {
    final String taskId = task['taskId']?.toString() ?? 'task_auto';
    final String? outputUrl = task['outputVideoUrl']?.toString();
    final String? thumbnailUrl = task['thumbnailUrl']?.toString();

    AIEditTrace? trace;
    if (task['aiEditTrace'] != null && task['aiEditTrace'] is Map) {
      try {
        trace = _parseTrace(task['aiEditTrace'] as Map<String, dynamic>, vibe);
      } catch (_) {}
    }

    final clipList = <String>[];
    if (task['clips'] is List) {
      for (final c in task['clips']) {
        if (c is Map && c['url'] != null) {
          clipList.add(c['url'].toString());
        }
      }
    }

    return ActiveProject(
      id: taskId,
      title: title,
      vibe: vibe,
      platform: platform,
      targetLengthMs: targetLengthMs,
      videoUrl: outputUrl,
      thumbnailUrl: thumbnailUrl,
      aiTrace: trace,
      clipUrls: clipList,
    );
  }
}

final autoEditWorkflowProvider =
    StateNotifierProvider<AutoEditWorkflowNotifier, WorkflowState>(
  (ref) => AutoEditWorkflowNotifier(ref),
);

// -----------------------------------------------------------------------------
// Provider Status FutureProvider
// -----------------------------------------------------------------------------
final providerStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.watch(httpClientProvider);
  final res = await client.get(Uri.parse('${AppConfig.apiBaseUrl}/api/v1/providers'));
  if (res.statusCode == 200) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['data'] ?? body) as Map<String, dynamic>;
  }
  return {};
});

// Helper functions
Map<String, dynamic> _tryParseJson(String raw) {
  try {
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

AIEditTrace _parseTrace(Map<String, dynamic> json, Vibe fallbackVibe) {
  final momentsList = <HighlightMoment>[];
  if (json['moments'] is List) {
    for (final m in json['moments']) {
      if (m is Map<String, dynamic>) {
        final reasonCodes = <ReasonCode>[];
        if (m['reasonCodes'] is List) {
          for (final r in m['reasonCodes']) {
            try {
              reasonCodes.add(ReasonCode.values.byName(r.toString()));
            } catch (_) {
              reasonCodes.add(ReasonCode.highMotion);
            }
          }
        }

        momentsList.add(HighlightMoment(
          clipId: m['clipId']?.toString() ?? 'clip',
          startMs: (m['startMs'] as num?)?.toInt() ?? 0,
          endMs: (m['endMs'] as num?)?.toInt() ?? 4000,
          score: (m['score'] as num?)?.toDouble() ?? 0.9,
          reasonCodes: reasonCodes.isEmpty ? [ReasonCode.highMotion] : reasonCodes,
        ));
      }
    }
  }

  final defaultMoment = HighlightMoment(
    clipId: 'clip_default',
    startMs: 0,
    endMs: 4000,
    score: 0.9,
    reasonCodes: const [ReasonCode.highMotion],
  );

  NarrativeArc arc;
  if (json['narrativeArc'] is Map<String, dynamic>) {
    final arcMap = json['narrativeArc'] as Map<String, dynamic>;
    arc = NarrativeArc(
      open: arcMap['open'] != null ? HighlightMoment.fromJson(arcMap['open']) : defaultMoment,
      build: arcMap['build'] != null ? HighlightMoment.fromJson(arcMap['build']) : defaultMoment,
      climax: arcMap['climax'] != null ? HighlightMoment.fromJson(arcMap['climax']) : defaultMoment,
      close: arcMap['close'] != null ? HighlightMoment.fromJson(arcMap['close']) : defaultMoment,
    );
  } else {
    arc = NarrativeArc(
      open: momentsList.isNotEmpty ? momentsList[0] : defaultMoment,
      build: momentsList.length > 1 ? momentsList[1] : defaultMoment,
      climax: momentsList.length > 2 ? momentsList[2] : defaultMoment,
      close: momentsList.length > 3 ? momentsList[3] : defaultMoment,
    );
  }

  GradeRecipe recipe;
  if (json['colorGrade'] is Map<String, dynamic>) {
    final cg = json['colorGrade'] as Map<String, dynamic>;
    Vibe v;
    try {
      v = Vibe.values.byName(cg['vibe']?.toString() ?? '');
    } catch (_) {
      v = fallbackVibe;
    }

    recipe = GradeRecipe(
      vibe: v,
      lutPath: cg['lutPath']?.toString() ?? 'assets/luts/cinematic_teal_orange.cube',
      contrast: (cg['contrast'] as num?)?.toDouble() ?? 1.15,
      saturation: (cg['saturation'] as num?)?.toDouble() ?? 1.08,
      temperature: (cg['temperature'] as num?)?.toDouble() ?? 0.05,
      grainAmount: (cg['grainAmount'] as num?)?.toDouble() ?? 0.04,
    );
  } else {
    recipe = GradeRecipe(
      vibe: fallbackVibe,
      lutPath: 'assets/luts/cinematic_teal_orange.cube',
      contrast: 1.15,
      saturation: 1.08,
      temperature: 0.05,
      grainAmount: 0.04,
    );
  }

  return AIEditTrace(
    moments: momentsList.isNotEmpty ? momentsList : [defaultMoment],
    chosenBpm: (json['chosenBpm'] as num?)?.toDouble() ?? 124.0,
    chosenTrack: json['chosenTrack']?.toString() ?? 'assets/audio/energetic_beat_01.mp3',
    narrativeArc: arc,
    colorGrade: recipe,
    modelVersions: json['modelVersions'] is Map
        ? Map<String, String>.from((json['modelVersions'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())))
        : {'cineai': 'v1.0'},
    generatedAt: json['generatedAt'] != null
        ? DateTime.tryParse(json['generatedAt'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

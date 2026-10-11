// GENERATED CODE - MANUAL STUB
part of 'app_database.dart';

class ProjectData {
  final int id;
  final String title;
  final String vibe;
  final String platform;
  final int targetLengthMs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectData({
    required this.id,
    required this.title,
    required this.vibe,
    required this.platform,
    required this.targetLengthMs,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ProjectsTableCompanion extends UpdateCompanion<ProjectData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> vibe;
  final Value<String> platform;
  final Value<int> targetLengthMs;

  const ProjectsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.vibe = const Value.absent(),
    this.platform = const Value.absent(),
    this.targetLengthMs = const Value.absent(),
  });

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    final map = <String, Expression<Object>>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (vibe.present) {
      map['vibe'] = Variable<String>(vibe.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (targetLengthMs.present) {
      map['target_length_ms'] = Variable<int>(targetLengthMs.value);
    }
    return map;
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(super.e);

  $ProjectsTableTable get projectsTable => $ProjectsTableTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [projectsTable];
}

class $ProjectsTableTable extends ProjectsTable
    with TableInfo<$ProjectsTableTable, ProjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  $ProjectsTableTable(this.attachedDatabase);

  @override
  List<GeneratedColumn> get $columns => [];

  @override
  String get actualTableName => 'projects_table';

  @override
  String get tableName => actualTableName;

  @override
  $ProjectsTableTable createAlias(String alias) =>
      $ProjectsTableTable(attachedDatabase);

  @override
  ProjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProjectData(
      id: data['id'] as int? ?? 0,
      title: data['title'] as String? ?? '',
      vibe: data['vibe'] as String? ?? '',
      platform: data['platform'] as String? ?? '',
      targetLengthMs: data['target_length_ms'] as int? ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
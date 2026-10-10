import '../../domain/entities/project.dart' as domain;
import '../../domain/value_objects/vibe.dart';
import '../../domain/value_objects/platform.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart';

class ProjectRepositoryImpl {
  final AppDatabase db;

  ProjectRepositoryImpl(this.db);

  Future<List<domain.Project>> getProjects() async {
    final rows = await db.getAllProjects();
    return rows.map((ProjectData row) {
      return domain.Project(
        id: row.id.toString(),
        title: row.title,
        vibe: Vibe.values.firstWhere(
          (e) => e.name == row.vibe,
          orElse: () => Vibe.values.first,
        ),
        platform: PlatformTarget.values.firstWhere(
          (e) => e.name == row.platform,
          orElse: () => PlatformTarget.values.first,
        ),
        targetLengthMs: row.targetLengthMs,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();
  }

  Future<int> createProject(domain.Project project) async {
    return await db.insertProject(
      ProjectsTableCompanion(
        title: Value(project.title),
        vibe: Value(project.vibe.name),
        platform: Value(project.platform.name),
        targetLengthMs: Value(project.targetLengthMs),
      ),
    );
  }
}
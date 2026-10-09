import '../entities/edit_project.dart';

abstract class IProjectRepository {
  Future<List<EditProject>> getAllProjects();
  Future<EditProject?> getProjectById(String id);
  Future<void> saveProject(EditProject project);
  Future<void> deleteProject(String id);
}
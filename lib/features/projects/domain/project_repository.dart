import 'project.dart';

abstract interface class ProjectRepository {
  Stream<List<Project>> watchProjects();
  Future<void> createProject(String name, {required String requestId});
}

import '../../dependencies/domain/dependency_graph.dart';
import 'task.dart';

abstract interface class TaskRepository {
  List<Task> tasksFor(String projectId);
  List<DependencyEdge> dependenciesFor(String projectId);
  void createTask(String projectId, String title);
  void changeStatus(String projectId, String taskId, TaskStatus status);
}

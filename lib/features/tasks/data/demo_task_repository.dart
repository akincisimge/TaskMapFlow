import '../../../core/errors/app_exception.dart';
import '../../dependencies/domain/dependency_graph.dart';
import '../domain/task.dart';
import '../domain/task_repository.dart';

class DemoTaskRepository implements TaskRepository {
  final _tasks = <Task>[
    const Task(
      id: 'vision',
      projectId: 'demo',
      title: 'Ürün vizyonunu netleştir',
      status: TaskStatus.done,
      assignee: 'Team Endura',
    ),
    const Task(
      id: 'design',
      projectId: 'demo',
      title: 'Ekran taslaklarını hazırla',
      status: TaskStatus.inProgress,
      assignee: 'Team Endura',
    ),
    const Task(
      id: 'implement',
      projectId: 'demo',
      title: 'Görev yönetimini geliştir',
      assignee: 'Team Endura',
    ),
  ];
  final _edges = <DependencyEdge>[
    const DependencyEdge('vision', 'design'),
    const DependencyEdge('design', 'implement'),
  ];
  int _nextId = 0;
  @override
  List<Task> tasksFor(String projectId) =>
      List.unmodifiable(_tasks.where((t) => t.projectId == projectId));
  @override
  List<DependencyEdge> dependenciesFor(String projectId) {
    final ids = tasksFor(projectId).map((t) => t.id).toSet();
    return List.unmodifiable(
      _edges.where(
        (e) => ids.contains(e.predecessorId) && ids.contains(e.successorId),
      ),
    );
  }

  @override
  void createTask(String projectId, String title) {
    if (title.trim().isEmpty || title.trim().length > 120) {
      throw const AppException('Görev başlığı 1-120 karakter olmalı.');
    }
    _tasks.add(
      Task(id: 'task-${++_nextId}', projectId: projectId, title: title.trim()),
    );
  }

  @override
  void changeStatus(String projectId, String taskId, TaskStatus status) {
    final tasks = tasksFor(projectId);
    final index = _tasks.indexWhere(
      (t) => t.id == taskId && t.projectId == projectId,
    );
    if (index < 0) throw const AppException('Görev bulunamadı.');
    final edges = dependenciesFor(projectId);
    if (status != TaskStatus.todo &&
        edges.any(
          (e) =>
              e.successorId == taskId &&
              tasks.any(
                (t) => t.id == e.predecessorId && t.status != TaskStatus.done,
              ),
        )) {
      throw const AppException('Önce ön koşul görevlerini tamamlayın.');
    }
    if (_tasks[index].status == TaskStatus.done &&
        status != TaskStatus.done &&
        edges.any(
          (e) =>
              e.predecessorId == taskId &&
              tasks.any(
                (t) => t.id == e.successorId && t.status != TaskStatus.todo,
              ),
        )) {
      throw const AppException('Önce başlamış ardıl görevi geri alın.');
    }
    _tasks[index] = _tasks[index].withStatus(status);
  }
}

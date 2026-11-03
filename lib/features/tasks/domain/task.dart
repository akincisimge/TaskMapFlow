enum TaskStatus { todo, inProgress, done }

class Task {
  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    this.status = TaskStatus.todo,
    this.assignee = 'Atanmadı',
    this.parentTaskId,
  });
  final String id;
  final String projectId;
  final String title;
  final TaskStatus status;
  final String assignee;
  final String? parentTaskId;
  Task withStatus(TaskStatus value) => Task(
    id: id,
    projectId: projectId,
    title: title,
    status: value,
    assignee: assignee,
    parentTaskId: parentTaskId,
  );
}

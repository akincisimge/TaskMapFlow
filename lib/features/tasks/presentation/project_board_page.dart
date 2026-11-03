import 'package:flutter/material.dart';

import '../../projects/domain/project.dart';
import '../../dependencies/presentation/dependency_map.dart';
import '../domain/task.dart';
import '../domain/task_repository.dart';

String statusLabel(TaskStatus status) => switch (status) {
  TaskStatus.todo => 'Yapılacak',
  TaskStatus.inProgress => 'Devam ediyor',
  TaskStatus.done => 'Tamamlandı',
};

class ProjectBoardPage extends StatefulWidget {
  const ProjectBoardPage({
    super.key,
    required this.project,
    required this.repository,
  });
  final Project project;
  final TaskRepository repository;
  @override
  State<ProjectBoardPage> createState() => _ProjectBoardPageState();
}

class _ProjectBoardPageState extends State<ProjectBoardPage> {
  bool _map = false;
  Future<void> _addTask() async {
    var input = '';
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni görev'),
        content: TextField(
          onChanged: (value) => input = value,
          autofocus: true,
          maxLength: 120,
          decoration: const InputDecoration(labelText: 'Görev başlığı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, input),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (title == null || !mounted) return;
    try {
      setState(() => widget.repository.createTask(widget.project.id, title));
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasksFor(widget.project.id);
    final edges = widget.repository.dependenciesFor(widget.project.id);
    final done = tasks.where((t) => t.status == TaskStatus.done).length;
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$done / ${tasks.length} görev tamamlandı · Yerel demo'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: tasks.isEmpty ? 0 : done / tasks.length,
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Görevler'),
                  icon: Icon(Icons.view_list_outlined),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Harita'),
                  icon: Icon(Icons.account_tree_outlined),
                ),
              ],
              selected: {_map},
              onSelectionChanged: (value) =>
                  setState(() => _map = value.single),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text('Henüz görev yok. Bir görev ekleyin.'),
                    )
                  : _map
                  ? DependencyMap(tasks: tasks, edges: edges)
                  : ListView(
                      children: [
                        for (final task in tasks)
                          Card(
                            child: ListTile(
                              title: Text(task.title),
                              subtitle: Text(
                                '${task.assignee} · ${statusLabel(task.status)}',
                              ),
                              trailing: PopupMenuButton<TaskStatus>(
                                tooltip: 'Görev durumunu değiştir',
                                onSelected: (status) {
                                  try {
                                    setState(
                                      () => widget.repository.changeStatus(
                                        widget.project.id,
                                        task.id,
                                        status,
                                      ),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$error')),
                                    );
                                  }
                                },
                                itemBuilder: (_) => [
                                  for (final status in TaskStatus.values)
                                    PopupMenuItem(
                                      value: status,
                                      child: Text(statusLabel(status)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Görev ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

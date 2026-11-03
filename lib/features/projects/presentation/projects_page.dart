import 'package:flutter/material.dart';

import '../domain/project.dart';
import '../domain/project_repository.dart';
import '../../tasks/domain/task_repository.dart';
import '../../tasks/presentation/project_board_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, required this.projects, required this.tasks});
  final ProjectRepository projects;
  final TaskRepository tasks;
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late final Stream<List<Project>> _projects = widget.projects.watchProjects();
  Future<void> _addProject() async {
    var input = '';
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni proje'),
        content: TextField(
          onChanged: (value) => input = value,
          autofocus: true,
          maxLength: 100,
          decoration: const InputDecoration(labelText: 'Proje adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, input),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
    if (name == null || !mounted) return;
    try {
      await widget.projects.createProject(
        name,
        requestId: 'local-${DateTime.now().microsecondsSinceEpoch}',
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TaskMapFlow')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Projelerim',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Yerel demo · Veriler uygulama kapanınca silinir. Firebase bağlantısı henüz etkin değil.',
              ),
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<List<Project>>(
                  stream: _projects,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Projeler yüklenemedi.'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final projects = snapshot.data!;
                    if (projects.isEmpty) {
                      return const Center(
                        child: Text(
                          'Henüz proje yok. Yeni bir proje oluşturun.',
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: projects.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.account_tree_outlined),
                          title: Text(projects[i].name),
                          subtitle: const Text(
                            'Görevler ve bağımlılık haritası',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ProjectBoardPage(
                                project: projects[i],
                                repository: widget.tasks,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _addProject,
      icon: const Icon(Icons.add),
      label: const Text('Yeni proje'),
    ),
  );
}

import 'package:flutter/material.dart';

import '../features/projects/data/demo_project_repository.dart';
import '../features/projects/presentation/projects_page.dart';
import '../features/tasks/data/demo_task_repository.dart';

class TaskMapFlowApp extends StatefulWidget {
  const TaskMapFlowApp({super.key});
  @override
  State<TaskMapFlowApp> createState() => _TaskMapFlowAppState();
}

class _TaskMapFlowAppState extends State<TaskMapFlowApp> {
  final _projects = DemoProjectRepository();
  final _tasks = DemoTaskRepository();
  @override
  void dispose() {
    _projects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TaskMapFlow',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3151B7)),
      useMaterial3: true,
    ),
    home: ProjectsPage(projects: _projects, tasks: _tasks),
  );
}

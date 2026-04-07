import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../services/task_controller.dart';
import '../widgets/section_header.dart';
import '../widgets/task_card.dart';

class TodayTasksScreen extends StatelessWidget {
  const TodayTasksScreen({
    super.key,
    required this.onCreateTask,
    required this.onEditTask,
  });

  final VoidCallback onCreateTask;
  final ValueChanged<Task> onEditTask;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskController>();
    final tasks = controller.todayTasks;

    return TasksScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Today Task',
            subtitle: 'Tasks due today with live progress and reminders.',
            action: FilledButton.icon(
              onPressed: onCreateTask,
              icon: const Icon(Icons.add),
              label: const Text('New'),
            ),
          ),
          const SizedBox(height: 18),
          if (controller.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (tasks.isEmpty)
            const Expanded(
              child: EmptyState(
                title: 'No tasks for today',
                subtitle: 'Create one to populate the Today section.',
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onEdit: () => onEditTask(task),
                    onDelete: () => controller.deleteTask(task),
                    onToggleComplete: (value) =>
                        controller.toggleTaskCompletion(task, value),
                    onToggleSubTask: (subTask, value) =>
                        controller.toggleSubTask(task, subTask, value),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TasksScaffold extends StatelessWidget {
  const TasksScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(Theme.of(context).brightness),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: child,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../services/task_controller.dart';
import '../widgets/section_header.dart';
import '../widgets/task_card.dart';
import 'today_tasks_screen.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({
    super.key,
    required this.onEditTask,
  });

  final ValueChanged<Task> onEditTask;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskController>();
    final tasks = controller.completedTasks;

    return TasksScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Completed Task',
            subtitle: 'Finished work, stored separately for quick review.',
          ),
          const SizedBox(height: 18),
          if (controller.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (tasks.isEmpty)
            const Expanded(
              child: EmptyState(
                title: 'Nothing completed yet',
                subtitle: 'Completed tasks will move here automatically.',
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

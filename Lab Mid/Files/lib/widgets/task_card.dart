import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onToggleSubTask,
  });

  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleComplete;
  final void Function(SubTask subTask, bool isCompleted) onToggleSubTask;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressColor = task.isCompleted ? Colors.green : colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Badge(
                            icon: Icons.schedule_rounded,
                            label: DateFormat('dd MMM • hh:mm a')
                                .format(task.dueDate),
                          ),
                          _Badge(
                            icon: Icons.repeat_rounded,
                            label: switch (task.repeatType) {
                              RepeatType.none => 'One-time',
                              RepeatType.daily => 'Daily',
                              RepeatType.weeklyCustom => 'Custom week',
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(task.title, style: theme.textTheme.titleLarge),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          task.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => onToggleComplete(value ?? false),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: task.progress,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Progress ${task.progressPercent}% • Sound ${task.notificationSound}',
              style: theme.textTheme.bodyMedium,
            ),
            if (task.subTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (final subTask in task.subTasks)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: subTask.isCompleted,
                  title: Text(subTask.title),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) =>
                      onToggleSubTask(subTask, value ?? false),
                ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

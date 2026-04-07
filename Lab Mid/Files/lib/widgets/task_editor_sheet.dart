import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.repeatType,
    required this.repeatWeekdays,
    required this.subTasks,
    required this.notificationSound,
  });

  final String title;
  final String description;
  final DateTime dueDate;
  final RepeatType repeatType;
  final List<int> repeatWeekdays;
  final List<SubTask> subTasks;
  final String notificationSound;
}

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    this.task,
    required this.defaultSound,
  });

  final Task? task;
  final String defaultSound;

  static Future<TaskDraft?> show(
    BuildContext context, {
    Task? task,
    required String defaultSound,
  }) {
    return showModalBottomSheet<TaskDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TaskEditorSheet(task: task, defaultSound: defaultSound);
      },
    );
  }

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _dueDate;
  late RepeatType _repeatType;
  late List<int> _repeatWeekdays;
  late List<SubTask> _subTasks;
  late String _notificationSound;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(hours: 2));
    _repeatType = task?.repeatType ?? RepeatType.none;
    _repeatWeekdays = List<int>.from(task?.repeatWeekdays ?? <int>[]);
    _subTasks = List<SubTask>.from(task?.subTasks ?? <SubTask>[]);
    _notificationSound = task?.notificationSound ?? widget.defaultSound;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + insets),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 64,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.task == null ? 'Create Task' : 'Edit Task',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Capture title, reminders, repeat rules, and progress subtasks.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Due date & time'),
                  subtitle: Text(
                    '${MaterialLocalizations.of(context).formatFullDate(_dueDate)} • '
                    '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(_dueDate))}',
                  ),
                  trailing: FilledButton(
                    onPressed: _pickDateTime,
                    child: const Text('Change'),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RepeatType>(
                  initialValue: _repeatType,
                  decoration: const InputDecoration(labelText: 'Repeat'),
                  items: const [
                    DropdownMenuItem(
                      value: RepeatType.none,
                      child: Text('Do not repeat'),
                    ),
                    DropdownMenuItem(
                      value: RepeatType.daily,
                      child: Text('Repeat daily'),
                    ),
                    DropdownMenuItem(
                      value: RepeatType.weeklyCustom,
                      child: Text('Repeat on selected weekdays'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _repeatType = value ?? RepeatType.none;
                    });
                  },
                ),
                if (_repeatType == RepeatType.weeklyCustom) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(7, (index) {
                      final weekday = index + 1;
                      final selected = _repeatWeekdays.contains(weekday);
                      const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      return FilterChip(
                        selected: selected,
                        label: Text(labels[index]),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _repeatWeekdays.add(weekday);
                            } else {
                              _repeatWeekdays.remove(weekday);
                            }
                            _repeatWeekdays.sort();
                          });
                        },
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _notificationSound,
                  decoration:
                      const InputDecoration(labelText: 'Notification sound'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Default',
                      child: Text('Default'),
                    ),
                    DropdownMenuItem(
                      value: 'Soft Bell',
                      child: Text('Soft Bell'),
                    ),
                    DropdownMenuItem(
                      value: 'Focus Ping',
                      child: Text('Focus Ping'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _notificationSound = value ?? 'Default';
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Subtasks',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addSubtask,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (_subTasks.isEmpty)
                  Text(
                    'Add subtasks to unlock progress tracking.',
                    style: theme.textTheme.bodyMedium,
                  ),
                for (var i = 0; i < _subTasks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _subTasks[i].title,
                            decoration: InputDecoration(
                              labelText: 'Subtask ${i + 1}',
                            ),
                            onChanged: (value) {
                              _subTasks[i] = _subTasks[i].copyWith(title: value);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _subTasks.removeAt(i);
                            });
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child:
                        Text(widget.task == null ? 'Create task' : 'Save task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (time == null) {
      return;
    }

    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _addSubtask() async {
    setState(() {
      _subTasks.add(SubTask(id: _uuid.v4(), title: ''));
    });
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    if (_repeatType == RepeatType.weeklyCustom && _repeatWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one weekday.')),
      );
      return;
    }

    final cleanedSubtasks = _subTasks
        .where((item) => item.title.trim().isNotEmpty)
        .map((item) => item.copyWith(title: item.title.trim()))
        .toList();

    Navigator.of(context).pop(
      TaskDraft(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        repeatType: _repeatType,
        repeatWeekdays: _repeatWeekdays,
        subTasks: cleanedSubtasks,
        notificationSound: _notificationSound,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/theme_controller.dart';
import '../models/task.dart';
import '../services/task_controller.dart';
import '../widgets/task_editor_sheet.dart';
import 'completed_tasks_screen.dart';
import 'repeated_tasks_screen.dart';
import 'settings_screen.dart';
import 'today_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final themeController = context.watch<ThemeController>();

    final pages = [
      TodayTasksScreen(
        onCreateTask: () => _openEditor(context),
        onEditTask: (task) => _openEditor(context, task: task),
      ),
      CompletedTasksScreen(
        onEditTask: (task) => _openEditor(context, task: task),
      ),
      RepeatedTasksScreen(
        onEditTask: (task) => _openEditor(context, task: task),
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE5FFF8),
              Color(0xFFF9F5EF),
              Color(0xFFEAF1FF),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                child: _HeroHeader(
                  pendingCount: taskController.pendingCount,
                  overallProgress: taskController.overallProgress,
                  themeLabel: switch (themeController.themeMode) {
                    ThemeMode.dark => 'Dark',
                    ThemeMode.light => 'Light',
                    ThemeMode.system => 'System',
                  },
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: pages[_currentIndex],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 3
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openEditor(context),
              icon: const Icon(Icons.add_task_rounded),
              label: const Text('Add Task'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Repeated',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {Task? task}) async {
    final themeController = context.read<ThemeController>();
    final taskController = context.read<TaskController>();
    final draft = await TaskEditorSheet.show(
      context,
      task: task,
      defaultSound: themeController.soundProfile,
    );

    if (!context.mounted || draft == null) {
      return;
    }

    if (task == null) {
      await taskController.addTask(
        title: draft.title,
        description: draft.description,
        dueDate: draft.dueDate,
        repeatType: draft.repeatType,
        repeatWeekdays: draft.repeatWeekdays,
        subTasks: draft.subTasks,
        notificationSound: draft.notificationSound,
      );
      return;
    }

    await taskController.updateTask(
      task.copyWith(
        title: draft.title,
        description: draft.description,
        dueDate: draft.dueDate,
        repeatType: draft.repeatType,
        repeatWeekdays: draft.repeatWeekdays,
        subTasks: draft.subTasks,
        notificationSound: draft.notificationSound,
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.pendingCount,
    required this.overallProgress,
    required this.themeLabel,
  });

  final int pendingCount;
  final double overallProgress;
  final String themeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (overallProgress * 100).round();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A7C86), Color(0xFF19B7AE)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220A7C86),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TaskFlow Pro',
            style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'A stylish Android planner with SQLite, repeats, reminders, exports, and progress tracking.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(label: 'Pending', value: '$pendingCount'),
              ),
              Expanded(
                child: _HeaderStat(label: 'Progress', value: '$percent%'),
              ),
              Expanded(
                child: _HeaderStat(label: 'Theme', value: themeLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

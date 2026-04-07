import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/theme_controller.dart';
import '../services/task_controller.dart';
import '../widgets/section_header.dart';
import 'today_tasks_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final taskController = context.watch<TaskController>();

    return TasksScaffold(
      child: ListView(
        children: [
          const SectionHeader(
            title: 'Settings & Export',
            subtitle: 'Theme, sound, CSV, PDF, and email delivery options.',
          ),
          const SizedBox(height: 20),
          Text('Theme mode', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            selected: {themeController.themeMode},
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.phone_android_outlined),
              ),
            ],
            onSelectionChanged: (selection) {
              themeController.setThemeMode(selection.first);
            },
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: themeController.soundProfile,
            decoration:
                const InputDecoration(labelText: 'Default notification sound'),
            items: const [
              DropdownMenuItem(value: 'Default', child: Text('Default')),
              DropdownMenuItem(value: 'Soft Bell', child: Text('Soft Bell')),
              DropdownMenuItem(value: 'Focus Ping', child: Text('Focus Ping')),
            ],
            onChanged: (value) {
              if (value != null) {
                themeController.setSoundProfile(value);
              }
            },
          ),
          const SizedBox(height: 24),
          Text('Export tasks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed:
                taskController.tasks.isEmpty ? null : taskController.exportCsv,
            icon: const Icon(Icons.table_chart_outlined),
            label: const Text('Export CSV'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed:
                taskController.tasks.isEmpty ? null : taskController.exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Export PDF'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed:
                taskController.tasks.isEmpty ? null : taskController.exportEmail,
            icon: const Icon(Icons.email_outlined),
            label: const Text('Share to Email'),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Testing checklist',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  const _CheckLine(text: 'SQLite-backed persistent tasks'),
                  const _CheckLine(text: 'Today, Completed, and Repeated views'),
                  const _CheckLine(text: 'Add, edit, delete, and mark complete'),
                  const _CheckLine(text: 'Subtask progress tracking'),
                  const _CheckLine(text: 'Theme and sound customization'),
                  const _CheckLine(text: 'CSV, PDF, and email export actions'),
                  const _CheckLine(text: 'Local reminder scheduling'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

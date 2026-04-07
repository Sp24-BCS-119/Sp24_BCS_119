import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/theme/theme_controller.dart';
import '../models/task.dart';
import 'database_service.dart';
import 'export_service.dart';
import 'notification_service.dart';

class TaskController extends ChangeNotifier {
  TaskController({
    required DatabaseService databaseService,
    required NotificationService notificationService,
    required ExportService exportService,
    required ThemeController themeController,
  })  : _databaseService = databaseService,
        _notificationService = notificationService,
        _exportService = exportService,
        _themeController = themeController;

  final DatabaseService _databaseService;
  final NotificationService _notificationService;
  final ExportService _exportService;
  final ThemeController _themeController;
  final Uuid _uuid = const Uuid();

  bool _isLoading = true;
  final List<Task> _tasks = <Task>[];

  bool get isLoading => _isLoading;
  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks
        .where((task) => !task.isCompleted && _isSameDay(task.dueDate, now))
        .toList();
  }

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> get repeatedTasks =>
      _tasks.where((task) => task.isRepeated && !task.isCompleted).toList();

  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;

  double get overallProgress {
    if (_tasks.isEmpty) {
      return 0;
    }
    return _tasks.fold<double>(0, (sum, task) => sum + task.progress) /
        _tasks.length;
  }

  Future<void> initialize() async {
    await _loadTasks();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required RepeatType repeatType,
    required List<int> repeatWeekdays,
    required List<SubTask> subTasks,
    String? notificationSound,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      repeatType: repeatType,
      repeatWeekdays: repeatWeekdays,
      subTasks: subTasks,
      notificationSound: notificationSound ?? _themeController.soundProfile,
    );
    await _saveTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _saveTask(task);
  }

  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere((item) => item.id == task.id);
    notifyListeners();
    await _databaseService.deleteTask(task.id);
    await _notificationService.cancelTask(task.id);
  }

  Future<void> toggleTaskCompletion(Task task, bool isCompleted) async {
    final updated = task.copyWith(
      isCompleted: isCompleted,
      lastCompletedAt: isCompleted ? DateTime.now() : null,
      clearLastCompletedAt: !isCompleted,
      subTasks: task.subTasks
          .map((subTask) => subTask.copyWith(isCompleted: isCompleted))
          .toList(),
    );
    await _saveTask(updated);
  }

  Future<void> toggleSubTask(Task task, SubTask subTask, bool isCompleted) async {
    final updatedSubtasks = task.subTasks
        .map(
          (item) => item.id == subTask.id
              ? item.copyWith(isCompleted: isCompleted)
              : item,
        )
        .toList();

    final completed = updatedSubtasks.isNotEmpty &&
        updatedSubtasks.every((item) => item.isCompleted);
    final updated = task.copyWith(
      subTasks: updatedSubtasks,
      isCompleted: completed,
      lastCompletedAt: completed ? DateTime.now() : null,
      clearLastCompletedAt: !completed,
    );
    await _saveTask(updated);
  }

  Future<void> exportCsv() => _exportService.exportCsv(_tasks);
  Future<void> exportPdf() => _exportService.exportPdf(_tasks);
  Future<void> exportEmail() => _exportService.exportEmail(_tasks);

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final fetched = await _databaseService.fetchTasks();
    _tasks
      ..clear()
      ..addAll(fetched);

    await _refreshRepeatingTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTask(Task task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }

    _sortTasks();
    notifyListeners();

    await _databaseService.upsertTask(task);
    await _notificationService.scheduleTask(task);
  }

  Future<void> _refreshRepeatingTasks() async {
    final now = DateTime.now();
    final updates = <Task>[];

    for (final task in _tasks.where((item) => item.isRepeated)) {
      if (!task.isCompleted) {
        await _notificationService.scheduleTask(task);
        continue;
      }

      final nextDueDate = _nextRepeatDate(task, now);
      if (nextDueDate != null) {
        final refreshed = task.copyWith(
          isCompleted: false,
          dueDate: nextDueDate,
          subTasks: task.subTasks
              .map((subTask) => subTask.copyWith(isCompleted: false))
              .toList(),
          clearLastCompletedAt: true,
        );
        updates.add(refreshed);
      }
    }

    for (final updated in updates) {
      final index = _tasks.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        _tasks[index] = updated;
        await _databaseService.upsertTask(updated);
        await _notificationService.scheduleTask(updated);
      }
    }

    _sortTasks();
  }

  DateTime? _nextRepeatDate(Task task, DateTime from) {
    if (task.repeatType == RepeatType.none) {
      return null;
    }

    DateTime candidate = task.dueDate;
    while (!candidate.isAfter(from)) {
      if (task.repeatType == RepeatType.daily) {
        candidate = candidate.add(const Duration(days: 1));
      } else {
        candidate = candidate.add(const Duration(days: 1));
        while (!task.repeatWeekdays.contains(candidate.weekday)) {
          candidate = candidate.add(const Duration(days: 1));
        }
      }
    }
    return candidate;
  }

  void _sortTasks() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

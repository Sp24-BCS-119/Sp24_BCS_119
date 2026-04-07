import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'services/export_service.dart';
import 'services/notification_service.dart';
import 'services/task_controller.dart';

class TaskFlowBootstrap {
  const TaskFlowBootstrap({
    required this.themeController,
    required this.taskController,
  });

  final ThemeController themeController;
  final TaskController taskController;

  static Future<TaskFlowBootstrap> initialize() async {
    final databaseService = DatabaseService();
    await databaseService.initialize();

    final notificationService = NotificationService();
    await notificationService.initialize();

    final exportService = ExportService();

    final themeController = ThemeController();
    await themeController.initialize();

    final taskController = TaskController(
      databaseService: databaseService,
      notificationService: notificationService,
      exportService: exportService,
      themeController: themeController,
    );
    await taskController.initialize();

    return TaskFlowBootstrap(
      themeController: themeController,
      taskController: taskController,
    );
  }
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key, required this.bootstrap});

  final TaskFlowBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(
          value: bootstrap.themeController,
        ),
        ChangeNotifierProvider<TaskController>.value(
          value: bootstrap.taskController,
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TaskFlow Pro',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

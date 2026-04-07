import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseService {
  static const _databaseName = 'taskflow.db';
  static const _tableName = 'tasks';

  Database? _database;

  Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, _databaseName);

    _database = await openDatabase(
      fullPath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            repeatType TEXT NOT NULL,
            repeatWeekdays TEXT NOT NULL,
            subTasks TEXT NOT NULL,
            notificationSound TEXT NOT NULL,
            lastCompletedAt TEXT
          )
        ''');
      },
    );
  }

  Future<List<Task>> fetchTasks() async {
    final rows = await _database!.query(_tableName, orderBy: 'dueDate ASC');
    return rows.map(Task.fromMap).toList();
  }

  Future<void> upsertTask(Task task) async {
    await _database!.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(String id) async {
    await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'dart:convert';

enum RepeatType { none, daily, weeklyCustom }

class SubTask {
  const SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final bool isCompleted;

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.createdAt,
    this.isCompleted = false,
    this.repeatType = RepeatType.none,
    this.repeatWeekdays = const <int>[],
    this.subTasks = const <SubTask>[],
    this.notificationSound = 'Default',
    this.lastCompletedAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime createdAt;
  final bool isCompleted;
  final RepeatType repeatType;
  final List<int> repeatWeekdays;
  final List<SubTask> subTasks;
  final String notificationSound;
  final DateTime? lastCompletedAt;

  bool get isRepeated => repeatType != RepeatType.none;

  double get progress {
    if (subTasks.isEmpty) {
      return isCompleted ? 1 : 0;
    }

    final done = subTasks.where((item) => item.isCompleted).length;
    return done / subTasks.length;
  }

  int get progressPercent => (progress * 100).round();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    bool? isCompleted,
    RepeatType? repeatType,
    List<int>? repeatWeekdays,
    List<SubTask>? subTasks,
    String? notificationSound,
    DateTime? lastCompletedAt,
    bool clearLastCompletedAt = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      repeatType: repeatType ?? this.repeatType,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      subTasks: subTasks ?? this.subTasks,
      notificationSound: notificationSound ?? this.notificationSound,
      lastCompletedAt: clearLastCompletedAt
          ? null
          : (lastCompletedAt ?? this.lastCompletedAt),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeatType': repeatType.name,
      'repeatWeekdays': jsonEncode(repeatWeekdays),
      'subTasks': jsonEncode(subTasks.map((item) => item.toJson()).toList()),
      'notificationSound': notificationSound,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, Object?> map) {
    final parsedSubtasks =
        jsonDecode(map['subTasks'] as String? ?? '[]') as List<dynamic>;
    final parsedWeekdays =
        jsonDecode(map['repeatWeekdays'] as String? ?? '[]') as List<dynamic>;

    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      dueDate: DateTime.parse(map['dueDate'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      repeatType: RepeatType.values.firstWhere(
        (item) => item.name == map['repeatType'],
        orElse: () => RepeatType.none,
      ),
      repeatWeekdays: parsedWeekdays.map((item) => item as int).toList(),
      subTasks: parsedSubtasks
          .map((item) => SubTask.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      notificationSound: map['notificationSound'] as String? ?? 'Default',
      lastCompletedAt: map['lastCompletedAt'] == null
          ? null
          : DateTime.tryParse(map['lastCompletedAt'] as String),
    );
  }
}

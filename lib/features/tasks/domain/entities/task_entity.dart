import '../../data/models/task.dart';

class TaskEntity {
  final int? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final TaskStatus status;
  final DateTime? reminderTime;
  final int? goalId;
  final int? milestoneId;

  TaskEntity({
    this.id = 0, // Isar autoIncrement
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.priority = Priority.medium,
    this.status = TaskStatus.pending,
    this.reminderTime,
    this.goalId,
    this.milestoneId,
  });

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    TaskStatus? status,
    DateTime? reminderTime,
    int? goalId,
    int? milestoneId,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      reminderTime: reminderTime ?? this.reminderTime,
      goalId: goalId ?? this.goalId,
      milestoneId: milestoneId ?? this.milestoneId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

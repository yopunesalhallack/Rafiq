import '../../data/models/task.dart';

class TaskEntity {
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final Priority priority;
  final TaskStatus status;
  final DateTime? reminderTime;
  final int? goalId;
  final int? milestoneId;

  TaskEntity({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = Priority.medium,
    this.status = TaskStatus.pending,
    this.reminderTime,
    this.goalId,
    this.milestoneId,
  });
}

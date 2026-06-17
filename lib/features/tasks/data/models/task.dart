import 'package:isar_community/isar.dart';

part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement; // مفتاح تلقائي
  late String title;
  String? description;
  DateTime? dueDate;
  @enumerated
  Priority priority = Priority.medium;
  @enumerated
  TaskStatus status = TaskStatus.pending;
  DateTime? reminderTime;
  bool reminderSent = false;
  int? goalId; // FK
  int? milestoneId; // FK
  DateTime createdAt = DateTime.now();
}

enum Priority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, postponed }

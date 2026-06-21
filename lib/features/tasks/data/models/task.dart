import 'package:isar_community/isar.dart';

part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;

  @Index()
  DateTime? dueDate;

  @enumerated
  Priority priority = Priority.medium;

  @enumerated
  TaskStatus status = TaskStatus.pending;

  DateTime? reminderTime;
  bool reminderSent = false;

  @Index()
  int? goalId;

  @Index()
  int? milestoneId;

  late DateTime createdAt;
}

enum Priority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, postponed }

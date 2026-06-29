import 'package:isar_community/isar.dart';
part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  String? serverId;
  bool isSynced = false;
  DateTime? lastUpdated;
  late String title;
  String? description;
  DateTime? dueDate;
  @enumerated
  Priority priority = Priority.medium;
  @enumerated
  TaskStatus status = TaskStatus.pending;
  int? goalId;
  DateTime createdAt = DateTime.now();
}

enum Priority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, postponed }

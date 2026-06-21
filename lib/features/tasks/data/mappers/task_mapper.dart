import 'package:isar_community/isar.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task.dart';

extension TaskModelMapper on Task {
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: status,
      reminderTime: reminderTime,
      goalId: goalId,
      milestoneId: milestoneId,
      createdAt: createdAt,
    );
  }
}

extension TaskEntityMapper on TaskEntity {
  Task toModel() {
    final model = Task()
      ..id = id ?? Isar.autoIncrement
      ..title = title
      ..description = description
      ..dueDate = dueDate
      ..priority = priority
      ..status = status
      ..reminderTime = reminderTime
      ..goalId = goalId
      ..milestoneId = milestoneId
      ..createdAt = createdAt;

    return model;
  }
}

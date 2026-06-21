import 'package:isar_community/isar.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task.dart';
import '../mappers/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Isar isar;

  TaskRepositoryImpl(this.isar);

  @override
  Future<void> addTask(TaskEntity task) async {
    final model = task.toModel()..createdAt = DateTime.now(); // مهم جداً

    await isar.writeTxn(() async {
      await isar.tasks.put(model);
    });
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = task.toModel();

    await isar.writeTxn(() async {
      await isar.tasks.put(model);
    });
  }

  @override
  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }

  @override
  Future<TaskEntity?> getTaskById(int id) async {
    final model = await isar.tasks.get(id);
    return model?.toEntity();
  }

  @override
  Future<List<TaskEntity>> getTasksForGoal(int goalId) async {
    final models = await isar.tasks.filter().goalIdEqualTo(goalId).findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTodayTasks() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final models = await isar.tasks
        .filter()
        .dueDateBetween(start, end)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasks({TaskFilter? filter}) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    List<Task> models;

    switch (filter ?? TaskFilter.all) {
      case TaskFilter.today:
        models = await isar.tasks.filter().dueDateBetween(start, end).findAll();
        break;

      case TaskFilter.upcoming:
        models = await isar.tasks.filter().dueDateGreaterThan(start).findAll();
        break;

      case TaskFilter.all:
        models = await isar.tasks.where().findAll();
        break;
    }

    return models.map((m) => m.toEntity()).toList();
  }
}

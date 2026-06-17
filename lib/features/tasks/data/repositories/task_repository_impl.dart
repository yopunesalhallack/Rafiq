import 'package:isar_community/isar.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Isar isar;

  TaskRepositoryImpl(this.isar);

  @override
  Future<void> addTask(TaskEntity task) async {
    final isarTask = Task()
      ..title = task.title
      ..description = task.description
      ..dueDate = task.dueDate
      ..priority = task.priority
      ..status = task.status
      ..reminderTime = task.reminderTime
      ..goalId = task.goalId
      ..milestoneId = task.milestoneId;
    await isar.writeTxn(() async {
      await isar.tasks.put(isarTask);
    });
  }

  @override
  Future<List<TaskEntity>> getTodayTasks() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final isarTasks = await isar.tasks
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .findAll();
    return isarTasks.map(_toEntity).toList();
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final existing = await isar.tasks.get(task.id!);
    if (existing != null) {
      existing.title = task.title;
      existing.description = task.description;
      existing.dueDate = task.dueDate;
      existing.priority = task.priority;
      existing.status = task.status;
      existing.reminderTime = task.reminderTime;
      await isar.writeTxn(() async {
        await isar.tasks.put(existing);
      });
    }
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(taskId);
    });
  }

  @override
  Future<List<TaskEntity>> getTasksForGoal(int goalId) async {
    final isarTasks = await isar.tasks.filter().goalIdEqualTo(goalId).findAll();
    return isarTasks.map(_toEntity).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(int id) async {
    final task = await isar.tasks.get(id);
    return task != null ? _toEntity(task) : null;
  }

  TaskEntity _toEntity(Task task) => TaskEntity(
    id: task.id,
    title: task.title,
    description: task.description,
    dueDate: task.dueDate,
    priority: task.priority,
    status: task.status,
    reminderTime: task.reminderTime,
    goalId: task.goalId,
    milestoneId: task.milestoneId,
  );
}

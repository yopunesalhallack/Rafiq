import 'package:isar_community/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task.dart';
import '../../../goals/data/models/goal.dart';

class TaskRepositoryImpl implements TaskRepository {
  final IsarService _isarService;
  TaskRepositoryImpl(this._isarService);

  Future<Isar> get _db async => await _isarService.db;

  // ==========================================================
  // Progress
  // ==========================================================
  Future<void> _updateGoalProgress(int? goalId) async {
    if (goalId == null) return; // check task  if  releated with goal

    final db = await _db;

    final allTasks = await db.tasks.where().findAll();

    final tasks = allTasks.where((t) => t.goalId == goalId).toList();

    final total = tasks.length;
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;

    final progress = total == 0 ? 0 : ((completed / total) * 100).round();

    final goal = await db.goals.where().idEqualTo(goalId).findFirst();
    if (goal != null) {
      goal.progressPercent = progress;
      await db.goals.put(goal);
    }
  }

  // ==========================================================
  //  CRUD & AI
  // ==========================================================
  @override
  Future<void> addTask(Task task) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.put(task);
      await _updateGoalProgress(task.goalId);
    });
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.put(task);
      await _updateGoalProgress(task.goalId);
    });
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final db = await _db;
    await db.writeTxn(() async {
      final task = await db.tasks.get(taskId);
      final goalId = task?.goalId;
      await db.tasks.delete(taskId);
      if (goalId != null) {
        await _updateGoalProgress(goalId);
      }
    });
  }

  @override
  Future<void> toggleTaskCompletion(int taskId) async {
    final db = await _db;
    await db.writeTxn(() async {
      final task = await db.tasks.get(taskId);
      if (task != null) {
        task.status = task.status == TaskStatus.completed
            ? TaskStatus.pending
            : TaskStatus.completed;
        await db.tasks.put(task);
        await _updateGoalProgress(task.goalId);
      }
    });
  }

  // ==========================================================
  //  watch  (Streams)
  // ==========================================================
  @override
  Stream<List<Task>> watchAllTasks() {
    final isarFuture = _isarService.db;
    return Stream.fromFuture(isarFuture).asyncExpand((isar) {
      return isar.tasks.where().watch(fireImmediately: true);
    });
  }

  @override
  Stream<List<Task>> watchTasksForGoal(int goalId) {
    final isarFuture = _isarService.db;
    return Stream.fromFuture(isarFuture).asyncExpand((isar) {
      // use filteration in memory
      return isar.tasks.where().watch(fireImmediately: true).map((tasks) {
        return tasks.where((t) => t.goalId == goalId).toList();
      });
    });
  }
}
